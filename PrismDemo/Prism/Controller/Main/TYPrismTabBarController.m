//
//  TYPrismTabBarController.m
//  PrismDemo
//
//  Created by tany on 2017/4/27.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYPrismTabBarController.h"
#import "TYPrismNavigationController.h"
#import "TYPrismRecordController.h"
#import "TYSystemMinitorController.h"
#import "TYSandBoxFileListController.h"
#import "TYPrismSettingController.h"

@interface TYPrismTabBarController ()

@end

@implementation TYPrismTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureChildViewControllers];
}

- (void)configureChildViewControllers
{
    [self addRecordController];
    
    [self addSystemMonitorController];
    
    [self addSandBoxFileListController];
    
    [self addSettingController];
}

- (void)addRecordController {
    TYPrismRecordController *recordVC = [[TYPrismRecordController alloc]init];
    TYPrismNavigationController *nav = [[TYPrismNavigationController alloc] initWithRootViewController:recordVC];
    recordVC.title = @"Record";
    recordVC.tabBarItem.title = @"Record";
    
    [self addChildViewController:nav];
}

- (void)addSystemMonitorController {
    TYSystemMinitorController *monitorVC = [[TYSystemMinitorController alloc]init];
    TYPrismNavigationController *nav = [[TYPrismNavigationController alloc] initWithRootViewController:monitorVC];
    monitorVC.title = @"Monitor";
    monitorVC.tabBarItem.title = @"Monitor";
    
    [self addChildViewController:nav];
}

- (void)addSandBoxFileListController {
    TYSandBoxFileListController *settingVC = [[TYSandBoxFileListController alloc]init];
    TYPrismNavigationController *nav = [[TYPrismNavigationController alloc] initWithRootViewController:settingVC];
    settingVC.title = @"SandBox";
    settingVC.tabBarItem.title = @"SandBox";
    
    [self addChildViewController:nav];
}

- (void)addSettingController {
    TYPrismSettingController *settingVC = [[TYPrismSettingController alloc]init];
    TYPrismNavigationController *nav = [[TYPrismNavigationController alloc] initWithRootViewController:settingVC];
    settingVC.title = @"Setting";
    settingVC.tabBarItem.title = @"Setting";
    
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
