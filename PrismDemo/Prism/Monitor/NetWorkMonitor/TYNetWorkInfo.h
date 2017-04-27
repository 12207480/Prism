//
//  TYNetWorkInfo.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYNetWorkInfo : NSObject

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSData *data;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

// time
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) double during;

// request
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, strong) NSDictionary *requestAllHTTPHeaderFields;
@property (nonatomic, strong) NSString *httpBody;

// response
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSString *MIMEType;
@property (nonatomic, assign) long long expectedContentLength;
@property (nonatomic, strong) NSString *suggestedFilename;
@property (nonatomic, strong) NSDictionary *responseAllHeaderFields;
@property (nonatomic, strong) NSString *responseData;

@end
