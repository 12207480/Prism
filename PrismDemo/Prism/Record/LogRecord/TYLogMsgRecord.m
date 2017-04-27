//
//  TYLogMsgRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/23.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYLogMsgRecord.h"

@implementation TYLogMsgRecord

@dynamic content;
@dynamic date;
@dynamic level;
@dynamic name;
@dynamic time;
@dynamic id;
@dynamic message;

+ (NSFetchRequest<TYLogMsgRecord *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"TYLogMsgRecord"];
}

@end
