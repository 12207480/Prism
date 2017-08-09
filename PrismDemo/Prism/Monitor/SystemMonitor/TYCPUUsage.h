//
//  TYCPUUsage.h
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct ty_system_cpu_usage {
    float user;         /* user state cpu usage percentage*/
    float system;
    float nice;
    float idle;
}ty_system_cpu_usage;

typedef struct ty_app_cpu_usage {
    long user_time;        /* user run time */
    long system_time;    /* system run time */
    float cpu_usage;        /* cpu usage percentage */
}ty_app_cpu_usage;

@interface TYCPUUsage : NSObject

/**
 get app cpu usage ,if failed return 0
 */
+ (float)getAppCPUUsage;

/**
 get system cpu usage ,if failed return 0
 */
+ (float)getSystemCPUUsage;

+ (ty_app_cpu_usage)getAppCPUUsageStruct;

+ (ty_system_cpu_usage)getSystemCPUUsageStruct;

@end
