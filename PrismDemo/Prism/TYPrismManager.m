//
//  TYPrismManager.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/28.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYPrismManager.h"
#import "TYPrismView.h"
#import "TYPrismTabBarController.h"
#import "TYPrismRecord.h"
#import "TYSystemMonitor.h"

@interface TYPrismManager () <TYPrismViewDelegate>

@property (nonatomic, strong) TYPrismView *prismView;

@property (nonatomic, weak)UIViewController *presentViewController;

@end

@implementation TYPrismManager

+ (TYPrismManager *)sharedInstance
{
    static TYPrismManager *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (TYPrismView *)prismView {
    if (!_prismView) {
        _prismView = [[TYPrismView alloc]init];
        _prismView.prismDelegate = self;
        [_prismView.prismBtn setTitle:@"Prism" forState:UIControlStateNormal];
        [_prismView.prismBtn setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        _prismView.backgroundColor = [UIColor colorWithRed:0.97 green:0.30 blue:0.30 alpha:1.00];
    }
    return _prismView;
}

#pragma mark - publc

- (void)start {
    [TYFPSLabel showInStutasBar];
    [[TYLogCoreDataRecord sharedInstance] start];
    [[TYCrashCoreDataRecord sharedInstance] start];
    [[TYANRCoreDataRecord sharedInstance] start];
    [[TYNetworkCoreDataRecord sharedInstance] start];
    [[TYSystemMonitor sharedInstance] start];
    [self.prismView show];
}

- (void)stop {
    [TYFPSLabel hide];
    [[TYLogCoreDataRecord sharedInstance] stop];
    [[TYCrashCoreDataRecord sharedInstance] stop];
    [[TYANRCoreDataRecord sharedInstance] stop];
    [[TYNetworkCoreDataRecord sharedInstance] stop];
    [[TYSystemMonitor sharedInstance] stop];
}

+ (void)start {
    [[TYPrismManager sharedInstance] start];
}

+(void)stop {
    [[TYPrismManager sharedInstance] stop];
}

#pragma mark - private

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    } else {
        return [app keyWindow];
    }
}

#pragma mark - TYPrismViewDelegate

- (void)prismViewDidClickedAction:(TYPrismView *)prismView {
    if (!_presentViewController) {
        TYPrismTabBarController *tabbarVC = [[TYPrismTabBarController alloc]init];
        UIViewController *rootVC = [self mainWindow].rootViewController;
        if (rootVC) {
            _presentViewController = tabbarVC;
            [rootVC presentViewController:tabbarVC animated:YES completion:nil];
            prismView.isSelected = YES;
        }
    }else {
        [_presentViewController dismissViewControllerAnimated:YES completion:nil];
        prismView.isSelected = NO;
    }
}

@end
