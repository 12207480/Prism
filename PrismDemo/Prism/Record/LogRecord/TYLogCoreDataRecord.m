//
//  TYLogCoreDataRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/24.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYLogCoreDataRecord.h"
#import "TYCoreDataRecord.h"
#import "TYGCDLogMonitor.h"

@interface TYLogCoreDataRecord () <TYLogMonitorDelegate>

@property (nonatomic, strong) TYGCDLogMonitor *logMonitor;
@property (nonatomic, strong) TYCoreDataRecord *record;

@property (nonatomic, strong) NSDate *recordDate;
@property (nonatomic, strong) NSNumber *recordId;

@end

@implementation TYLogCoreDataRecord

+ (TYLogCoreDataRecord *)sharedInstance
{
    static TYLogCoreDataRecord *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _recordDate = [NSDate date];
        
        [self addLogRecord];
        
        [self addLogMonitor];
    }
    return self;
}

- (void)addLogMonitor {
    _logMonitor = [[TYGCDLogMonitor alloc]init];
    [_logMonitor addDelegate:self];
}

- (void)addLogRecord {
    _record = [[TYCoreDataRecord alloc]initWithResourceName:@"TYLogCoreDataRecord"];
}

- (void)addLogRecordIfNeed {
    if (!_recordId) {
        NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSString *dateString = [dateFormatter stringFromDate:_recordDate] ;
        _recordId = @(_recordDate.timeIntervalSince1970);
        [_record performAsyncMainContextBlock:^(NSManagedObjectContext *context) {
            TYLogDateRecord *logRecord = [NSEntityDescription insertNewObjectForEntityForName:@"TYLogDateRecord" inManagedObjectContext:context];
            logRecord.date = dateString;
            logRecord.id = _recordId;
        }];
    }
}

#pragma mark - public

- (void)start {
    [_logMonitor start];
}

- (void)stop {
    [_logMonitor stop];
}

#pragma mark - private

- (void)addRecordLogMsgs:(NSArray<TYLogMessage*> *)logMsgs {
    [_record performAsyncMainContextBlock:^(NSManagedObjectContext *context) {
        for (TYLogMessage* message in logMsgs) {
            TYLogMsgRecord *logMsg = [NSEntityDescription insertNewObjectForEntityForName:@"TYLogMsgRecord" inManagedObjectContext:context];
            logMsg.name = message.name;
            logMsg.content = message.content;
            logMsg.level = @(message.level);
            logMsg.date = message.date;
            logMsg.time = @(message.time);
            logMsg.id = _recordId;
            logMsg.message = [NSString stringWithFormat:@"%@ [%@]: %@",message.date,message.name,message.content];
        }
    }];
}

#pragma mark - TYLogMonitorDelegate

- (void)logMonitor:(id<TYLogMonitor>)LogMonitor didReceivedLogMsgs:(NSArray<TYLogMessage*> *)logMsgs
{
    [self addLogRecordIfNeed];
    
    [self addRecordLogMsgs:logMsgs];

}

@end


@implementation TYLogCoreDataRecord (CoreData)

- (void)deleteRecordDates:(NSArray *)recordDates {
    NSMutableArray *recordIds = [NSMutableArray array];
    for (TYLogDateRecord *record in recordDates) {
        [recordIds addObject:record.id];
    }
    
    [_record performMainContextBlock:^(NSManagedObjectContext *context) {
        for (TYLogDateRecord *record in recordDates) {
            if ([record.id isEqualToNumber:_recordId]) {
                _recordId = nil;
            }
            [context deleteObject:record];
        }
    }];
    
    [_record performAsyncMainContextBlock:^(NSManagedObjectContext *context) {
        for (NSNumber *id in recordIds) {
            [self deleteRecordDatasWithId:id context:context];
        }
    }];
}

- (void)deleteRecordDatasWithId:(NSNumber *)recordId context:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [TYLogMsgRecord fetchRequest];
     request.predicate =  [NSPredicate predicateWithFormat:@"id = %@",recordId];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (TYLogMsgRecord *record in result) {
        [context deleteObject:record];
    }
}

@end

@implementation TYLogCoreDataRecord (NSFetchRequest)

- (NSArray<TYLogDateRecord *> *)fetchDateRecordResults {
    __block NSArray *results = nil;
    [_record performMainContextBlock:^(NSManagedObjectContext *context) {
        results = [self fetchRecordDateResultsWithContext:context];
    }];
    return  [results copy];
}

- (void)fetchAsynDateRecordResultsComplete:(void(^)(NSArray *results))complete {
    [_record performAsyncMainContextBlock:^(NSManagedObjectContext *context) {
        NSArray *results = [self fetchRecordDateResultsWithContext:context];
        complete(results);
    }];
}

- (NSArray *)fetchRecordDateResultsWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [TYLogDateRecord fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    NSArray *results = [context executeFetchRequest:request error:nil];
    return results;
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRecordId:(NSNumber *)recordId {
    NSFetchRequest *request = [TYLogMsgRecord fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@",recordId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    return [self fetchedResultsControllerWithRequest:request];
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request {
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:_record.mainContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
