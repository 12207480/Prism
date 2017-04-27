//
//  TYPrismRecordItem.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/29.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYPrismRecordItem;
typedef void(^SelectCellHandle)(TYPrismRecordItem *item);

@interface TYPrismRecordItem : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) SelectCellHandle selectCellHandle;

@end
