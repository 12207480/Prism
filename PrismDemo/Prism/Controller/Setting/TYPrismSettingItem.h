//
//  TYPrismSettingItem.h
//  PrismDemo
//
//  Created by tany on 2017/8/18.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYPrismSettingItem;
typedef void(^ClickedHandle)(TYPrismSettingItem *item);
typedef void(^AccessoryHandle)(TYPrismSettingItem *item, UIView *accessoryView);

@interface TYPrismSettingItem : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property (nonatomic, copy) ClickedHandle selectCellHandle;

@property (nonatomic, copy) AccessoryHandle accessoryViewHandle;

@end
