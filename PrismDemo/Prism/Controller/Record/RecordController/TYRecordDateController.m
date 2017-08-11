//
//  TYRecordDateController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/10.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYRecordDateController.h"

@interface TYRecordDateController ()

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) UIBarButtonItem *deleteItem;
@property (nonatomic, strong) UIBarButtonItem *cancleItem;
@property (nonatomic, strong) UIBarButtonItem *selectItem;

@end

@implementation TYRecordDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_cellId) {
        _cellId = @"TYRecordDateCell";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.deleteItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
    self.cancleItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAction)];
    self.selectItem = [[UIBarButtonItem alloc]initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllAction)];
    self.navigationItem.rightBarButtonItem = self.deleteItem;
    [self addTableView];
    [self.tableView registerClass:NSClassFromString(_cellId) forCellReuseIdentifier:_cellId];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

#pragma mark - override

- (void)deleteRecordDataObjects:(NSArray *)deleteObjects {
    
}

- (void)configureRecordCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didSelectTableViewRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - action

- (void)deleteAction {
    if (self.tableView.indexPathsForSelectedRows.count == 0 || !self.tableView.editing) {
        self.navigationItem.rightBarButtonItems = @[self.cancleItem,self.selectItem];
        self.tableView.allowsMultipleSelectionDuringEditing = YES;
        [self.tableView setEditing:YES animated:YES];
    }else {
        NSMutableIndexSet *indexSets = [NSMutableIndexSet indexSet];
        NSMutableArray *deleteObjects = [NSMutableArray array];
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            id record = _records[indexPath.row];
            [deleteObjects addObject:record];
            [indexSets addIndex:indexPath.row];
        }
        [_records removeObjectsAtIndexes:indexSets];
        [_tableView deleteRowsAtIndexPaths:self.tableView.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        self.navigationItem.rightBarButtonItem = self.cancleItem;
        
        [self deleteRecordDataObjects:deleteObjects];
    }
}

- (void)selectAllAction {
    for (int i = 0; i < _records.count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [self selectRows];
}

- (void)cancleAction {
    self.deleteItem.title = @"删除";
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = self.deleteItem;
    [self.tableView setEditing:NO animated:YES];
}

- (void)selectRows {
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        self.navigationItem.rightBarButtonItem = self.cancleItem;
    }else {
        self.deleteItem.title = [NSString stringWithFormat:@"删除%ld",self.tableView.indexPathsForSelectedRows.count];
        self.navigationItem.rightBarButtonItem = self.deleteItem;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellId forIndexPath:indexPath];
    [self configureRecordCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        [self selectRows];
        return;
    }
    [self didSelectTableViewRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        [self selectRows];
        return;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _tableView.delegate = nil;
}

@end
