//
//  TYCrashInfoRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCrashInfoRecord.h"

@implementation TYCrashInfoRecord

@dynamic date;
@dynamic id;
@dynamic name;
@dynamic reason;
@dynamic signal;
@dynamic callBackTrace;

+ (NSFetchRequest<TYCrashInfoRecord *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"TYCrashInfoRecord"];
}

- (NSString *)message {
    return [NSString stringWithFormat:@"*******************************\n[EXCEPTION DATE]: %@\n[NAME]:%@\n[REASON]:%@\n[CALLBACKTREATH]:\n%@\n",self.date,self.name,self.reason,self.callBackTrace];
}

@end
