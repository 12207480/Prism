//
//  TYGCDLogMonitor.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/17.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYGCDLogMonitor.h"

@interface TYGCDLogMonitor ()
@property (nonatomic, strong) NSString *bundleName;
@property (nonatomic, assign) int originalStdHandle;//original file descriptor
@property (nonatomic, strong) dispatch_source_t source_t;//file descriptor mointor
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation TYGCDLogMonitor

- (instancetype)init
{
    if (self = [super init]) {
        _bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
        _dateFormatter =  [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        _queue = dispatch_queue_create("com.YeBlueColor.GCDLogMonitor", NULL);
    }
    return self;
}

#pragma mark - public

- (BOOL)isRunning {
    return _source_t != nil;
}

- (void)start
{
    if (self.isRunning) {
        return;
    }
    _source_t = [self startCapturingLogFrom:STDERR_FILENO];
}

- (void)stop
{
    if (self.isRunning) {
        dispatch_cancel(_source_t);
        _source_t = nil;
    }
}

#pragma mark - private

- (dispatch_source_t)startCapturingLogFrom:(int)fd  {
    int origianlFD = fd;
    int originalStdHandle = dup(fd);//save the original for reset proporse
    int fildes[2];
    pipe(fildes);  // [0] is read end of pipe while [1] is write end
    dup2(fildes[1], fd);  // Duplicate write end of pipe "onto" fd (this closes fd)
    close(fildes[1]);  // Close original write end of pipe
    fd = fildes[0];  // We can now monitor the read end of the pipe
    
    NSMutableData* data = [[NSMutableData alloc] init];
    fcntl(fd, F_SETFL, O_NONBLOCK);// set the reading of this file descriptor without delay
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, _queue);
    
    int writeEnd = fildes[1];
    dispatch_source_set_cancel_handler(source, ^{
        close(writeEnd);
        dup2(originalStdHandle, origianlFD);//reset the original file descriptor
    });
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(source, ^{
        @autoreleasepool {
            char buffer[1024 * 10] = {0};
            ssize_t size = read(fd, (void*)buffer, (size_t)(sizeof(buffer)));
            if (size == 0) {
                return ;
            }
            
            [data setLength:0];
            [data appendBytes:buffer length:size];
            
            NSString *logString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            logString = [logString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            //print on STDOUT_FILENO，so that the log can still print on xcode console
            printf("%s\n",[logString UTF8String]);
            
            TYLogMessage *logMsg = [self parseLogString:logString];
            if (logMsg && [weakSelf.delegate respondsToSelector:@selector(logMonitor:didReceivedLogMsgs:)]) {
                [weakSelf.delegate logMonitor:self didReceivedLogMsgs:(NSArray<TYLogMessage*> *)@[logMsg]];
            }
        }
    });
    dispatch_resume(source);
    return source;
}

- (TYLogMessage *)parseLogString:(NSString *)logString
{
    if (logString.length == 0) {
        return nil;
    }
    NSDate *date = [NSDate date];
    TYLogMessage *logMsg = [[TYLogMessage alloc]init];
    logMsg.message = logString;
    NSRange range = [logString rangeOfString:_bundleName?_bundleName:@""];
    if (range.length > 0 && range.location > 1) {
        logMsg.date = [logString substringToIndex:range.location -1];
        logMsg.time =  date.timeIntervalSince1970;
    }
    logMsg.name = _bundleName;
    range = [logString rangeOfString:@"] "];
    if (range.length > 0) {
        logMsg.content = [logString substringFromIndex:range.location+range.length];
    }
    return logMsg;
}

- (void)dealloc
{
    [self stop];
}

@end
