//
//  TYPrismView.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/28.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYPrismView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kPrismViewWidth 48
#define kPrismViewHeight 48

#define kVerticalMargin 15
#define kHorizenMargin 5

@interface TYPrismView ()

@property (nonatomic, strong) UIButton *prismBtn;

@property (nonatomic, assign) CGFloat openAlpha;
@property (nonatomic, assign) CGFloat closeAlpha;

@end

@implementation TYPrismView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self confogure];
        
        [self addPrismBtn];
    }
    return self;
}

- (void)confogure {
    self.windowLevel = UIWindowLevelAlert+1;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    _openAlpha = 0.5;
    _closeAlpha = 0.7;
}

- (void)addPrismBtn {
    UIButton *prismBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    prismBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [prismBtn addTarget:self action:@selector(prismBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    panGesture.delaysTouchesBegan = YES;
    [prismBtn addGestureRecognizer:panGesture];
    _prismBtn = prismBtn;
}

#pragma mark - getter setter

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *window = [app keyWindow];
    if (!window) {
        window = app.windows.firstObject;
    }
    return window;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.alpha = isSelected ? _openAlpha : _closeAlpha;
}

#pragma mark - public

- (void)show {
    self.alpha = _isSelected ? _openAlpha : _closeAlpha;
    UIWindow *keyWindow = [self mainWindow];
    self.frame = CGRectMake(kScreenWidth-kPrismViewWidth-kHorizenMargin, kScreenHeight-kPrismViewHeight*5, kPrismViewWidth, kPrismViewHeight);
    if (!self.rootViewController) {
        self.rootViewController = [[UIViewController alloc]init];
    }
    self.layer.cornerRadius = self.frame.size.width <= self.frame.size.height ? self.frame.size.width / 2.0 : self.frame.size.height / 2.0;
    self.layer.masksToBounds = YES;
    if (_prismBtn.superview) {
        [_prismBtn removeFromSuperview];
    }
    [self makeKeyAndVisible];
    [self addSubview:_prismBtn];
    [keyWindow makeKeyAndVisible];
}

- (void)hide {
    self.hidden = YES;
}

#pragma mark - Action

- (void)prismBtnAction:(UIButton *)button {
    if ([_prismDelegate respondsToSelector:@selector(prismViewDidClickedAction:)]) {
        [_prismDelegate prismViewDidClickedAction:self];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer*)p {
    
    UIWindow *appWindow = [self mainWindow];
    CGPoint panPoint = [p locationInView:appWindow];
    
    if(p.state == UIGestureRecognizerStateBegan) {
        self.alpha = 1;
    }else if(p.state == UIGestureRecognizerStateChanged) {
        self.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded
             || p.state == UIGestureRecognizerStateCancelled) {
        self.alpha = _isSelected ? _openAlpha : _closeAlpha;
        [self layoutAnimateWithPosition:panPoint];
    }
}

- (void)layoutAnimateWithPosition:(CGPoint)postion {
    CGFloat ballWidth = self.frame.size.width;
    CGFloat ballHeight = self.frame.size.height;
    CGFloat screenWidth = kScreenWidth;
    CGFloat screenHeight = kScreenHeight;
    
    CGFloat left = fabs(postion.x);
    CGFloat right = fabs(screenWidth - left);
    
    CGFloat minSpace = MIN(left, right);
    CGPoint newCenter = CGPointZero;
    CGFloat targetY = 0;
    
    //Correcting Y
    if (postion.y < kVerticalMargin + ballHeight / 2.0) {
        targetY = kVerticalMargin + ballHeight / 2.0;
    }else if (postion.y > (screenHeight - ballHeight / 2.0 - kVerticalMargin)) {
        targetY = screenHeight - ballHeight / 2.0 - kVerticalMargin;
    }else{
        targetY = postion.y;
    }
    
    CGFloat centerXSpace = kHorizenMargin + ballWidth/2;
    if (minSpace == left) {
        newCenter = CGPointMake(centerXSpace, targetY);
    }else if (minSpace == right) {
        newCenter = CGPointMake(screenWidth - centerXSpace, targetY);
    }
    
    [UIView animateWithDuration:.25 animations:^{
        self.center = newCenter;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _prismBtn.frame = self.bounds;
}

@end
