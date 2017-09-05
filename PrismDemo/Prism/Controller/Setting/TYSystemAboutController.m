//
//  TYSystemAboutController.m
//  PrismDemo
//
//  Created by tany on 2017/9/1.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYSystemAboutController.h"
#import "TYSystemMonitor.h"

@interface TYSystemAboutController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation TYSystemAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"About";
    UIDevice.currentDevice.batteryMonitoringEnabled = YES;
    
    [self addSystemInfo];
    
    [self addTableView];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)addSystemInfo {
    self.infoArray = [NSMutableArray array];
    
    NSString *deviceName = [TYDeviceInfo getDeviceName];
    NSDictionary *dict1 = @{
                            @"infoKey"   : @"Device Name",
                            @"infoValue" : deviceName
                            };
    [self.infoArray addObject:dict1];
    
    NSString *iPhoneName = [UIDevice currentDevice].name;
    NSDictionary *dict2 = @{
                            @"infoKey"   : @"iPhone Name",
                            @"infoValue" : iPhoneName
                            };
    [self.infoArray addObject:dict2];
    
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dict3 = @{
                            @"infoKey"   : @"App Verion",
                            @"infoValue" : appVerion
                            };
    [self.infoArray addObject:dict3];
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSDictionary *dict4 = @{
                            @"infoKey"   : @"Battery Level",
                            @"infoValue" : [@(batteryLevel) stringValue]
                            };
    [self.infoArray addObject:dict4];
    
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    NSDictionary *dict5 = @{
                            @"infoKey"   : @"Localized Model",
                            @"infoValue" : localizedModel
                            };
    [self.infoArray addObject:dict5];
    
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSDictionary *dict6 = @{
                            @"infoKey"   : @"System Name",
                            @"infoValue" : systemName
                            };
    [self.infoArray addObject:dict6];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSDictionary *dict7 = @{
                            @"infoKey"   : @"System Version",
                            @"infoValue" : systemVersion
                            };
    [self.infoArray addObject:dict7];
    
    NSString *device_model = [TYDeviceInfo getDeviceModel];
    NSDictionary *dict8 = @{
                            @"infoKey"   : @"Device Model",
                            @"infoValue" : device_model
                            };
    [self.infoArray addObject:dict8];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSDictionary *dict9 = @{
                            @"infoKey"   : @"Screen Pixel",
                            @"infoValue" : [NSString stringWithFormat:@"%.f × %.f",size.width*[UIScreen mainScreen].scale,size.height*[UIScreen mainScreen].scale]
                            };
    [self.infoArray addObject:dict9];
    
    NSUInteger CPUCoreNumber = [TYCPUUsage getCPUCoreNumber];
    NSDictionary *dict12 = @{
                             @"infoKey"   : @"CPU Core Number",
                             @"infoValue" : @(CPUCoreNumber).stringValue
                             };
    [self.infoArray addObject:dict12];
    
    NSString *cellularIP = [TYNetworkFlow getCellularIPAddress];
    NSDictionary *dict11 = @{
                             @"infoKey"   : @"Cellular IP",
                             @"infoValue" : cellularIP
                             };
    [self.infoArray addObject:dict11];
    
    NSString *wifiIP = [TYNetworkFlow getWifiIPAddress];
    NSDictionary *dict13 = @{
                            @"infoKey"   : @"WIFI IP",
                            @"infoValue" : wifiIP
                            };
    [self.infoArray addObject:dict13];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *info = self.infoArray[indexPath.row];
    cell.textLabel.text = [info objectForKey:@"infoKey"];
    cell.detailTextLabel.text = [info objectForKey:@"infoValue"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    UIDevice.currentDevice.batteryMonitoringEnabled = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
