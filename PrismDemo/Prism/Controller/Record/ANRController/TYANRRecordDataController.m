//
//  TYANRRecordDataController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/11.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYANRRecordDataController.h"
#import "TYANRCoreDataRecord.h"

@interface TYANRRecordDataController ()

@end

@implementation TYANRRecordDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
}

- (void)loadData {
    self.fetchedResultsController = [[TYANRCoreDataRecord sharedInstance] fetchedResultsControllerWithRecordId:_recordId];
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
    TYANRInfoRecord *ANRInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.font = self.consoleTextFont;
    cell.titleLabel.text = ANRInfo.message;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYANRInfoRecord *ANRInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSNumber *cellHeight = [self.cellHeightCache objectForKey:ANRInfo.time];
    if (!cellHeight) {
        NSInteger textHeight = [self heightForText:ANRInfo.message font:self.consoleTextFont constrainedToSize:CGSizeMake(CGRectGetWidth(tableView.frame) - kConsoleCellTitleLabelHorEdge*2, 1000)];
        cellHeight = @(textHeight + kConsoleCellTitleLabelVerEdge*2);
        self.cellHeightCache[ANRInfo.time] = cellHeight;
    }
    return cellHeight.integerValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
