//
//  TYANRDateRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TYANRDateRecord : NSManagedObject

@property (nullable, nonatomic, copy) NSString *date;

@property (nullable, nonatomic, copy) NSNumber *id;

+ (NSFetchRequest<TYANRDateRecord *> *_Nonnull)fetchRequest;

@end
