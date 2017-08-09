//
//  TYSystemMonitor.m
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYSystemMonitor.h"
#import "TYGCDTimer.h"

@interface TYSystemMonitor () {
    struct {
        unsigned int didUpdateUsage   :1;
        unsigned int didUpdateAppCPUUsage   :1;
        unsigned int didUpdateSystemCPUUsage   :1;
    }_delegateFlags;
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
    }
    return self;
}

- (void)addTimer {
    if (_timer) {
        [self removeTimer];
    }
    _timer = [NSTimer timerWithTimeInterval:_timeInterval target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
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
    _delegate = delegate;
    _delegateFlags.didUpdateUsage = [delegate respondsToSelector:@selector(systemMonitorDidUpdateUsage:)];
    _delegateFlags.didUpdateAppCPUUsage = [delegate respondsToSelector:@selector(systemMonitor:didUpdateAppCPUUsage:)];
    _delegateFlags.didUpdateSystemCPUUsage= [delegate respondsToSelector:@selector(systemMonitor:didUpdateSystemCPUUsage:)];
}

#pragma mark - public 

- (void)start {
    [self addTimer];
}

- (void)stop {
    [self removeTimer];
}


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
}

- (void)dealloc {
    [self stop];
}

@end
