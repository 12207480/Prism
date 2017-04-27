//
//  TYNetworkRecordDetailController.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/25.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetworkRecordDetailController.h"

@interface TYNetworkRecordDetailController ()

@property (nonatomic, weak) UITextView *textView;

@end

@implementation TYNetworkRecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addTextView];
    
    [self configureNetworkInfo];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _textView.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64);
}

- (void)addTextView {
    UITextView *textView = [[UITextView alloc]init];
    textView.backgroundColor = [UIColor colorWithRed:253/255. green:246/255. blue:227/255. alpha:1];
    textView.editable = NO;
    textView.textColor = [UIColor colorWithRed:81/255. green:81/255. blue:81/255. alpha:1];
    textView.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:textView];
    _textView = textView;
}

- (void)configureNetworkInfo {
    NSMutableString *text = [[NSMutableString alloc]init];
    [text appendFormat:@"Date:  %@\n",_networkInfo.date];
    [text appendFormat:@"During:  %.fms\n",_networkInfo.during.doubleValue*1000];
    [text appendFormat:@"Status:  %@\n",_networkInfo.statusCode];
    [text appendFormat:@"Method:  %@\n",_networkInfo.httpMethod];
    [text appendFormat:@"URL:  %@\n",_networkInfo.url];
    [text appendFormat:@"Body:  %@\n",_networkInfo.httpBody];
    [text appendFormat:@"HTTPHeaderField:  %@\n\n",_networkInfo.requestAllHTTPHeaderFields];
    [text appendFormat:@"MimeType:  %@\n",_networkInfo.mimeType];
    [text appendFormat:@"ContentLength:  %.fkb\n",_networkInfo.expectedContentLength.doubleValue/1024];
    [text appendFormat:@"ResponseHeaderFields:  %@\n",_networkInfo.responseAllHeaderFields];
    [text appendFormat:@"ResponseData:  %@\n",_networkInfo.responseData];
    _textView.text = [text copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
