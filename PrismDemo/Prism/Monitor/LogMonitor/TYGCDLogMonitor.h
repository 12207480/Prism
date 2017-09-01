//
//  TYGCDLogMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/17.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYLogMonitor.h"

@interface TYGCDLogMonitor : NSObject<TYLogMonitor>

@property (nonatomic, assign) CGFloat timeInterval; // 监控定时器 时间间隔

@property (nonatomic, assign, readonly) BOOL isRunning; // 监控正在运行

+ (TYGCDLogMonitor *)sharedInstance;

- (void)addDelegate:(id<TYLogMonitorDelegate>)delegate;

- (void)removeDelegate:(id<TYLogMonitorDelegate>)delegate;

- (void)start;

- (void)stop;

@end
