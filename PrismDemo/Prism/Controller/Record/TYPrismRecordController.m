//
//  TYPrismRecordController.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/28.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYPrismRecordController.h"
#import "TYPrismRecordItem.h"
#import "TYLogRecordController.h"
#import "TYCrashRecordController.h"
#import "TYANRRecordController.h"
#import "TYNetworkRecordController.h"

@interface TYPrismRecordController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *items;

@end

static NSString * const cellId = @"UITableViewCell";

@implementation TYPrismRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Record";
    
    [self addTableView];
    
    [self addItems];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)addItems {
    __weak typeof(self) weakSelf = self;
    
    TYPrismRecordItem *logRecordItem = [[TYPrismRecordItem alloc]init];
    logRecordItem.title = @"Log";
    logRecordItem.subTitle = @"NSLog Monitor Record";
    [logRecordItem setSelectCellHandle:^(TYPrismRecordItem *item) {
        TYLogRecordController *recordVC = [[TYLogRecordController alloc]init];
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    }];
    
    TYPrismRecordItem *crashRecordItem = [[TYPrismRecordItem alloc]init];
    crashRecordItem.title = @"Crash";
    crashRecordItem.subTitle = @"App Crash Call Stack Record";
    [crashRecordItem setSelectCellHandle:^(TYPrismRecordItem *item) {
        TYCrashRecordController *recordVC = [[TYCrashRecordController alloc]init];
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    }];
    
    TYPrismRecordItem *ANRRecordItem = [[TYPrismRecordItem alloc]init];
    ANRRecordItem.title = @"ANR";
    ANRRecordItem.subTitle = @"Application Not Responding Monitor Record";
    [ANRRecordItem setSelectCellHandle:^(TYPrismRecordItem *item) {
        TYANRRecordController *recordVC = [[TYANRRecordController alloc]init];
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    }];
    
    TYPrismRecordItem *networkRecordItem = [[TYPrismRecordItem alloc]init];
    networkRecordItem.title = @"Network";
    networkRecordItem.subTitle = @"Application Network Request Monitor Record";
    [networkRecordItem setSelectCellHandle:^(TYPrismRecordItem *item) {
        TYNetworkRecordController *recordVC = [[TYNetworkRecordController alloc]init];
        [weakSelf.navigationController pushViewController:recordVC animated:YES];
    }];
    
    _items = @[logRecordItem,crashRecordItem,ANRRecordItem,networkRecordItem];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        TYPrismRecordItem *item = _items[indexPath.row];
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = item.subTitle;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYPrismRecordItem *item = _items[indexPath.row];
    return item.cellHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYPrismRecordItem *item = _items[indexPath.row];
    if (item.selectCellHandle) {
        item.selectCellHandle(item);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
