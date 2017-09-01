//
//  TYRunLoopANRMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/5.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYANRMonitor.h"

@interface TYRunLoopANRMonitor : NSObject<TYANRMonitor>

@property (nonatomic, assign, readonly) BOOL isRunning;

@property (nonatomic, assign, readonly) NSTimeInterval timeOutInterval; // 超时时间  default 0.2s

@property (nonatomic, assign, readonly) NSInteger timeOutCount; // 超时次数 default 5次

+ (TYRunLoopANRMonitor *)sharedInstance;

- (instancetype)init;

- (instancetype)initWithTimeOutInterval:(double)timeOutInterval timeOutCount:(NSInteger)timeOutCount;

- (void)addDelegate:(id<TYANRMonitorDelegate>)delegate;

- (void)removeDelegate:(id<TYANRMonitorDelegate>)delegate;

- (void)start;

- (void)stop;

@end
