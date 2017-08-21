//
//  TYPrismSettingController.m
//  PrismDemo
//
//  Created by tany on 2017/8/17.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYPrismSettingController.h"
#import "TYPrismSettingCell.h"
#import "TYPrismSettingItem.h"
#import "TYPrismRecord.h"

@interface TYPrismSettingController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *items;

@end

static NSString *cellId = @"TYPrismSettingCell";

@implementation TYPrismSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addItems];
    
    [self addTableView];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerClass:[TYPrismSettingCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)addItems {
    TYPrismSettingItem *logItem = [[TYPrismSettingItem alloc]init];
    logItem.title = @"Log Moniotor Switch";
    [logItem setAccessoryViewHandle:^(TYPrismSettingItem *item, UIView *accessoryView){
        UISwitch *switchView = (UISwitch *)accessoryView;
        if (!switchView.isOn) {
            [[TYLogCoreDataRecord sharedInstance] stop];
        }else {
            [[TYLogCoreDataRecord sharedInstance] start];
        }
    }];
    TYPrismSettingItem *ANRItem = [[TYPrismSettingItem alloc]init];
    ANRItem.title = @"ANR Moniotor Switch";
    [ANRItem setAccessoryViewHandle:^(TYPrismSettingItem *item, UIView *accessoryView){
        UISwitch *switchView = (UISwitch *)accessoryView;
        if (!switchView.isOn) {
            [[TYANRCoreDataRecord sharedInstance] stop];
        }else {
            [[TYANRCoreDataRecord sharedInstance] start];
        }
    }];
    TYPrismSettingItem *crashItem = [[TYPrismSettingItem alloc]init];
    crashItem.title = @"Crash Moniotor Switch";
    [crashItem setAccessoryViewHandle:^(TYPrismSettingItem *item, UIView *accessoryView){
        UISwitch *switchView = (UISwitch *)accessoryView;
        if (!switchView.isOn) {
            [[TYCrashCoreDataRecord sharedInstance] stop];
        }else {
            [[TYCrashCoreDataRecord sharedInstance] start];
        }
    }];
    TYPrismSettingItem *networkItem = [[TYPrismSettingItem alloc]init];
    networkItem.title = @"Network Moniotor Switch";
    [networkItem setAccessoryViewHandle:^(TYPrismSettingItem *item, UIView *accessoryView){
        UISwitch *switchView = (UISwitch *)accessoryView;
        if (!switchView.isOn) {
            [[TYNetworkCoreDataRecord sharedInstance] stop];
        }else {
            [[TYNetworkCoreDataRecord sharedInstance] start];
        }
    }];
    
    _items = @[logItem,ANRItem,crashItem,networkItem];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYPrismSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    TYPrismSettingItem *item = _items[indexPath.row];
    cell.item = item;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYPrismSettingItem *item = _items[indexPath.row];
    return item.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYPrismSettingItem *item = _items[indexPath.row];
    if (item.selectCellHandle) {
        item.selectCellHandle(item);
    }
}

@end
