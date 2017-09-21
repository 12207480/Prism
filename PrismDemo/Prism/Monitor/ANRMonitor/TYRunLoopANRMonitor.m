//
//  TYRunLoopANRMonitor.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/5.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYRunLoopANRMonitor.h"
#import "__BSBacktraceLogger.h"

@interface TYRunLoopANRMonitor ()

@property (nonatomic, strong) NSHashTable *hashTable;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, assign) CFRunLoopObserverRef observer;

@property (nonatomic, assign) CFRunLoopActivity activity;

@property (nonatomic, strong) dispatch_queue_t queue;

@property (nonatomic, assign) NSInteger timeOutCount;

@property (nonatomic, assign) NSTimeInterval timeOutInterval;

@property (nonatomic, assign) NSInteger curTimeOutCount;

@end

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    TYRunLoopANRMonitor *monitor =  (__bridge TYRunLoopANRMonitor*)info;
    monitor.activity = activity;
    dispatch_semaphore_signal(monitor.semaphore);
}

@implementation TYRunLoopANRMonitor

+ (TYRunLoopANRMonitor *)sharedInstance {
    static TYRunLoopANRMonitor *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)initWithTimeOutInterval:(NSTimeInterval)timeOutInterval timeOutCount:(NSInteger)timeOutCount {
    if (self = [super init]) {
        _curTimeOutCount = 0;
        _timeOutInterval = timeOutInterval;
        _timeOutCount = timeOutCount;
        _queue = dispatch_queue_create("com.YeBlueColor.TYRunLoopANRMonitor", NULL);
    }
    return self;
}

- (instancetype)init {
    if (self = [self initWithTimeOutInterval:0.2 timeOutCount:5]) {
    }
    return self;
}

- (NSHashTable *)hashTable {
    if (!_hashTable) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    return _hashTable;
}

- (void)addDelegate:(id<TYANRMonitorDelegate>)delegate {
    [self.hashTable addObject:delegate];
}

- (void)removeDelegate:(id<TYANRMonitorDelegate>)delegate {
    [self.hashTable removeObject:delegate];
}

- (void)removeAllDelegates {
    [self.hashTable removeAllObjects];
}

#pragma mark - public

- (BOOL)isRunning {
    return _observer != NULL;
}

- (void)start {
    
    if (_observer) {
        return;
    }
    
    _semaphore = dispatch_semaphore_create(0);
    
    /*
     typedef struct {
     CFIndex	version;
     void *	info;
     const void *(*retain)(const void *info);
     void	(*release)(const void *info);
     CFStringRef	(*copyDescription)(const void *info);
     } CFRunLoopObserverContext;
     */
     CFRunLoopObserverContext context = {0,(__bridge void*)self,&CFRetain,&CFRelease};
    
    _observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(), kCFRunLoopAllActivities, true, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    dispatch_async(_queue, ^{
        while (YES) {
            long st = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, _timeOutInterval*1000*NSEC_PER_MSEC));
            if (st != 0) {
                if (!_observer) {
                    _curTimeOutCount = 0;
                    _activity = 0;
                    _semaphore = nil;
                    return ;
                }
                // 超时
                if (_activity == kCFRunLoopBeforeSources || _activity == kCFRunLoopAfterWaiting) {
                    if (++_curTimeOutCount < _timeOutCount) {
                        continue;
                    }
                    // 超时5*200ms
                    [self handleANRTimeOut];
                }
            }
            _curTimeOutCount = 0;
        }
    });
}

- (void)stop {
    if (!_observer) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
    _observer = NULL;
    _curTimeOutCount = 0;
    _activity = 0;
}

#pragma mark - handle timeout

- (void)handleANRTimeOut {
    if (!_hashTable) {
        return;
    }
    TYANRLogInfo *logInfo = [[TYANRLogInfo alloc]init];
    logInfo.content = [__BSBacktraceLogger bs_backtraceOfAllThread];
    logInfo.date = [NSDate date];
    logInfo.time = [logInfo.date timeIntervalSince1970];
    for (id<TYANRMonitorDelegate> delegate in _hashTable) {
        if ([delegate respondsToSelector:@selector(ANRMonitor:didRecievedANRTimeOutInfo:)]) {
            [delegate ANRMonitor:self didRecievedANRTimeOutInfo:logInfo];
        }
    }
}

- (void)dealloc {
    [self stop];
    [self removeAllDelegates];
}

@end
