//
//  WordGradeCell.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/9.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "WordGradeCell.h"
#import "UIImageView+WebCache.h"

@interface WordGradeCell ()

@property (weak, nonatomic) IBOutlet UILabel *gradeLab;

@property (weak, nonatomic) IBOutlet UIImageView *huangguanImageView;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userKmLab;
@end

@implementation WordGradeCell



- (void)dataSource:(WorldGradeModel *)model count:(NSInteger )count {
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg]];
    _userName.text = model.username;
    _userKmLab.text = [NSString stringWithFormat:@"%@", model.allDis];
    _gradeLab.text = [NSString stringWithFormat:@"%ld", count + 1];
    if (count < 3) {
        _huangguanImageView.image = [UIImage imageNamed:@"皇冠"];
        _gradeLab.textColor = [UIColor blackColor];
    }

}




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
