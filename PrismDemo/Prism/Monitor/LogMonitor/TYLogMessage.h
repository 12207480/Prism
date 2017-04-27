//
//  TYLogMessage.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLogMessage : NSObject

@property (nonatomic, strong) NSString *content; // 内容

@property (nonatomic, strong) NSString *name; // app Name

@property (nonatomic, strong) NSString *date; // 日期

@property (nonatomic, assign) NSInteger level; // log等级

@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, strong) NSString *message;

@end
