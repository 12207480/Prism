//
//  TYANRInfoRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYANRInfoRecord.h"

@implementation TYANRInfoRecord

@dynamic date;
@dynamic id;
@dynamic content;
@dynamic time;

+ (NSFetchRequest<TYANRInfoRecord *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"TYANRInfoRecord"];
}

- (NSString *)message {
    return [NSString stringWithFormat:@"\n*******************************************\nARN Time:%@\n%@\n",self.date,self.content];
}

@end
