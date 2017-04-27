//
//  TYLogCoreDataRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/24.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYLogDateRecord.h"
#import "TYLogMsgRecord.h"

@interface TYLogCoreDataRecord : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (TYLogCoreDataRecord *)sharedInstance;

- (void)start;

- (void)stop;

@end

@interface TYLogCoreDataRecord (CoreData)

- (void)deleteRecordDates:(NSArray *)recordDates;

@end

@interface TYLogCoreDataRecord (NSFetchRequest)

- (NSArray<TYLogDateRecord *> *)fetchDateRecordResults;

- (void)fetchAsynDateRecordResultsComplete:(void(^)(NSArray *results))complete;

- (NSFetchedResultsController *)fetchedResultsControllerWithRecordId:(NSNumber *)recordId;

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request;

@end
