//
//  TYGCDANRMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/7.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYANRMonitor.h"

@interface TYGCDANRMonitor : NSObject<TYANRMonitor>

@property (nonatomic, weak) id<TYANRMonitorDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isRunning;

@property (nonatomic, assign, readonly) NSTimeInterval timeOutInterval; // 超时时间  default 0.2s

@property (nonatomic, assign, readonly) NSInteger timeOutCount; // 超时总次数 default 5次

- (instancetype)init;

- (instancetype)initWithTimeOutInterval:(double)timeOutInterval timeOutCount:(NSInteger)timeOutCount;

- (void)start;

- (void)stop;

@end
