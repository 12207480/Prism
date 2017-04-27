//
//  TYLogDateRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/23.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TYLogMsgRecord.h"

@interface TYLogDateRecord : NSManagedObject

@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSNumber *id;

+ (NSFetchRequest<TYLogDateRecord *> *_Nonnull)fetchRequest;

@end
