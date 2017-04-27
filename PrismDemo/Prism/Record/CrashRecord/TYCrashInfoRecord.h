//
//  TYCrashInfoRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TYCrashInfoRecord : NSManagedObject

@property (nullable, nonatomic, copy) NSString *date;

@property (nullable, nonatomic, copy) NSNumber *id;

@property (nullable, nonatomic, copy) NSString *name;

@property (nullable, nonatomic, copy) NSString *reason;

@property (nullable, nonatomic, copy) NSNumber *signal;

@property (nullable, nonatomic, copy) NSString *callBackTrace;

+ (NSFetchRequest<TYCrashInfoRecord *> *_Nonnull)fetchRequest;

- (NSString *_Nonnull)message;

@end
