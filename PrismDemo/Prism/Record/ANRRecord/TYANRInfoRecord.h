//
//  TYANRInfoRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TYANRInfoRecord : NSManagedObject

@property (nullable, nonatomic, copy) NSString *date;

@property (nullable, nonatomic, copy) NSNumber *id;

@property (nullable, nonatomic, copy) NSString *content;

@property (nullable, nonatomic, copy) NSNumber *time;

+ (NSFetchRequest<TYANRInfoRecord *> *_Nonnull)fetchRequest;

- (NSString *_Nonnull)message;

@end
