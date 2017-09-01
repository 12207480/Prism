//
//  TYNetWorkMonitor.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetWorkMonitor.h"
#import "TYURLProtocol.h"

@interface TYNetWorkMonitor ()<TYURLProtocolDelegate>
@property (nonatomic, strong) NSHashTable *hashTable;
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation TYNetWorkMonitor

+ (TYNetWorkMonitor *)sharedInstance {
    static TYNetWorkMonitor *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init {
    if (self = [super init]) {
        _isRunning = NO;
    }
    return self;
}

- (NSHashTable *)hashTable {
    if (!_hashTable) {
        _hashTable = [NSHashTable weakObjectsHashTable];
    }
    return _hashTable;
}

- (void)addDelegate:(id<TYNetWorkMonitorDelegate>)delegate {
    [self.hashTable addObject:delegate];
}

- (void)removeDelegate:(id<TYNetWorkMonitorDelegate>)delegate {
    [self.hashTable removeObject:delegate];
}

- (void)removeAllDelegates {
    [self.hashTable removeAllObjects];
}

#pragma mark - public

- (void)start {
    if (_isRunning) {
        return;
    }
    _isRunning = YES;
    [TYURLProtocol addDelegate:self];
}

- (void)stop {
    if (!_isRunning) {
        return;
    }
    _isRunning = NO;
    [TYURLProtocol removeDelegate:self];
}

#pragma mark - TYURLProtocolDelegate

- (void)URLProtocolDidCatchURLRequest:(TYURLProtocol *)URLProtocol {
    if (!_hashTable) {
        return;
    }
    TYNetWorkInfo *info = [[TYNetWorkInfo alloc]init];
    info.startDate = URLProtocol.startDate;
    info.endDate = URLProtocol.endDate;
    info.time = URLProtocol.startDate.timeIntervalSince1970;
    info.during = [URLProtocol.endDate timeIntervalSinceDate:URLProtocol.startDate];
    info.request = URLProtocol.ty_request;
    info.response = (NSHTTPURLResponse *)URLProtocol.ty_response;
    info.data = [URLProtocol.ty_data copy];
    
    for (id<TYNetWorkMonitorDelegate> delegate in _hashTable) {
        if ([delegate respondsToSelector:@selector(netWorkMonitor:didCatchNetWorkInfo:)]) {
            [delegate netWorkMonitor:self didCatchNetWorkInfo:info];
        }
    }
}

- (void)dealloc {
    [self stop];
    [self removeAllDelegates];
}

@end
