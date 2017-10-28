//
//  TYCrashInfo.h
//  PrismDemo
//
//  Created by tanyang on 2017/10/28.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTYCrashException -1
@interface TYCrashInfo : NSObject

@property (nonatomic, strong) NSDate *date; // 时间

@property (nonatomic, strong) NSString *name; // 异常名称

@property (nonatomic, strong) NSString *reason; // 异常原因

@property (nonatomic, strong) NSException *exception; // 异常

@property (nonatomic, assign) NSInteger signal; // -1 exception, other signal

@property (nonatomic, strong) NSString *callBackTrace; // 线程堆栈

@end
