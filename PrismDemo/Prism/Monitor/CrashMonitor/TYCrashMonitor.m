//
//  TYCrashMonitor.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCrashMonitor.h"

static NSUncaughtExceptionHandler *oldUncaughtExceptionHandler = NULL;
static BOOL isSetUncaughtHandler = NO;

@interface TYCrashMonitor ()

@property (nonatomic, assign) BOOL isRunning;

@end

@implementation TYCrashMonitor

+ (NSHashTable *)hashTable {
    static NSHashTable<TYCrashMonitor *> *hashTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hashTable = [NSHashTable weakObjectsHashTable];
    });
    return hashTable;
}

- (instancetype)init {
    if (self = [super init]) {
        _isRunning = NO;
    }
    return self;
}

#pragma mark - public

- (void)start {
    if (_isRunning) {
        return;
    }
    _isRunning = YES;
    ty_hashTableAddObject(self);
}

- (void)stop {
    if (!_isRunning) {
        return;
    }
    _isRunning = NO;
    ty_hashTableRemoveObject(self);
}

- (NSString *)getAppInfo {
    NSString *appInfo = [NSString stringWithFormat:@"App : %@ %@(%@)\nDevice : %@\nOS Version : %@ %@\n",       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].systemVersion];
    NSLog(@"Crash!!!! %@", appInfo);
    return appInfo;
}

#pragma mark - private

- (NSString *)signalName:(int)signal {
    switch (signal) {
        case SIGABRT:
            return @"SIGABRT";
        case SIGILL:
            return @"SIGILL";
        case SIGSEGV:
            return @"SIGSEGV";
        case SIGFPE:
            return @"SIGFPE";
        case SIGBUS:
            return @"SIGBUS";
        case SIGPIPE:
            return @"SIGPIPE";
        default:
            return @"UNKNOWN";
    }
}

#pragma mark - NSHashTable

void ty_startUncaughtCrashHandlerIfNeed() {
    if ([TYCrashMonitor hashTable].count > 0) {
        ty_installUncaughtCrashHandler();
    }
}

void ty_stopUncaughtCrashHandlerIfNeed() {
    if ([TYCrashMonitor hashTable].count == 0) {
        ty_uninstallUncaughtCrashHandler();
    }
}

void ty_hashTableAddObject(TYCrashMonitor *object) {
    if (object) {
        [[TYCrashMonitor hashTable] addObject:(object)];
        ty_startUncaughtCrashHandlerIfNeed();
    }
}

void ty_hashTableRemoveObject(TYCrashMonitor *object) {
    if (object) {
        [[TYCrashMonitor hashTable] removeObject:(object)];
        ty_stopUncaughtCrashHandlerIfNeed();
    }
}

#pragma mark - uncaughtCrashHandler

void ty_installUncaughtCrashHandler() {
    if (isSetUncaughtHandler) {
        return;
    }
    isSetUncaughtHandler = YES;
    
    oldUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler (uncaughtExceptionHandler);
    
    signal(SIGABRT, uncaughtSignalHandler);
    signal(SIGILL, uncaughtSignalHandler);
    signal(SIGSEGV, uncaughtSignalHandler);
    signal(SIGFPE, uncaughtSignalHandler);
    signal(SIGBUS, uncaughtSignalHandler);
    signal(SIGPIPE, uncaughtSignalHandler);
}

void ty_uninstallUncaughtCrashHandler() {
    if (!isSetUncaughtHandler) {
        return;
    }
    isSetUncaughtHandler = NO;
    
    NSSetUncaughtExceptionHandler (oldUncaughtExceptionHandler);
    
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

void uncaughtExceptionHandler(NSException *exception) {
    if (oldUncaughtExceptionHandler) {
        oldUncaughtExceptionHandler(exception);
    }
    
    for (TYCrashMonitor *monitor in [TYCrashMonitor hashTable]) {
        if (monitor.isRunning && [monitor respondsToSelector:@selector(uncaughtExceptionHandler:)]) {
            [monitor uncaughtExceptionHandler:exception];
        }
    }
}

void uncaughtSignalHandler(int signal) {
    for (TYCrashMonitor *monitor in [TYCrashMonitor hashTable]) {
        if (monitor.isRunning && [monitor respondsToSelector:@selector(uncaughtSignalHandler:)]) {
            [monitor uncaughtSignalHandler:signal];
        }
    }
}

- (void)uncaughtExceptionHandler:(NSException *)exception {
    if (_delegate && [_delegate respondsToSelector:@selector(crashMonitor:didCatchExceptionInfo:)]) {
        TYCrashInfo *info = [[TYCrashInfo alloc]init];
        info.date = [NSDate date];
        info.signal = kTYCrashException;
        info.exception = exception;
        info.name = exception.name;
        info.reason = exception.reason;
        info.callBackTrace = [exception.callStackSymbols componentsJoinedByString:@"\n"];
        [_delegate crashMonitor:self didCatchExceptionInfo:info];
    }
}

- (void)uncaughtSignalHandler:(int)signal {
    if (_delegate && [_delegate respondsToSelector:@selector(crashMonitor:didCatchExceptionInfo:)]) {
        NSMutableArray *callStackSymbols = [[NSThread callStackSymbols] mutableCopy];
        if (callStackSymbols.count > 2) {
            [callStackSymbols removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
        }
        TYCrashInfo *info = [[TYCrashInfo alloc]init];
        info.date = [NSDate date];
        info.signal = signal;
        info.name = [self signalName:signal];
        info.reason = [NSString stringWithFormat:@"Signal %@ crash.",
                       [self signalName:signal]];
        info.callBackTrace = [callStackSymbols componentsJoinedByString:@"\n"];
        [_delegate crashMonitor:self didCatchExceptionInfo:info];
    }
    [self stop];
    kill(getpid(), SIGKILL);
}

- (void)dealloc {
    [self stop];
}

//#include <libkern/OSAtomic.h>
//#include <execinfo.h>
//NSArray* ty_uncaughtCallStackSymbols() {
//    void* callstack[128];
//    int frames = backtrace(callstack, 128);
//    char **strs = backtrace_symbols(callstack, frames);
//    int i;
//    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
//    for (i = 0;i < frames;i++){
//        
//        
//        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
//    }
//    free(strs);
//    return backtrace;
//}

@end

@implementation TYCrashInfo

@end
