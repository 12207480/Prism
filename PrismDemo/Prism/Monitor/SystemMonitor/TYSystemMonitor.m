//
//  TYSystemMonitor.m
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYSystemMonitor.h"
#import "TYWeakProxy.h"

@interface TYSystemMonitor () {
    struct {
        unsigned int didUpdateUsage   :1;
        unsigned int didUpdateAppCPUUsage   :1;
        unsigned int didUpdateSystemCPUUsage   :1;
        unsigned int didUpdateAppMemoryUsage   :1;
        unsigned int didUpdateSystemMemoryUsage   :1;
        unsigned int didUpdateSystemNetworkFlow   :1;
    }_delegateFlags;
    ty_flow_IOBytes _networkFlow;
    ty_flow_IOBytes _startNetworkFlow;
    BOOL _isFisrtGetNetworkFlow;
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TYSystemMonitor

+ (TYSystemMonitor *)sharedInstance {
    static TYSystemMonitor *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _timeInterval = 1.0;
        _isFisrtGetNetworkFlow = YES;
    }
    return self;
}

- (void)addTimer {
    if (_timer) {
        [self removeTimer];
    }
    _timer = [NSTimer timerWithTimeInterval:_timeInterval target:[TYWeakProxy proxyWithTarget:self] selector:@selector(timerFire) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)setDelegate:(id<TYSystemMonitorDelegate>)delegate {
    BOOL immediatelyUpdate = _delegate == nil;
    _delegate = delegate;
    _delegateFlags.didUpdateUsage = [delegate respondsToSelector:@selector(systemMonitorDidUpdateUsage:)];
    _delegateFlags.didUpdateAppCPUUsage = [delegate respondsToSelector:@selector(systemMonitor:didUpdateAppCPUUsage:)];
    _delegateFlags.didUpdateSystemCPUUsage= [delegate respondsToSelector:@selector(systemMonitor:didUpdateSystemCPUUsage:)];
    _delegateFlags.didUpdateAppMemoryUsage = [delegate respondsToSelector:@selector(systemMonitor:didUpdateAppMemoryUsage:)];
    _delegateFlags.didUpdateSystemMemoryUsage = [delegate respondsToSelector:@selector(systemMonitor:didUpdateSystemMemoryUsage:)];
    _delegateFlags.didUpdateSystemNetworkFlow = [delegate respondsToSelector:@selector(systemMonitor:didUpdateNetworkFlowSent:received:total:)];
    if (immediatelyUpdate && [_timer isValid]) {
        [self timerFire];
    }
}

#pragma mark - public 

- (void)start {
    if (!_timer) {
        _startNetworkFlow = [TYNetworkFlow getFlowIOBytes];
    }
    [self addTimer];
}

- (void)stop {
    [self removeTimer];
}

#pragma mark - action

- (void)timerFire {
    if (_delegateFlags.didUpdateUsage) {
        [_delegate systemMonitorDidUpdateUsage:self];
    }
    if (_delegateFlags.didUpdateAppCPUUsage) {
        [_delegate systemMonitor:self didUpdateAppCPUUsage:[TYCPUUsage getAppCPUUsageStruct]];
    }
    if (_delegateFlags.didUpdateSystemCPUUsage) {
        [_delegate systemMonitor:self didUpdateSystemCPUUsage:[TYCPUUsage getSystemCPUUsageStruct]];
    }
    if (_delegateFlags.didUpdateAppMemoryUsage) {
        [_delegate systemMonitor:self didUpdateAppMemoryUsage:[TYMemoryUsage getAppMemoryUsage]];
    }
    if (_delegateFlags.didUpdateSystemMemoryUsage) {
        [_delegate systemMonitor:self didUpdateSystemMemoryUsage:[TYMemoryUsage getSystemMemoryUsageStruct]];
    }
    if (_delegateFlags.didUpdateSystemNetworkFlow) {
        ty_flow_IOBytes networkFlow = [TYNetworkFlow getFlowIOBytes];
        ty_flow_IOBytes startNetworkFlow;
        startNetworkFlow.wifiReceived = networkFlow.wifiReceived - _startNetworkFlow.wifiReceived;
        startNetworkFlow.wifiSent = networkFlow.wifiSent - _startNetworkFlow.wifiSent;
        startNetworkFlow.cellularSent = networkFlow.cellularSent - _startNetworkFlow.cellularSent;
        startNetworkFlow.cellularReceived = networkFlow.cellularReceived - _startNetworkFlow.cellularReceived;
        startNetworkFlow.totalReceived = networkFlow.totalReceived - _startNetworkFlow.totalReceived;
        startNetworkFlow.totalSent = networkFlow.totalSent - _startNetworkFlow.totalSent;
        if (!_isFisrtGetNetworkFlow) {
            [_delegate systemMonitor:self didUpdateNetworkFlowSent:networkFlow.totalSent - _networkFlow.totalSent received:networkFlow.totalReceived - _networkFlow.totalReceived total:startNetworkFlow];
        }
        _isFisrtGetNetworkFlow = NO;
        _networkFlow = networkFlow;
    }
}

- (void)dealloc {
    [self stop];
}

@end
