//
//  TYCPUUsage.m
//  PrismDemo
//
//  Created by tany on 2017/8/9.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCPUUsage.h"
#import <mach/mach.h>
#import <sys/sysctl.h>
#import <mach-o/arch.h>

@implementation TYCPUUsage

+ (ty_app_cpu_usage)getAppCPUUsageStruct {
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count = TASK_INFO_MAX;
    ty_app_cpu_usage app_cpu_usage = {0,0,0};
    
    kern_return_t kr = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return app_cpu_usage;
    }
    
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    thread_basic_info_t basic_info_th;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return app_cpu_usage;
    }
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    // for each thread
    for (int idx = 0; idx < (int)thread_count; idx++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[idx], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return app_cpu_usage;
        }
        basic_info_th = (thread_basic_info_t)thinfo;
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            app_cpu_usage.user_time += basic_info_th->user_time.seconds;
            app_cpu_usage.system_time += basic_info_th->system_time.seconds;
            app_cpu_usage.cpu_usage += basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return app_cpu_usage;
}

+ (float)getAppCPUUsage {
    ty_app_cpu_usage app_cpu_usage = [self getAppCPUUsageStruct];
    return app_cpu_usage.cpu_usage;
}

+ (ty_system_cpu_usage)getSystemCPUUsageStruct {
    mach_msg_type_number_t  count = HOST_CPU_LOAD_INFO_COUNT;
    kern_return_t kr;
    static host_cpu_load_info_data_t pre_cpu_load_info;
    host_cpu_load_info_data_t cpu_load_info;
    ty_system_cpu_usage  system_cpu_usage = {0,0,0,0,0};
    
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&cpu_load_info, &count);
    if (kr != KERN_SUCCESS) {
        return system_cpu_usage;
    }
    
    natural_t user_cpu_differ = cpu_load_info.cpu_ticks[CPU_STATE_USER] - pre_cpu_load_info.cpu_ticks[CPU_STATE_USER];
    natural_t system_cpu_differ = cpu_load_info.cpu_ticks[CPU_STATE_SYSTEM] - pre_cpu_load_info.cpu_ticks[CPU_STATE_SYSTEM];
    natural_t idle_cpu_differ = cpu_load_info.cpu_ticks[CPU_STATE_IDLE] - pre_cpu_load_info.cpu_ticks[CPU_STATE_IDLE];
    natural_t nice_cpu_differ = cpu_load_info.cpu_ticks[CPU_STATE_NICE] - pre_cpu_load_info.cpu_ticks[CPU_STATE_NICE];
    
    pre_cpu_load_info = cpu_load_info;
    
    natural_t total_cpu = user_cpu_differ + system_cpu_differ + idle_cpu_differ + nice_cpu_differ;
    system_cpu_usage.user = 100.0*user_cpu_differ/total_cpu;
    system_cpu_usage.system = 100.0*system_cpu_differ/total_cpu;
    system_cpu_usage.nice = 100.0*nice_cpu_differ/total_cpu;
    system_cpu_usage.idle = 100.0*idle_cpu_differ/total_cpu;
    system_cpu_usage.total = system_cpu_usage.user + system_cpu_usage.system + system_cpu_usage.nice;
    return system_cpu_usage;
}

+ (float)getSystemCPUUsage {
    ty_system_cpu_usage  system_cpu_usage = [self getSystemCPUUsageStruct];
    return system_cpu_usage.total;
}

+ (NSInteger)getCPUCoreNumber {
    return [NSProcessInfo processInfo].activeProcessorCount;
}

+ (NSUInteger)getSysInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger)results;
}

+ (NSUInteger)getCPUFrequency {
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSString *)getCPUArchitectureString {
    return [NSString stringWithUTF8String:NXGetLocalArchInfo()->description];
}

@end
