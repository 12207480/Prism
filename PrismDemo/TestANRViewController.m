//
//  TestANRViewController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/5.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TestANRViewController.h"

@interface TestANRViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TestANRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addTableView];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"row %ld",(long)indexPath.row];
    if (indexPath.row != 0 && indexPath.row % 21 == 0) {
        usleep(2000*1000);
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    usleep(2000*1000);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
