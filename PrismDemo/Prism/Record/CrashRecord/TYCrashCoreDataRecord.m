//
//  TYCrashCoreDataRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCrashCoreDataRecord.h"
#import "TYCrashMonitor.h"
#import "TYCoreDataRecord.h"

@interface TYCrashCoreDataRecord () <TYCrashMonitorDelegate>
@property (nonatomic, strong) TYCoreDataRecord *record;
@property (nonatomic, strong) TYCrashMonitor *crashMonitor;

@end

@implementation TYCrashCoreDataRecord

+ (TYCrashCoreDataRecord *)sharedInstance {
    static TYCrashCoreDataRecord *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addCrashRecord];
        
        [self addCrashMonitor];
    }
    return self;
}

- (void)addCrashRecord {
    _record = [[TYCoreDataRecord alloc]initWithResourceName:@"TYCrashCoreDataRecord"];
}

- (void)addCrashMonitor {
    _crashMonitor = [[TYCrashMonitor alloc]init];
    _crashMonitor.delegate = self;
}

#pragma mark - public

- (void)start {
    [_crashMonitor start];
}

- (void)stop {
    [_crashMonitor stop];
}

#pragma mark - TYCrashMonitorDelegate

- (void)crashMonitor:(TYCrashMonitor *)crashMonitor didCatchExceptionInfo:(TYCrashInfo *)exceptionInfo {
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *date = [dateFormatter stringFromDate:exceptionInfo.date];
    NSNumber *id = @([exceptionInfo.date timeIntervalSince1970]);
    [_record performMainContextBlock:^(NSManagedObjectContext *context) {
        TYCrashInfoRecord *crashRecord = [NSEntityDescription insertNewObjectForEntityForName:@"TYCrashInfoRecord" inManagedObjectContext:context];
        crashRecord.date = date;
        crashRecord.id = id;
        crashRecord.name = exceptionInfo.name;
        crashRecord.reason = exceptionInfo.reason;
        crashRecord.callBackTrace = exceptionInfo.callBackTrace;
        crashRecord.signal = @(exceptionInfo.signal);
    }];
}

@end

@implementation TYCrashCoreDataRecord (NSFetchRequest)

- (NSFetchedResultsController *)fetchedResultsController {
    NSFetchRequest *request = [TYCrashInfoRecord fetchRequest];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    return [self fetchedResultsControllerWithRequest:request];
}

- (NSFetchedResultsController *)fetchedResultsControllerWithRequest:(NSFetchRequest *)request {
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:_record.mainContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
