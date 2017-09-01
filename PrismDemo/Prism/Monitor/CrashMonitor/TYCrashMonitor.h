//
//  TYCrashMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTYCrashException -1

@class TYCrashInfo;
@class TYCrashMonitor;
@protocol TYCrashMonitorDelegate <NSObject>
// main thread
- (void)crashMonitor:(TYCrashMonitor *)crashMonitor didCatchExceptionInfo:(TYCrashInfo *)exceptionInfo;

@end

// Application Crash Monitor

@interface TYCrashMonitor : NSObject

@property (nonatomic, assign, readonly) BOOL isRunning;

@property (nonatomic, strong, readonly) NSString *appInfo;

+ (TYCrashMonitor *)sharedInstance;

- (void)addDelegate:(id<TYCrashMonitorDelegate>)delegate;

- (void)removeDelegate:(id<TYCrashMonitorDelegate>)delegate;

- (void)start;

- (void)stop;

@end

@interface TYCrashInfo : NSObject

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *reason;

@property (nonatomic, strong) NSException *exception;

@property (nonatomic, assign) NSInteger signal; // -1 exception, other signal

@property (nonatomic, strong) NSString *callBackTrace;

@end
