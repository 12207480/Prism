//
//  TYNetworkInfoRecord.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/18.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TYNetworkInfoRecord : NSManagedObject

// time
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSNumber *time;
@property (nullable, nonatomic, copy) NSNumber *during;
@property (nullable, nonatomic, copy) NSString *date;

// request
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *httpMethod;
@property (nullable, nonatomic, copy) NSString *requestAllHTTPHeaderFields;
@property (nullable, nonatomic, copy) NSString *httpBody;

// response
@property (nullable, nonatomic, copy) NSNumber *statusCode;
@property (nullable, nonatomic, copy) NSString *mimeType;
@property (nullable, nonatomic, copy) NSNumber *expectedContentLength;
@property (nullable, nonatomic, copy) NSString *suggestedFilename;
@property (nullable, nonatomic, copy) NSString *responseAllHeaderFields;
@property (nullable, nonatomic, copy) NSString *responseData;

+ (NSFetchRequest<TYNetworkInfoRecord *> *_Nonnull)fetchRequest;

@end
