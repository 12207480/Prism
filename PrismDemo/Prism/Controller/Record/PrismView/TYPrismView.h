//
//  TYPrismView.h
//  PrismMonitorDemo
//
//  Created by tany on 17/3/28.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYPrismView;
@protocol TYPrismViewDelegate <NSObject>

- (void)prismViewDidClickedAction:(TYPrismView *)prismView;

@end

@interface TYPrismView : UIWindow

@property (nonatomic, strong, readonly) UIButton *prismBtn;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, weak) id<TYPrismViewDelegate> prismDelegate;

- (void)show;

- (void)hide;

@end
