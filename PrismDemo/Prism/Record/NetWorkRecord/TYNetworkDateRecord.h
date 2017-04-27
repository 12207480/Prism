//
//  TYNetworkDateRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/21.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TYNetworkDateRecord : NSManagedObject

@property (nullable, nonatomic, copy) NSString *date;

@property (nullable, nonatomic, copy) NSNumber *id;

+ (NSFetchRequest<TYNetworkDateRecord *> *_Nonnull)fetchRequest;

@end
