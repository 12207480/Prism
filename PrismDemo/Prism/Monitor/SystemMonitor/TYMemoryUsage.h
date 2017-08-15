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

// memory usge is different to xcode
@interface TYMemoryUsage : NSObject

/**
 get app used memory .byte
 */
+ (unsigned long long)getAppMemoryUsage;

/**
 get system used memory .byte
 */
+ (unsigned long long)getSystemMemoryUsage;

/**
 get system available memory .byte
 */
+ (unsigned long long)getSystemMemoryAvailable;

/**
 get system total memory .byte
 */
+ (unsigned long long)getSystemTotalMemory;

+ (ty_system_memory_usage)getSystemMemoryUsageStruct;

@end
