//
//  TYANRLogInfo.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYANRLogInfo : NSObject

@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSString *content;

@end
