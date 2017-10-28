//
//  TYCrashMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCrashInfo.h"

@class TYCrashMonitor;
@protocol TYCrashMonitorDelegate <NSObject>
// main thread
- (void)crashMonitor:(TYCrashMonitor *)crashMonitor didCatchExceptionInfo:(TYCrashInfo *)exceptionInfo;

@end

// Application Crash Monitor

@interface TYCrashMonitor : NSObject

@property (nonatomic, assign, readonly) BOOL isRunning;

+ (TYCrashMonitor *)sharedInstance;

- (void)addDelegate:(id<TYCrashMonitorDelegate>)delegate;

- (void)removeDelegate:(id<TYCrashMonitorDelegate>)delegate;

- (NSString *)getAppInfo;

- (void)start;

- (void)stop;

@end
