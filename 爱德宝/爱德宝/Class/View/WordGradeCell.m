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
@property (weak, nonatomic) IBOutlet UILabel *userTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *userKmLab;
@property (weak, nonatomic) IBOutlet UILabel *userCarLab;
@end

@implementation WordGradeCell



- (void)dataSource:(WorldGradeModel *)model count:(NSInteger )count {
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.userImg]];
    if (model.username.length == 0) {
        model.username = @"用户";
        _userImageView.image = [UIImage imageNamed:@"头像"];
    }
    _userName.text = model.username;
    
    _userTimeLab.text = [NSString stringWithFormat:@"时间：%@min", model.allTime];
    NSString *strDis = [NSString stringWithFormat:@"%@",model.allDis ];
    _userKmLab.text = [NSString stringWithFormat:@"%.2f Km", [strDis floatValue]];
    
    NSString *strCar = [NSString stringWithFormat:@"%@",model.allCir ];
    _userCarLab.text = [NSString stringWithFormat:@"卡路里：%.0f Kcar", [strCar floatValue]];
    _gradeLab.text = [NSString stringWithFormat:@"%ld", count + 1];
    
            _gradeLab.textColor = [UIColor whiteColor];
    if ([_gradeLab.text integerValue] == 3) {
        
//        _huangguanImageView.image = [UIImage imageNamed:@"皇冠"];
//        _gradeLab.textColor = [UIColor blackColor];
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
