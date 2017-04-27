//
//  TYNetworkDateRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/21.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetworkDateRecord.h"

@implementation TYNetworkDateRecord
@dynamic id;
@dynamic date;

+ (NSFetchRequest<TYNetworkDateRecord *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"TYNetworkDateRecord"];
}

@end
