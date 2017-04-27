//
//  TYANRDateRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYANRDateRecord.h"

@implementation TYANRDateRecord

@dynamic date;
@dynamic id;

+ (NSFetchRequest<TYANRDateRecord *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"TYANRDateRecord"];
}

@end
