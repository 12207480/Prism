//
//  TYNetWorkMonitor.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetWorkMonitor.h"
#import "TYURLProtocol.h"

@interface TYNetWorkMonitor ()<TYURLProtocolDelegate>

@property (nonatomic, assign) BOOL isRunning;

@end

@implementation TYNetWorkMonitor

- (instancetype)init {
    if (self = [super init]) {
        _isRunning = NO;
    }
    return self;
}

- (void)start {
    if (_isRunning) {
        return;
    }
    _isRunning = YES;
    [TYURLProtocol addDelegate:self];
}

- (void)stop {
    if (!_isRunning) {
        return;
    }
    _isRunning = NO;
    [TYURLProtocol removeDelegate:self];
}

#pragma mark - TYURLProtocolDelegate

- (void)URLProtocolDidCatchURLRequest:(TYURLProtocol *)URLProtocol {
    
    TYNetWorkInfo *info = [[TYNetWorkInfo alloc]init];
    info.startDate = URLProtocol.startDate;
    info.endDate = URLProtocol.endDate;
    info.time = URLProtocol.startDate.timeIntervalSince1970;
    info.during = [URLProtocol.endDate timeIntervalSinceDate:URLProtocol.startDate];
    info.request = URLProtocol.ty_request;
    info.response = (NSHTTPURLResponse *)URLProtocol.ty_response;
    info.data = [URLProtocol.ty_data copy];
    
    if ([_delegate respondsToSelector:@selector(netWorkMonitor:didCatchNetWorkInfo:)]) {
        [_delegate netWorkMonitor:self didCatchNetWorkInfo:info];
    }
}

- (void)dealloc {
    [self stop];
}

@end
