//
//  TYRecordConsoleController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/1.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYRecordConsoleController.h"

@interface TYRecordConsoleController ()

@property (nonatomic, assign) BOOL scrollToBottom;

@end

@implementation TYRecordConsoleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_cellId) {
        _cellId = @"TYRecordConsoleCell";
    }
    _needScrollToBottom = YES;
    _cellHeightCache = [NSMutableDictionary dictionary];
    self.view.backgroundColor = [UIColor colorWithRed:253/255. green:246/255. blue:227/255. alpha:1];
    _scrollToBottom = YES;
    _consoleTextFont = [UIFont systemFontOfSize:12];
    
    [self addTableView];
    
    [self.tableView registerClass:NSClassFromString(_cellId) forCellReuseIdentifier:_cellId];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor colorWithRed:253/255. green:246/255. blue:227/255. alpha:1];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)reloadData {
    [_tableView reloadData];
    if (_needScrollToBottom && _scrollToBottom) {
        [self scrollsToBottomAnimated:NO];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fetchedResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (CGFloat)heightForText:(NSString *)text font:(UIFont *)font constrainedToSize:(CGSize)size{
    CGRect frame = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName:font } context:nil];
    return ceil(frame.size.height)+1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrollToBottom = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollToBottom = scrollView.contentOffset.y + scrollView.frame.size.height + 64 >= scrollView.contentSize.height - 2;
}

- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
    if (offset+64 > 0)
    {
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

/********* first method-> reloadData *********/
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    dispatch_async(dispatch_get_main_queue(), ^{
        // something
        [self reloadData];
    });
}

/********* second method-> insertData *********/
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
//
//    switch (type) {
//        case NSFetchedResultsChangeInsert: {
//            [_tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//
//            break;
//        }
//        case NSFetchedResultsChangeDelete:{
//            [_tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)object atIndexPath:(NSIndexPath *)indexPath
//     forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//
//    void (^deleteIndexPathRows)(void) = ^{
//        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    };
//
//    void (^insertNewIndexPathRows)(void) = ^{
//        [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        if (_scrollToBottom) {
//            [self scrollsToBottomAnimated:NO];
//        }
//    };
//    dispatch_async(dispatch_get_main_queue(), ^{
//        switch (type) {
//            case NSFetchedResultsChangeInsert: {
//                insertNewIndexPathRows();
//                break;
//            }
//            case NSFetchedResultsChangeDelete: {
//                deleteIndexPathRows();
//                break;
//            }
//            case NSFetchedResultsChangeMove: {
//                deleteIndexPathRows();
//                insertNewIndexPathRows();
//                break;
//            }
//            case NSFetchedResultsChangeUpdate: {
//                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                break;
//            }
//        }
//
//    });
//}

- (void)dealloc {
    _fetchedResultsController.delegate = nil;
    _tableView.delegate = nil;
}

@end
