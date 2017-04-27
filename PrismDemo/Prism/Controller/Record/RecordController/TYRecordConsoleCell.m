//
//  TYRecordConsoleCell.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/11.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYRecordConsoleCell.h"

@implementation TYRecordConsoleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addTitleLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addTitleLabel];
    }
    return self;
}

- (void)addTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:81/255. green:81/255. blue:81/255. alpha:1];
    //label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    [self.contentView addSubview:label];
    _titleLabel = label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(kConsoleCellTitleLabelHorEdge, kConsoleCellTitleLabelVerEdge, CGRectGetWidth(self.frame)-kConsoleCellTitleLabelHorEdge*2, CGRectGetHeight(self.frame)- kConsoleCellTitleLabelVerEdge*2);
}

@end
