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

@property (nonatomic, weak) id<TYLogMonitorDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isRunning; //  监控正在运行

- (void)start;

- (void)stop;

@end
