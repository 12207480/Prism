//
//  TYPrismTabBarController.m
//  PrismDemo
//
//  Created by tany on 2017/4/27.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYPrismTabBarController.h"
#import "TYPrismRecordController.h"

@interface TYPrismTabBarController ()

@end

@implementation TYPrismTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureChildViewControllers];
}

- (void)configureChildViewControllers
{
    [self addRecordController];
}

- (void)addRecordController {
    TYPrismRecordController *recordVC = [[TYPrismRecordController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:recordVC];
    recordVC.tabBarItem.title = @"Record";
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
