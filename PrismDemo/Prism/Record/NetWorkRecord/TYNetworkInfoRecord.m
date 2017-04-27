//
//  TYNetworkInfoRecord.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/18.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetworkInfoRecord.h"

@implementation TYNetworkInfoRecord

@dynamic id;
@dynamic time;
@dynamic during;
@dynamic date;
@dynamic url;
@dynamic httpMethod;
@dynamic requestAllHTTPHeaderFields;
@dynamic httpBody;
@dynamic statusCode;
@dynamic mimeType;
@dynamic expectedContentLength;
@dynamic suggestedFilename;
@dynamic responseAllHeaderFields;
@dynamic responseData;

+ (NSFetchRequest<TYNetworkInfoRecord *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"TYNetworkInfoRecord"];
}

@end
