//
//  TYNetWorkMonitor.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYNetWorkInfo.h"

@class TYNetWorkMonitor;
@protocol TYNetWorkMonitorDelegate <NSObject>

- (void)netWorkMonitor:(TYNetWorkMonitor *)monitor didCatchNetWorkInfo:(TYNetWorkInfo *)networkInfo;

@end

@interface TYNetWorkMonitor : NSObject

@property (nonatomic, assign, readonly) BOOL isRunning;

+ (TYNetWorkMonitor *)sharedInstance;

- (void)addDelegate:(id<TYNetWorkMonitorDelegate>)delegate;

- (void)removeDelegate:(id<TYNetWorkMonitorDelegate>)delegate;

- (void)start;

- (void)stop;

@end
