//
//  TYRecordConsoleController.h
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/1.
//  Copyright © 2017年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCoreDataRecord.h"
#import "TYRecordConsoleCell.h"

@interface TYRecordConsoleController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIFont *consoleTextFont;

@property (nonatomic, strong) NSString *cellId;

@property (nonatomic, strong, readonly) NSMutableDictionary *cellHeightCache;

@property (nonatomic, assign) BOOL needScrollToBottom;

- (void)reloadData;

- (CGFloat)heightForText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size;

@end
