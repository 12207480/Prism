//
//  ViewController.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/16.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "ViewController.h"
#import "TYGCDTimer.h"
#import "TYDLog.h"
#import "TestANRViewController.h"
#import "TYSystemMonitor.h"

@interface ViewController ()<TYSystemMonitorDelegate>

@property (nonatomic, strong) TYGCDTimer* timer1;
@property (nonatomic, strong) TYGCDTimer* timer2;

@property (nonatomic, assign) long count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"start");
    _timer1 = [TYGCDTimer scheduledTimerOnAsynWithInterval:1.0 target:self selector:@selector(time1) repeats:YES];
    //_timer2 = [TYGCDTimer scheduledTimerOnAsynWithInterval:1.0 target:self selector:@selector(time2) repeats:YES];
    [TYSystemMonitor sharedInstance].delegate = self;
    [[TYSystemMonitor sharedInstance] start];
}

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateSystemCPUUsage:(ty_system_cpu_usage)system_cpu_usage {
    NSLog(@"system cpu %.1f",system_cpu_usage.total);
}

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateAppCPUUsage:(ty_app_cpu_usage)app_cpu_usage {
    NSLog(@"app cpu %.1f",app_cpu_usage.cpu_usage);
}

- (void)time1 {
    TYDLogInfo(@"log count %ld",++_count);
}

- (void)time2 {
    TYDLogInfo(@"log count %ld",++_count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testExceptionCrashAction:(id)sender {
    NSArray *text = [NSArray array];
    text[2];
}

- (IBAction)testSignalCrashAction:(id)sender {
    int *p;
    free(p);
}

- (IBAction)testANR:(id)sender {
    TestANRViewController *testANRVC = [[TestANRViewController alloc]init];
    [self.navigationController pushViewController:testANRVC animated:YES];
}

- (IBAction)testNetwork:(id)sender {
    NSString *urlString = @"http://gank.io/api/data/all/20/1";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError) {
        
    }];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://gank.io/api/data/iOS/10/1"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [task resume];
    
    NSURLSessionDataTask *errorTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://gank.io/api/data/iOS/Error"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    }];
    [errorTask resume];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task1 = [session dataTaskWithURL:[NSURL URLWithString:@"http://gank.io/api/data/Android/10/1"] completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
    }];
    [task1 resume];
}

- (void)dealloc
{
    [_timer1 invalidate];
    [_timer2 invalidate];
}

@end
