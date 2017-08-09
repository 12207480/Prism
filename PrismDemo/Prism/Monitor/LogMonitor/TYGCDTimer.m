//
//  TYGCDTimer.m
//  PrismMonitorDemo
//
//  Created by tanyang on 2017/3/16.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYGCDTimer.h"

@interface TYGCDTimer ()

@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_semaphore_t lock;

@end

@implementation TYGCDTimer

+ (instancetype)scheduledTimerOnMainWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [[self alloc]initOnMainWithInterval:interval target:target selector:selector repeats:repeats];
}

+ (instancetype)scheduledTimerOnAsynWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [[self alloc]initOnAsynWithInterval:interval target:target selector:selector repeats:repeats];
}

+ (instancetype)scheduledTimerWithFireTime:(NSTimeInterval)fireTime interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [[self alloc]initWithFireTime:fireTime interval:interval queue:queue target:target selector:selector repeats:repeats];
}

- (instancetype)initOnMainWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [self initWithFireTime:interval interval:interval queue:dispatch_get_main_queue() target:target selector:selector repeats:repeats];
}

- (instancetype)initOnAsynWithInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    return [self initWithFireTime:interval interval:interval queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) target:target selector:selector repeats:repeats];
}

- (instancetype)initWithFireTime:(NSTimeInterval)fireTime interval:(NSTimeInterval)interval queue:(dispatch_queue_t)queue target:(id)target selector:(SEL)selector repeats:(BOOL)repeats {
    if (self = [super init]) {
        _repeats = repeats;
        _timeInterval = interval;
        _target = target;
        _selector = selector;
        _lock = dispatch_semaphore_create(1);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, (fireTime * NSEC_PER_SEC)), (interval * NSEC_PER_SEC), 0);
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            [weakSelf timerFire];
        });
        dispatch_resume(_timer);
    }
    return self;
}

- (void)timerFire {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    id target = _target;
    if (!target) {
        dispatch_semaphore_signal(_lock);
        [self invalidate];
        return;
    }
    dispatch_semaphore_signal(_lock);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:_selector withObject:self];
#pragma clang diagnostic pop
    if (!_repeats) {
        [self invalidate];
    }
}

- (void)invalidate {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        _target = nil;
        _selector = NULL;
    }
    dispatch_semaphore_signal(_lock);
}

- (BOOL)isValid {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    BOOL isValid = _timer != nil;
    dispatch_semaphore_signal(_lock);
    return isValid;
}

- (void)dealloc {
    [self invalidate];
}

@end
