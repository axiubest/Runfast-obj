//
//  WordGradeCell.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/9.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "WordGradeCell.h"


@interface WordGradeCell ()

@property (weak, nonatomic) IBOutlet UILabel *gradeLab;

@property (weak, nonatomic) IBOutlet UIImageView *huangguanImageView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userKmLab;
@end

@implementation WordGradeCell



- (void)awakeFromNib {
    [super awakeFromNib];
    _userImageView.layer.masksToBounds = YES;
    _userImageView.layer.cornerRadius = _userImageView.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
