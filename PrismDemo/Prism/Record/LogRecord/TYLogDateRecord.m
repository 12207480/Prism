//
//  TYLogDateRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/23.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYLogDateRecord.h"

@implementation TYLogDateRecord

@dynamic date;
@dynamic id;

+ (NSFetchRequest<TYLogDateRecord *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"TYLogDateRecord"];
}

@end
