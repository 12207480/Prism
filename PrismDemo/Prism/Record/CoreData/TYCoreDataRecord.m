//
//  TYCoreDataRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/23.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCoreDataRecord.h"

//static NSString * const ManagedObjectModelResourceName = @"TYCoreDataRecord";
//static NSString * const PersistentStorePath = @"TYCoreDataRecord.sqlite";
static NSString * const ManagedObjectModelExtension = @"momd";

@interface TYCoreDataRecord ()

@property (nonatomic, strong) NSString *resourceName;

@property (nonatomic, strong) NSManagedObjectContext *masterContext;
@property (nonatomic, strong) NSManagedObjectContext *mainContext;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSURL *persistentStoreURL;

@end

@implementation TYCoreDataRecord

dispatch_queue_t ty_coredata_record_queue() {
    static dispatch_queue_t ty_coredata_record_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ty_coredata_record_queue = dispatch_queue_create("com.YeBlueColor.TYCoreDataRecord", NULL);
    });
    return ty_coredata_record_queue;
}

- (instancetype)initWithResourceName:(NSString *)resourceName {
    if (self = [super init]) {
        
        _resourceName = resourceName;
        [self configureCoreData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMainContext) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveMainContext) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

#pragma mark - getter

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:_resourceName withExtension:ManagedObjectModelExtension];
    _managedObjectModel= [[NSManagedObjectModel alloc]initWithContentsOfURL:url];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    return _persistentStoreCoordinator;
}

- (NSURL *)documentsDirectory {
    return[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
}

- (NSURL *)persistentStoreURL {
    if (_persistentStoreURL) {
        return _persistentStoreURL;
    }
    _persistentStoreURL =  [[self documentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",_resourceName]];
#ifdef DEBUG
    NSLog(@"PersistentStoreURL %@",_persistentStoreURL);
#endif
    return _persistentStoreURL;
}

#pragma mark - configure

- (void)configureCoreData {
    
    [self configureManagedObjectContext];
    
    [self configurePersistentStore];
}

- (void)configureManagedObjectContext {
    _masterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _masterContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    _masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.parentContext = _masterContext;
}

- (void)configurePersistentStore {
    BOOL storeWasRecreated = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self.persistentStoreURL path]]) {
        NSError *storeMetadataError = nil;
        NSDictionary *storeMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:self.persistentStoreURL error:&storeMetadataError];
        
        // If store is incompatible with the managed object model, remove the store file
        if (storeMetadataError || ![self.managedObjectModel isConfiguration:nil compatibleWithStoreMetadata:storeMetadata]) {
            storeWasRecreated = YES;
            NSError *removeStoreError = nil;
            if (![[NSFileManager defaultManager] removeItemAtURL:self.persistentStoreURL error:&removeStoreError]) {
                NSLog(@"Error removing store file at URL '%@': %@, %@", self.persistentStoreURL, removeStoreError, [removeStoreError userInfo]);
            }
        }
    }
    NSError *addStoreError = nil;
    NSPersistentStore *store = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.persistentStoreURL options:nil error:&addStoreError];
    if (!store) {
        NSLog(@"Unable to add store: %@, %@", addStoreError, [addStoreError userInfo]);
    }
}

#pragma mark - save Context

- (void)saveMainContext {
    [self saveContext:self.mainContext];
}

- (void)saveContext:(NSManagedObjectContext *)context {
    if (context && [context hasChanges]) {
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Error saving context: %@ %@ %@", self, error, [error userInfo]);
        }
        [self saveContext:context.parentContext];
    }
}

- (void)performBackgroundBlockAndWait:(TYCoreDataRecordBlock)block {
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = self.mainContext;
    if (block) {
        [backgroundContext performBlockAndWait:^{
            block(backgroundContext);
            [self saveContext:backgroundContext];
        }];
    }
}

- (void)performMainContextBlock:(TYCoreDataRecordBlock)block {
    if (block) {
        block(self.mainContext);
        [self saveMainContext];
    }
}

+ (void)performAsyncQueueBlock:(void (^)())block {
    dispatch_async(ty_coredata_record_queue(), block);
}

- (void)dealloc {
    [self saveMainContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

@end
