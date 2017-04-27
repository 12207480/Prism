//
//  TYANRCoreDataRecord.h
//  PrismMonitorDemo
//
//  Created by tanyang on 2017/4/8.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYANRDateRecord.h"
#import "TYANRInfoRecord.h"

@interface TYANRCoreDataRecord : NSObject

+ (TYANRCoreDataRecord *)sharedInstance;

- (instancetype)init NS_UNAVAILABLE;

- (void)start;

- (void)stop;

@end

@interface TYANRCoreDataRecord (CoreData)

- (void)deleteRecordDates:(NSArray *)recordDates;

@end


@interface TYANRCoreDataRecord (NSFetchRequest)

- (NSArray<TYANRDateRecord *> *)fetchDateRecordResults;

- (void)fetchAsynDateRecordResultsComplete:(void(^)(NSArray *results))complete;

- (NSFetchedResultsController *)fetchedResultsControllerWithRecordId:(NSNumber *)recordId;

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request;

@end
