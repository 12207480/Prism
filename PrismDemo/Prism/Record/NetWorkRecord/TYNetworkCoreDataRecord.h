//
//  TYNetworkCoreDataRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/17.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYNetworkInfoRecord.h"
#import "TYNetworkDateRecord.h"

@interface TYNetworkCoreDataRecord : NSObject

+ (TYNetworkCoreDataRecord *)sharedInstance;

- (instancetype)init NS_UNAVAILABLE;

- (void)start;

- (void)stop;

@end

@interface TYNetworkCoreDataRecord (CoreData)

- (void)deleteRecordDates:(NSArray *)recordDates;

@end

@interface TYNetworkCoreDataRecord (NSFetchRequest)

- (NSArray<TYNetworkDateRecord *> *)fetchDateRecordResults;

- (void)fetchAsynDateRecordResultsComplete:(void(^)(NSArray *results))complete;

- (NSFetchedResultsController *)fetchedResultsControllerWithRecordId:(NSNumber *)recordId;

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request;

@end
