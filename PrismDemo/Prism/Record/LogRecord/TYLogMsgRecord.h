//
//  TYLogMsgRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/23.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TYLogMsgRecord : NSManagedObject
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSNumber *level;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSNumber *time;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSString * message;

+ (NSFetchRequest<TYLogMsgRecord *> *_Nonnull)fetchRequest;

@end
