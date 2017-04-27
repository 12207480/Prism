//
//  LogRecordDataController.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/24.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYLogRecordController.h"
#import "TYLogCoreDataRecord.h"
#import "TYLogRecordDataController.h"

@interface TYLogRecordController ()

@end

@implementation TYLogRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"LogRecord";
    
    [self loadData];
}

#pragma mark - override

- (void)loadData {
    self.records = [[[TYLogCoreDataRecord sharedInstance] fetchDateRecordResults] mutableCopy];
    [self.tableView reloadData];

// 异步获取
//    [[TYLogCoreDataRecord sharedInstance] fetchAsynDateRecordResultsComplete:^(NSArray *results) {
//        self.records = [results mutableCopy];
//        [self.tableView reloadData];
//    }];
}

- (void)deleteRecordDataObjects:(NSArray *)deleteObjects {
    [[TYLogCoreDataRecord sharedInstance] deleteRecordDates:deleteObjects];
}

- (void)configureRecordCell:(TYRecordDateCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYLogDateRecord *record = self.records[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"Log-->Date--> %@",record.date];
}

- (void)didSelectTableViewRowAtIndexPath:(NSIndexPath *)indexPath {
    TYLogDateRecord *record = self.records[indexPath.row];
    TYLogRecordDataController *recordVC = [[TYLogRecordDataController alloc]init];
    recordVC.title = [NSString stringWithFormat:@"Log:%@",record.date];
    recordVC.recordId = record.id;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
