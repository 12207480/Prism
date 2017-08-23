//
//  TYCoreDataRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/23.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef void (^TYCoreDataRecordBlock)(NSManagedObjectContext *context);

@interface TYCoreDataRecord : NSObject

/**
 主线程Context
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

/**
 coreData momd sqlite 资源名
 */
@property (nonatomic, strong, readonly) NSString *resourceName;

/**
 数据库文件地址
 */
@property (nonatomic, strong, readonly) NSURL *persistentStoreURL;

- (instancetype)init NS_UNAVAILABLE;

/**
 创建coreData数据库

 @param resourceName coreData momd sqlite 资源名
 */
- (instancetype)initWithResourceName:(NSString *)resourceName;


/**
 后台执行数据操作
 */
- (void)performAsyncMainContextBlock:(TYCoreDataRecordBlock)block;


/**
 主线程执行数据操作
 */
- (void)performMainContextBlock:(TYCoreDataRecordBlock)block;

@end
