//
//  TYMemoryUsage.h
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    unsigned long long used_size;
    unsigned long long available_size;
    unsigned long long total_size;
}ty_system_memory_usage;

@interface TYMemoryUsage : NSObject

/**
 获取APP内存使用量 .byte
 */
+ (unsigned long long)getAppMemoryUsage;

/**
 获取系统内存使用量 .byte
 */
+ (unsigned long long)getSystemMemoryUsage;

/**
 获取系统可用内存量 .byte
 */
+ (unsigned long long)getSystemMemoryAvailable;

/**
 获取系统内存总量 .byte
 */
+ (unsigned long long)getSystemTotalMemory;

+ (ty_system_memory_usage)getSystemMemoryUsageStruct;

@end
