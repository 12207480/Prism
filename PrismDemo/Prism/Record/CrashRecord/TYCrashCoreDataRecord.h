//
//  TYCrashCoreDataRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYCrashInfoRecord.h"

@interface TYCrashCoreDataRecord : NSObject

+ (TYCrashCoreDataRecord *)sharedInstance;

- (instancetype)init NS_UNAVAILABLE;

- (void)start;

- (void)stop;

@end


@interface TYCrashCoreDataRecord (NSFetchRequest)

- (NSFetchedResultsController *)fetchedResultsController;

@end
