//
//  TYGCDTimer.h
//  PrismMonitorDemo
//
//  Created by tanyang on 2017/3/16.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYGCDTimer : NSObject
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;
@property (nonatomic, assign, readonly) BOOL repeats;
@property (nonatomic, assign, readonly) BOOL isValid;

+ (instancetype)scheduledTimerOnMainWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;

+ (instancetype)scheduledTimerOnAsynWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;

+ (instancetype)scheduledTimerWithFireTime:(NSTimeInterval)fireTime interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue target:(id)target selector:(SEL)selector repeats:(BOOL)repeats;

- (void)invalidate;

@end
