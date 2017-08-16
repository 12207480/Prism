//
//  TYSystemMinitorController.m
//  PrismDemo
//
//  Created by tany on 2017/8/16.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYSystemMinitorController.h"
#import "TYSystemMonitor.h"

@interface TYSystemMinitorController () <TYSystemMonitorDelegate>
@property (weak, nonatomic) IBOutlet UILabel *appRAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *sysRAMLabel;
@property (weak, nonatomic) IBOutlet UILabel *appCPULabel;
@property (weak, nonatomic) IBOutlet UILabel *sysCPULabel;
@property (weak, nonatomic) IBOutlet UILabel *freeDiskLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDiskLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowSendLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowReceived;
@property (weak, nonatomic) IBOutlet UILabel *flowTotalSendLabel;
@property (weak, nonatomic) IBOutlet UILabel *flowTotalReceivedLabel;

@end

@implementation TYSystemMinitorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [TYSystemMonitor sharedInstance].delegate = self;
    
    self.freeDiskLabel.text = [NSString stringWithFormat:@"%.1fGB",1.0*[TYDiskUsage getDiskFreeSize]/1024/1024/1024];
    self.totalDiskLabel.text = [NSString stringWithFormat:@"%.1fGB",1.0*[TYDiskUsage getDiskTotalSize]/1024/1024/1024];
}

#pragma mark - TYSystemMonitorDelegate

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateAppCPUUsage:(ty_app_cpu_usage)app_cpu_usage {
    self.appCPULabel.text = [NSString stringWithFormat:@"%.1f%%",app_cpu_usage.cpu_usage];
}

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateSystemCPUUsage:(ty_system_cpu_usage)system_cpu_usage {
    self.sysCPULabel.text = [NSString stringWithFormat:@"%.1f%%",system_cpu_usage.total];
}

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateAppMemoryUsage:(unsigned long long)app_memory_usage {
    self.appRAMLabel.text = [NSString stringWithFormat:@"%.1fMB",1.0*app_memory_usage/1024/1024];
}

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateSystemMemoryUsage:(ty_system_memory_usage)system_memory_usage {
    self.sysRAMLabel.text = [NSString stringWithFormat:@"%.1f%%",100.0*system_memory_usage.used_size/system_memory_usage.total_size];
}

- (void)systemMonitor:(TYSystemMonitor *)systemMonitor didUpdateNetworkFlowSent:(unsigned int)sent received:(unsigned int)received total:(ty_flow_IOBytes)total {
    self.flowSendLabel.text = [NSString stringWithFormat:@"%.2fkB/s",1.0*sent/1024];
    self.flowReceived.text = [NSString stringWithFormat:@"%.2fkB/s",1.0*received/1024];
    self.flowTotalSendLabel.text = [NSString stringWithFormat:@"%.2fMB",1.0*total.totalSent/1024/1024];
    self.flowTotalReceivedLabel.text = [NSString stringWithFormat:@"%.2fMB",1.0*total.totalReceived/1024/1024];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
