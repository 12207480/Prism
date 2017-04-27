//
//  TYANRRecordController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYANRRecordController.h"
#import "TYANRCoreDataRecord.h"
#import "TYANRRecordDataController.h"

@interface TYANRRecordController ()

@end

@implementation TYANRRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ANRRecord";
    
    [self loadData];
}

#pragma mark - override

- (void)loadData {
    self.records = [[[TYANRCoreDataRecord sharedInstance] fetchDateRecordResults] mutableCopy];
    [self.tableView reloadData];
}

- (void)deleteRecordDataObjects:(NSArray *)deleteObjects {
    [[TYANRCoreDataRecord sharedInstance] deleteRecordDates:deleteObjects];
}

- (void)configureRecordCell:(TYRecordDateCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYANRDateRecord *record = self.records[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"ANR-->Date--> %@",record.date];
}

- (void)didSelectTableViewRowAtIndexPath:(NSIndexPath *)indexPath {
    TYANRDateRecord *record = self.records[indexPath.row];
    TYANRRecordDataController *recordVC = [[TYANRRecordDataController alloc]init];
    recordVC.title = [NSString stringWithFormat:@"ANR:%@",record.date];
    recordVC.recordId = record.id;
    [self.navigationController pushViewController:recordVC animated:YES];
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
