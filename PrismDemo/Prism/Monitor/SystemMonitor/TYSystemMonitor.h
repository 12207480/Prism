//
//  TYSystemMonitor.h
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYCPUUsage.h"
#import "TYMemoryUsage.h"
#import "TYDiskUsage.h"
#import "TYNetworkFlow.h"
#import "TYDeviceInfo.h"
#import "TYFPSLabel.h"

@class TYSystemMonitor;
@protocol TYSystemMonitorDelegate <NSObject>
@optional
// monitor timer 
- (void)systemMonitorDidUpdateUsage:(TYSystemMonitor *)systemMonitor;

// CPU Usage

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateAppCPUUsage:(ty_app_cpu_usage)app_cpu_usage;
- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateSystemCPUUsage:(ty_system_cpu_usage)system_cpu_usage;

// Memory Usage

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateAppMemoryUsage:(unsigned long long)app_memory_usage;
- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateSystemMemoryUsage:(ty_system_memory_usage)system_memory_usage;

// network flow

/**
 网络流量监控
 @param sent 上行 byte/timeInterval
 @param received 下行 byte/timeInterval
 */
- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateNetworkFlowSent:(unsigned int)sent received:(unsigned int)received total:(ty_flow_IOBytes)total;

@end

@interface TYSystemMonitor : NSObject

@property (nonatomic, weak) id<TYSystemMonitorDelegate> delegate;

@property (nonatomic, assign) float timeInterval; // default 1s

+ (TYSystemMonitor *)sharedInstance;

- (void)start;

- (void)stop;

@end
