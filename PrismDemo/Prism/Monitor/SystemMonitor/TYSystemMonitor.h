//
//  TYSystemMonitor.h
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYCPUUsage.h"

@class TYSystemMonitor;
@protocol TYSystemMonitorDelegate <NSObject>

// CPU Usage

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateAppCPUUsage:(ty_app_cpu_usage)app_cpu_usage;
- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateSystemCPUUsage:(ty_system_cpu_usage)system_cpu_usage;



@end

@interface TYSystemMonitor : NSObject

@property (nonatomic, weak) id<TYSystemMonitorDelegate> delegate;

@end
