//
//  LogRecordMsgController.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/24.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYLogRecordDataController.h"
#import "TYLogCoreDataRecord.h"

@interface TYLogRecordDataController ()

@end

@implementation TYLogRecordDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)loadData {
    self.fetchedResultsController = [[TYLogCoreDataRecord sharedInstance] fetchedResultsControllerWithRecordId:_recordId];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYRecordConsoleCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    TYLogMsgRecord *logMsg = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.font = self.consoleTextFont;
    cell.titleLabel.text = logMsg.message;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYLogMsgRecord *logMsg = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSNumber *cellHeight = [self.cellHeightCache objectForKey:logMsg.time];
    if (!cellHeight) {
        NSInteger textHeight = [self heightForText:logMsg.message font:self.consoleTextFont constrainedToSize:CGSizeMake(CGRectGetWidth(tableView.frame) - kConsoleCellTitleLabelHorEdge*2, 1000)];
        cellHeight = @(textHeight + kConsoleCellTitleLabelVerEdge*2);
        self.cellHeightCache[logMsg.time] = cellHeight;
    }
    return cellHeight.integerValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
