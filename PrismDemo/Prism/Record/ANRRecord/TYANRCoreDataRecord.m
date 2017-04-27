//
//  TYANRCoreDataRecord.m
//  PrismMonitorDemo
//
//  Created by tanyang on 2017/4/8.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYANRCoreDataRecord.h"
#import "TYCoreDataRecord.h"
#import "TYGCDANRMonitor.h"

@interface TYANRCoreDataRecord ()<TYANRMonitorDelegate>

@property (nonatomic, strong) TYCoreDataRecord *record;
@property (nonatomic, strong) TYGCDANRMonitor *ANRMonitor;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *recordDate;
@property (nonatomic, strong) NSNumber *recordId;

@end

@implementation TYANRCoreDataRecord

+ (TYANRCoreDataRecord *)sharedInstance {
    static TYANRCoreDataRecord *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _recordDate = [NSDate date];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        [self addANRRecord];
        
        [self addANRMonitor];
        
    }
    return self;
}

- (void)addANRRecord {
    _record = [[TYCoreDataRecord alloc]initWithResourceName:@"TYANRCoreDataRecord"];
}

- (void)addANRMonitor {
    _ANRMonitor = [[TYGCDANRMonitor alloc]init];
    _ANRMonitor.delegate = self;
}

#pragma mark - public

- (void)start {
    [_ANRMonitor start];
}

- (void)stop {
    [_ANRMonitor stop];
}

#pragma mark - private

- (void)addANRDateRecordIfNeed {
    if (!_recordId) {
        _recordId = @(_recordDate.timeIntervalSince1970);
        NSString *dateString = [_dateFormatter stringFromDate:_recordDate] ;
        
        [_record performBackgroundBlockAndWait:^(NSManagedObjectContext *context) {
            TYANRDateRecord *ANRRecord = [NSEntityDescription insertNewObjectForEntityForName:@"TYANRDateRecord" inManagedObjectContext:context];
            ANRRecord.date = dateString;
            ANRRecord.id = _recordId;
        }];
    }
}

- (void)addANRRecordWithInfo:(TYANRLogInfo *)ANRInfo {
    NSString *date = [_dateFormatter stringFromDate:ANRInfo.date];
    [_record performBackgroundBlockAndWait:^(NSManagedObjectContext *context) {
        TYANRInfoRecord *ANRRecord = [NSEntityDescription insertNewObjectForEntityForName:@"TYANRInfoRecord" inManagedObjectContext:context];
        ANRRecord.date = date;
        ANRRecord.time = @(ANRInfo.time);
        ANRRecord.id = _recordId;
        ANRRecord.content = ANRInfo.content;
    }];

}

#pragma mark - TYANRMonitorDelegate

- (void)ANRMonitor:(id<TYANRMonitor>)ANRMonitor didRecievedANRTimeOutInfo:(TYANRLogInfo *)ANRLogInfo {
    [TYCoreDataRecord performAsyncQueueBlock:^{
        [self addANRDateRecordIfNeed];
        
        [self addANRRecordWithInfo:ANRLogInfo];
    }];
    
#ifdef DEBUG
    NSLog(@"\nANR LOG-->:\n%@",ANRLogInfo.content);
#endif
}

@end

@implementation TYANRCoreDataRecord (CoreData)

- (void)deleteRecordDates:(NSArray *)recordDates {
    [TYCoreDataRecord performAsyncQueueBlock:^{
        NSMutableArray *recordIds = [NSMutableArray array];
        for (TYANRDateRecord *record in recordDates) {
            [recordIds addObject:record.id];
        }
        
        [_record performMainContextBlock:^(NSManagedObjectContext *context) {
            for (TYANRDateRecord *record in recordDates) {
                if ([_recordId isEqualToNumber: record.id]) {
                    _recordId = nil;
                }
                [context deleteObject:record];
            }
        }];
        
        [_record performBackgroundBlockAndWait:^(NSManagedObjectContext *context) {
            for (NSNumber *id in recordIds) {
                [self deleteRecordDatasWithId:id context:context];
            }
        }];

    }];
}

- (void)deleteRecordDatasWithId:(NSNumber *)recordId context:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [TYANRInfoRecord fetchRequest];
    request.predicate =  [NSPredicate predicateWithFormat:@"id = %@",recordId];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (TYANRInfoRecord *record in result) {
        [context deleteObject:record];
    }
}

@end

@implementation TYANRCoreDataRecord (NSFetchRequest)

- (NSArray<TYANRDateRecord *> *)fetchDateRecordResults {
    __block NSArray *results = nil;
    [_record performMainContextBlock:^(NSManagedObjectContext *context) {
        results = [self fetchRecordDateResultsWithContext:context];
    }];
    return  [results copy];
}

- (void)fetchAsynDateRecordResultsComplete:(void(^)(NSArray *results))complete {
    [TYCoreDataRecord performAsyncQueueBlock:^{
        [_record performMainContextBlock:^(NSManagedObjectContext *context) {
            NSArray *results = [self fetchRecordDateResultsWithContext:context];
            complete(results);
        }];
    }];
}

- (NSArray *)fetchRecordDateResultsWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [TYANRDateRecord fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    NSArray *results = [context executeFetchRequest:request error:nil];
    return results;
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRecordId:(NSNumber *)recordId {
    NSFetchRequest *request = [TYANRInfoRecord fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@",recordId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    return [self fetchedResultsControllerWithRequest:request];
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request {
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:_record.mainContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
