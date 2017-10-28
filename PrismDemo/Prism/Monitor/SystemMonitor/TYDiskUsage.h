//
//  TYDiskUsage.h
//  PrismDemo
//
//  Created by tany on 2017/8/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDiskUsage : NSObject

/**
 磁盘总空间 size->byte
 */
+ (unsigned long long) getDiskTotalSize;

/**
 磁盘可用空间大小
 */
+ (unsigned long long) getDiskFreeSize;

/**
 获取文件大小
 */
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;


/**
 获取文件夹下所有文件的大小
 */
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath;

@end
