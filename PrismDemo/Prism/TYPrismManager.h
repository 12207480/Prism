//
//  TYPrismManager.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/28.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYPrismManager : NSObject

+ (TYPrismManager *)sharedInstance;

+ (void)start;

+ (void)stop;

@end
