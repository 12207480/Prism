//
//  TYANRMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/7.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYANRLogInfo.h"

@protocol TYANRMonitor;
@protocol TYANRMonitorDelegate <NSObject>

// async thread
- (void)ANRMonitor:(id<TYANRMonitor>)ANRMonitor didRecievedANRTimeOutInfo:(TYANRLogInfo *)ANRLogInfo;

@end

// Application Not Responding Monitor

@protocol TYANRMonitor <NSObject>

@property (nonatomic, assign, readonly) BOOL isRunning;

- (void)addDelegate:(id<TYANRMonitorDelegate>)delegate;

- (void)removeDelegate:(id<TYANRMonitorDelegate>)delegate;

- (void)start;

- (void)stop;

@end
