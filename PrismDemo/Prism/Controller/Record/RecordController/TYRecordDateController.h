//
//  TYRecordDateController.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRecordDateCell.h"

@interface TYRecordDateController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *records;

@property (nonatomic, strong) NSString *cellId;


// override

- (void)deleteRecordDataObjects:(NSArray *)deleteObjects;

- (void)configureRecordCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)didSelectTableViewRowAtIndexPath:(NSIndexPath *)indexPath;

@end
