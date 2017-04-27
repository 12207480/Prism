//
//  TYURLProtocol.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSessionConfiguration+TYURLProtocol.h"

@class TYURLProtocol;
@protocol TYURLProtocolDelegate <NSObject>

- (void)URLProtocolDidCatchURLRequest:(TYURLProtocol *)URLProtocol;

@end

@interface TYURLProtocol : NSURLProtocol

@property (nonatomic, strong, readonly) NSURLConnection *ty_connection;
@property (nonatomic, strong, readonly) NSURLRequest *ty_request;
@property (nonatomic, strong, readonly) NSURLResponse *ty_response;
@property (nonatomic, strong, readonly) NSMutableData *ty_data;

@property (nonatomic, strong, readonly) NSDate *startDate;
@property (nonatomic, strong, readonly) NSDate *endDate;

+ (void)setHookNSURLSessionConfiguration:(BOOL)hook;

+ (void)addDelegate:(id<TYURLProtocolDelegate>)delegate;

+ (void)removeDelegate:(id<TYURLProtocolDelegate>)delegate;

@end
