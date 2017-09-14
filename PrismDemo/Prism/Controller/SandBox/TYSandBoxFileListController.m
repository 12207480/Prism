//
//  TYSandBoxFileListController.m
//  PrismDemo
//
//  Created by tany on 2017/9/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYSandBoxFileListController.h"
#import "TYSandBoxFileItem.h"

@interface TYSandBoxFileListController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *fileList;

@end

@implementation TYSandBoxFileListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    
    [self addFileList];
    
    [_tableView reloadData];
}

- (void)addTableView {
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 70;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)addFileList {
    NSString *filePath = _filePath ? _filePath : NSHomeDirectory();
    NSMutableArray *fileList = [NSMutableArray array];
    
    NSError *error = nil;
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
    if (error) {
        NSLog(@"filePath error:%@",error);
        return;
    }
    for (NSString *file in paths) {
        NSString *pathExtension = file.pathExtension;
        NSString *fileItemPath = [filePath stringByAppendingPathComponent:file];
        BOOL isDir = NO;
        if (pathExtension.length == 0) {
            [[NSFileManager defaultManager]fileExistsAtPath:fileItemPath isDirectory:&isDir];
        }
        NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:fileItemPath error:&error];
        TYSandBoxFileItem *fileItem = [[TYSandBoxFileItem alloc]init];
        fileItem.fileName = file;
        fileItem.filePath = fileItemPath;
        fileItem.fileType = isDir ? TYSandBoxFileTypeDir : [fileItem typeWithFileExtension:pathExtension];
        fileItem.fileDate = [attr objectForKey:NSFileModificationDate];
        [fileList addObject:fileItem];
    }
    _fileList = [fileList copy];
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    [self addFileList];
    [_tableView reloadData];
}

#pragma mark - private

- (UIImage *)imageWithFileType:(TYSandBoxFileType)fileType {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SandBox" ofType:@"bundle"];
    NSString *imageName= nil;
    switch (fileType) {
        case TYSandBoxFileTypeDir:
            imageName = @"directory.png";
            break;
        case TYSandBoxFileTypeImage:
        case TYSandBoxFileTypePDF:
            imageName = @"image.png";
            break;
        case TYSandBoxFileTypePlist:
            imageName = @"plist.png";
            break;
        case TYSandBoxFileTypeLog:
            imageName = @"log.png";
            break;
        case TYSandBoxFileTypeSQL:
            imageName = @"sqlite.png";
            break;
        default:
            imageName = @"file.png";
            break;
    }
    return [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]];
}

+ (NSDateFormatter *)dateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter * dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
    });
    return dateFormatter;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    TYSandBoxFileItem *fileItem = _fileList[indexPath.row];
    cell.textLabel.text = fileItem.fileName;
    //cell.detailTextLabel.text = [[[self class] dateFormatter] stringFromDate:fileItem.fileDate];
    cell.imageView.image = [self imageWithFileType:fileItem.fileType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TYSandBoxFileItem *fileItem = _fileList[indexPath.row];
    if (fileItem.fileType == TYSandBoxFileTypeDir) {
        TYSandBoxFileListController *listVC = [[TYSandBoxFileListController alloc]init];
        listVC.filePath = fileItem.filePath;
        [self.navigationController pushViewController:listVC animated:YES];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
