//
//  TYPrismSettingCell.m
//  PrismDemo
//
//  Created by tany on 2017/8/18.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYPrismSettingCell.h"

@implementation TYPrismSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addAccessoryView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addAccessoryView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setItem:(TYPrismSettingItem *)item {
    _item = item;
    self.textLabel.text = item.title;
    if (!item.accessoryViewHandle) {
        self.accessoryView = nil;
        self.accessoryType = item.accessoryType;
    }
}

- (void)addAccessoryView {
    UISwitch *switchView = [[UISwitch alloc]init];
    switchView.on = YES;
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.accessoryView = switchView;
}

- (void)switchAction:(UISwitch *)switchView {
    if (_item.accessoryViewHandle) {
        _item.accessoryViewHandle(_item, switchView);
    }
}

@end
