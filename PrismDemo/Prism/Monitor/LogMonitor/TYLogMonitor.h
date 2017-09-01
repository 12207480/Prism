//
//  TYLogMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/17.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYLogMessage.h"

@protocol TYLogMonitor;
@protocol TYLogMonitorDelegate <NSObject>

// async thread
- (void)logMonitor:(id<TYLogMonitor>)logMonitor didReceivedLogMsgs:(NSArray<TYLogMessage*> *)logMsgs;

@end

// System Log Monitor

@protocol TYLogMonitor <NSObject>

@property (nonatomic, assign, readonly) BOOL isRunning; //  监控正在运行

- (void)addDelegate:(id<TYLogMonitorDelegate>)delegate;

- (void)removeDelegate:(id<TYLogMonitorDelegate>)delegate;

- (void)start;

- (void)stop;

@end
