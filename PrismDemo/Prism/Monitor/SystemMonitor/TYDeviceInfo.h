//
//  TYDeviceInfo.h
//  PrismDemo
//
//  Created by tany on 2017/8/16.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYDeviceInfo : NSObject


/**
 获取设备型号
 */
+ (NSString *)getDeviceName;

/**
 获取设备型号
 */
+ (NSString *)getDeviceModel;

/**
 获取系统版本
 */
+ (NSString *)getSystemVersion;

/**
 获取系统名称
 */
+ (NSString *)getSystemName;

/**
 获取系统启动时间
 */
+ (NSDate *)getSystemStartUpTime;

/**
 获取系统信息
 */
+ (struct utsname)getSystemInfo;

@end
