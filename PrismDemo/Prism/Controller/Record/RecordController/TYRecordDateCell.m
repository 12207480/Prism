//
//  TYLogRecordDataCell.m
//  PrismMonitorDemo
//
//  Created by tany on 17/3/27.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYRecordDateCell.h"

#define kTitleLabelLeftEdge 15
#define kTitleLabelRightEdge 50

@implementation TYRecordDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addTitleLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addTitleLabel];
    }
    return self;
}

- (void)addTitleLabel {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
    [self.contentView addSubview:label];
    _titleLabel = label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(self.separatorInset.left + kTitleLabelLeftEdge, 0, CGRectGetWidth(self.frame)-kTitleLabelLeftEdge-kTitleLabelRightEdge-self.separatorInset.left, CGRectGetHeight(self.frame));
}

@end
