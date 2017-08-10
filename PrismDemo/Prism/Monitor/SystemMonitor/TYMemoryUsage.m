//
//  TYMemoryUsage.m
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYMemoryUsage.h"
#import <mach/mach.h>
#import <sys/sysctl.h>
#import <mach-o/arch.h>

@implementation TYMemoryUsage

+ (unsigned long long)getAppMemoryUsage {
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    kern_return_t kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&info, &count);
    if (kr != KERN_SUCCESS) {
        return 0;
    }
    return info.resident_size;
}

+ (ty_system_memory_usage)getSystemMemoryUsageStruct {
    vm_statistics64_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kr = host_statistics(mach_host_self(),
                                       HOST_VM_INFO,
                                       (host_info_t)&vmStats,
                                       &infoCount);
    
    ty_system_memory_usage system_memory_usage = {0,0,0};
    if (kr != KERN_SUCCESS) {
        return system_memory_usage;
    }
    system_memory_usage.used_size = (vmStats.active_count+vmStats.wire_count)*vm_kernel_page_size;
    system_memory_usage.available_size = (vmStats.free_count+vmStats.inactive_count)*vm_kernel_page_size;
    system_memory_usage.total_size = [NSProcessInfo processInfo].physicalMemory;
    return system_memory_usage;
}

+ (unsigned long long)getSystemMemoryUsage {
    ty_system_memory_usage system_memory_usage = [self getSystemMemoryUsageStruct];
    return system_memory_usage.used_size;
}

+ (unsigned long long)getSystemMemoryAvailable {
    ty_system_memory_usage system_memory_usage = [self getSystemMemoryUsageStruct];
    return system_memory_usage.available_size;
}

+ (unsigned long long)getSystemTotalMemory {
    return [NSProcessInfo processInfo].physicalMemory;
}

@end
