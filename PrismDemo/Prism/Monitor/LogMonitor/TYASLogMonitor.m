//
//  TYASLogMonitor.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/16.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYASLogMonitor.h"
#import <asl.h>
#import "TYGCDTimer.h"

// 只支持iOS 10一下的系统
@interface TYASLogMonitor ()

@property (nonatomic, assign) NSInteger lastMsgID;
@property (nonatomic, strong) TYGCDTimer *timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TYASLogMonitor

- (instancetype)init
{
    if (self = [super init]) {
        _lastMsgID = 0;
        _timeInterval = 1.0;
        _dateFormatter =  [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        _queue = dispatch_queue_create("com.YeBlueColor.ASLogMonitor", NULL);
    }
    return self;
}

#pragma mark - public

- (BOOL)isRunning
{
    return _timer.isValid;
}

- (void)start
{
    if (self.isRunning) {
        return;
    }
    _timer = [TYGCDTimer scheduledTimerWithFireTime:_timeInterval interval:_timeInterval queue:_queue target:self selector:@selector(pullASLogMessages) repeats:YES];
}

- (void)stop
{
    if (self.isRunning) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)pullASLogMessages
{
    NSArray<TYLogMessage*> *logMsgs = [self queryAslMsgs];
    if (logMsgs.count > 0 && [_delegate respondsToSelector:@selector(logMonitor:didReceivedLogMsgs:)]) {
        [_delegate logMonitor:self didReceivedLogMsgs:logMsgs];
    }
}

#pragma mark - private

- (asl_object_t)initASLMsgQuery
{
    asl_object_t query = asl_new(ASL_TYPE_QUERY);
    // 设置查询条件
    asl_set_query(query, ASL_KEY_FACILITY, [[NSBundle mainBundle].bundleIdentifier UTF8String], ASL_QUERY_OP_EQUAL);
    asl_set_query(query, ASL_KEY_PID, [[@([[NSProcessInfo processInfo] processIdentifier]) stringValue] UTF8String], ASL_QUERY_OP_EQUAL);
    if (_lastMsgID) {
        // 从之前已经查询的最后一条开始
        asl_set_query(query, ASL_KEY_MSG_ID, [[@(_lastMsgID) stringValue] UTF8String], ASL_QUERY_OP_GREATER | ASL_QUERY_OP_NUMERIC);
    }
    return query;
}

- (NSArray<TYLogMessage*> *)queryAslMsgs
{
    asl_object_t query = [self initASLMsgQuery];
    // 获取查询数据对象
    aslresponse response = asl_search(NULL, query);
    if (!response) {
        return nil;
    }
    NSMutableArray *logMsgs = [NSMutableArray array];
    // 获取下一条数据
    aslmsg msg = asl_next(response);
    while (msg) {
        [logMsgs addObject:[self parseAslMsg:msg]];
        msg = asl_next(response);
    }
    asl_release(query);
    asl_release(response);
    return [logMsgs copy];
}

- (TYLogMessage *)parseAslMsg:(aslmsg)aslMsg
{
    TYLogMessage *logMsg = [[TYLogMessage alloc]init];
    // date
    const char *timestamp = asl_get(aslMsg, ASL_KEY_TIME);
    if (timestamp) {
        NSTimeInterval timeInterval = [@(timestamp) integerValue];
        const char *nanoseconds = asl_get(aslMsg, ASL_KEY_TIME_NSEC);
        if (nanoseconds) {
            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        logMsg.date = [_dateFormatter stringFromDate:date];
    }
    // appName
    const char *sender = asl_get(aslMsg, ASL_KEY_SENDER);
    if (sender) {
        logMsg.name = @(sender);
    }
    
    const char *message = asl_get(aslMsg, ASL_KEY_MSG);
    if (message) {
        logMsg.content = @(message);
    }
    
//    const char *msgID = asl_get(aslMsg, ASL_KEY_MSG_ID);
//    if (msgID) {
//        logMsg.msgID = [@(msgID) integerValue];
//        _lastMsgID = logMsg.msgID;
//    }
    // log level
    const char *level = asl_get(aslMsg, ASL_KEY_LEVEL);
    if (level) {
        logMsg.level = [@(level) integerValue];
    }
    logMsg.message = [NSString stringWithFormat:@"%@ %@ %@",logMsg.date,logMsg.name,logMsg.content];
    return logMsg;
}

- (void)dealloc {
    [_timer invalidate];
    _queue = nil;
}

@end
