//
//  BLEConnectListCell.m
//  爱德宝
//
//  Created by A-XIU on 2017/4/2.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "BLEConnectListCell.h"

@implementation BLEConnectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.f;
    _bgView.layer.borderWidth = 1.f;
    _bgView.layer.borderColor = [UIColor colorWithWhite:1 alpha:.5f].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
