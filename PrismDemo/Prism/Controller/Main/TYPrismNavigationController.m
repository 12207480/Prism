//
//  LPNavigationController.m
//  LovePlayNews
//
//  Created by tany on 16/8/1.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYPrismNavigationController.h"

@interface TYPrismNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TYPrismNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.enableRightGesture = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self configureNavBarTheme];
}

- (void)configureNavBarTheme
{
    // 去掉导航栏底部阴影
    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return self.enableRightGesture;
}

#pragma mark - override

// override pushViewController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
