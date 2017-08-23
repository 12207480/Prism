//
//  TYNetworkCoreDataRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/17.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetworkCoreDataRecord.h"
#import "TYNetWorkMonitor.h"
#import "TYCoreDataRecord.h"


@interface TYNetworkCoreDataRecord ()<TYNetWorkMonitorDelegate>

@property (nonatomic, strong) TYCoreDataRecord *record;
@property (nonatomic, strong) TYNetWorkMonitor *networkMonitor;

@property (nonatomic, strong) NSDate *recordDate;
@property (nonatomic, strong) NSNumber *recordId;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation TYNetworkCoreDataRecord

+ (TYNetworkCoreDataRecord *)sharedInstance {
    static TYNetworkCoreDataRecord *sharedInstance = nil;
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
        
        [self addNetworkRecord];
        
        [self addNetworkMonitor];
    }
    return self;
}

- (void)addNetworkRecord {
    _record = [[TYCoreDataRecord alloc]initWithResourceName:@"TYNetworkCoreDataRecord"];
}

- (void)addNetworkMonitor {
    _networkMonitor = [[TYNetWorkMonitor alloc]init];
    _networkMonitor.delegate = self;
}

#pragma mark - public

- (void)start {
    [_networkMonitor start];
}

- (void)stop {
    [_networkMonitor stop];
}

#pragma mark - private

- (void)addNetworkDateRecordIfNeed {
    if (!_recordId) {
        _recordId = @(_recordDate.timeIntervalSince1970);
        NSString *dateString = [_dateFormatter stringFromDate:_recordDate] ;
        
        [_record performAsyncMainContextBlock:^(NSManagedObjectContext *context) {
            TYNetworkDateRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"TYNetworkDateRecord" inManagedObjectContext:context];
            record.date = dateString;
            record.id = _recordId;
        }];
    }
}

- (void)addNetworkRecordWithInfo:(TYNetWorkInfo *)networkInfo {
    NSString *date = [_dateFormatter stringFromDate:networkInfo.startDate];
    
    NSMutableString *requestAllHTTPHeaderFields = [NSMutableString string];
    [networkInfo.requestAllHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [requestAllHTTPHeaderFields appendFormat:@"%@: %@\n",key,obj];
    }];
    
    NSMutableString *responseAllHeaderFields = [NSMutableString string];
    [networkInfo.responseAllHeaderFields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [responseAllHeaderFields appendFormat:@"%@: %@\n",key,obj];
    }];
    
    [_record performAsyncMainContextBlock:^(NSManagedObjectContext *context) {
        TYNetworkInfoRecord *networkRecord = [NSEntityDescription insertNewObjectForEntityForName:@"TYNetworkInfoRecord" inManagedObjectContext:context];
        networkRecord.id = _recordId;
        networkRecord.time = @(networkInfo.time);
        networkRecord.date = date;
        networkRecord.during = @(networkInfo.during);
        networkRecord.url = networkInfo.url.absoluteString;
        networkRecord.httpMethod = networkInfo.httpMethod;
        networkRecord.requestAllHTTPHeaderFields = [requestAllHTTPHeaderFields copy];
        networkRecord.httpBody = networkInfo.httpBody;
        networkRecord.statusCode = @(networkInfo.statusCode);
        networkRecord.mimeType = networkInfo.MIMEType;
        networkRecord.expectedContentLength = @(networkInfo.expectedContentLength);
        networkRecord.suggestedFilename = networkInfo.suggestedFilename;
        networkRecord.responseAllHeaderFields = [responseAllHeaderFields copy];
        networkRecord.responseData = networkInfo.responseData;
    }];
}

#pragma mark - TYNetworkCoreDataRecord

- (void)netWorkMonitor:(TYNetWorkMonitor *)monitor didCatchNetWorkInfo:(TYNetWorkInfo *)networkInfo {
    [self addNetworkDateRecordIfNeed];
    
    [self addNetworkRecordWithInfo:networkInfo];
}

@end

@implementation TYNetworkCoreDataRecord (CoreData)

- (void)deleteRecordDates:(NSArray *)recordDates {
    NSMutableArray *recordIds = [NSMutableArray array];
    for (TYNetworkDateRecord *record in recordDates) {
        [recordIds addObject:record.id];
    }
    
    [_record performMainContextBlock:^(NSManagedObjectContext *context) {
        for (TYNetworkDateRecord *record in recordDates) {
            if ([_recordId isEqualToNumber: record.id]) {
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
    NSFetchRequest *request = [TYNetworkInfoRecord fetchRequest];
    request.predicate =  [NSPredicate predicateWithFormat:@"id = %@",recordId];
    NSArray *result = [context executeFetchRequest:request error:nil];
    
    for (TYNetworkInfoRecord *record in result) {
        [context deleteObject:record];
    }
}

@end

@implementation TYNetworkCoreDataRecord (NSFetchRequest)

- (NSArray<TYNetworkDateRecord *> *)fetchDateRecordResults {
    __block NSArray *results = nil;
    [_record performMainContextBlock:^(NSManagedObjectContext *context) {
        results = [self fetchRecordDateResultsWithContext:context];
    }];
    return  [results copy];
}

- (void)fetchAsynDateRecordResultsComplete:(void(^)(NSArray *results))complete {
    [_record performMainContextBlock:^(NSManagedObjectContext *context) {
        NSArray *results = [self fetchRecordDateResultsWithContext:context];
        complete(results);
    }];
}

- (NSArray *)fetchRecordDateResultsWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [TYNetworkDateRecord fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    NSArray *results = [context executeFetchRequest:request error:nil];
    return results;
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRecordId:(NSNumber *)recordId {
    NSFetchRequest *request = [TYNetworkInfoRecord fetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@",recordId];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
    return [self fetchedResultsControllerWithRequest:request];
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request {
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:_record.mainContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}


@end
