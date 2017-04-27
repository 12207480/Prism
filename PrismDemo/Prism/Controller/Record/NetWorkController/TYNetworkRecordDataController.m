//
//  TYNetworkRecordDataController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/21.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetworkRecordDataController.h"
#import "TYNetworkCoreDataRecord.h"
#import "TYNetworkRecordDetailController.h"

@interface TYNetworkRecordDataController ()

@end

@implementation TYNetworkRecordDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self loadData];
}

- (void)loadData {
    self.fetchedResultsController = [[TYNetworkCoreDataRecord sharedInstance] fetchedResultsControllerWithRecordId:_recordId];
    self.fetchedResultsController.delegate = self;
    NSError *error = NULL;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"NSFetchedResultsController performFetch error:%@",error);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        [self reloadData];
    });
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed:15/255. green:137/255. blue:253/255. alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    TYNetworkInfoRecord *networkInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = networkInfo.url;
    NSString *content = [NSString stringWithFormat:@"%@   %@   %.fms         %@",networkInfo.statusCode,networkInfo.httpMethod,[networkInfo.during doubleValue]*1000,networkInfo.date];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName: [UIColor colorWithRed:81/255. green:81/255. blue:81/255. alpha:1]}];
    [attString addAttributes:@{NSForegroundColorAttributeName: networkInfo.statusCode.integerValue == 200 ? [UIColor colorWithRed:51/255. green:200/255. blue:55/255. alpha:1]:[UIColor colorWithRed:246/255. green:62/255. blue:52/255. alpha:1]} range:[content rangeOfString:networkInfo.statusCode.stringValue]];
    cell.detailTextLabel.attributedText = attString;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYNetworkRecordDetailController *detailVC = [[TYNetworkRecordDetailController alloc]init];
    detailVC.networkInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
