//
//  TYCrashRecordController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/3/31.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYCrashRecordController.h"
#import "TYCrashCoreDataRecord.h"

@interface TYCrashRecordController ()

@end

@implementation TYCrashRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CrashRecord";
    
    [self loadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        [self reloadData];
    });
}

- (void)loadData {
    self.fetchedResultsController = [[TYCrashCoreDataRecord sharedInstance] fetchedResultsController];
    self.fetchedResultsController.delegate = self;
    NSError *error = NULL;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"NSFetchedResultsController performFetch error:%@",error);
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TYRecordConsoleCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
    TYCrashInfoRecord *crashInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.font = self.consoleTextFont;
    cell.titleLabel.text = [crashInfo message];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYCrashInfoRecord *crashInfo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSNumber *cellHeight = [self.cellHeightCache objectForKey:crashInfo.id];
    if (!cellHeight) {
        NSInteger textHeight = [self heightForText:	[crashInfo message] font:self.consoleTextFont constrainedToSize:CGSizeMake(CGRectGetWidth(tableView.frame) - kConsoleCellTitleLabelHorEdge*2, 1000)];
        cellHeight = @(textHeight + kConsoleCellTitleLabelVerEdge*2);
        self.cellHeightCache[crashInfo.id] = cellHeight;
    }
    return cellHeight.integerValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
