//
//  TYNetworkRecordController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/19.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetworkRecordController.h"
#import "TYNetworkCoreDataRecord.h"
#import "TYNetworkRecordDataController.h"

@interface TYNetworkRecordController ()

@end

@implementation TYNetworkRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"NetworkRecord";
    
    [self loadData];
}

#pragma mark - override

- (void)loadData {
//    self.records = [[[TYNetworkCoreDataRecord sharedInstance] fetchDateRecordResults] mutableCopy];
//    [self.tableView reloadData];
    //异步获取
    [[TYNetworkCoreDataRecord sharedInstance] fetchAsynDateRecordResultsComplete:^(NSArray *results) {
        self.records = [results mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)deleteRecordDataObjects:(NSArray *)deleteObjects {
    [[TYNetworkCoreDataRecord sharedInstance] deleteRecordDates:deleteObjects];
}

- (void)configureRecordCell:(TYRecordDateCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYNetworkDateRecord *record = self.records[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"Network-->Date--> %@",record.date];
}

- (void)didSelectTableViewRowAtIndexPath:(NSIndexPath *)indexPath {
    TYNetworkDateRecord *record = self.records[indexPath.row];
    TYNetworkRecordDataController *recordVC = [[TYNetworkRecordDataController alloc]init];
    recordVC.title = [NSString stringWithFormat:@"Network:%@",record.date];
    recordVC.recordId = record.id;
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
