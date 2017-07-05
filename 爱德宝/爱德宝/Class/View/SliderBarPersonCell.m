//
//  SliderBarPersonCell.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "SliderBarPersonCell.h"
#import "UIImageView+WebCache.h"
@implementation SliderBarPersonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}

- (void)setValue {
    if ([XIU_Login isLogin]) {
        _PersonName.text = [[[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict] objectForKey:@"username"];
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:user_ranking]) {
             _PersonNumber.text = @"暂无排名";
        }else {
            _PersonNumber.text =[NSString stringWithFormat:@"总排名:%@名",[[NSUserDefaults standardUserDefaults] objectForKey:user_ranking]];
        }
        NSString *str =[NSString stringWithFormat:@"%.2fKm",[[XIU_Login curLoginUser].allDis floatValue]];
          _PersondistanceNumber.text = str;
        
        if ([UIImage imageNamed:iconPath]) {
            _PersonImageView.image = [UIImage imageNamed:iconPath];
            //            _PersonImageView.image = [UIImage imageWithContentsOfFile:iconPath];
        }else{
            [_PersonImageView sd_setImageWithURL:[NSURL URLWithString:[XIU_Login curLoginUser].userImg] placeholderImage:[UIImage imageNamed:@"头像"]];
        }

    }else {
        _PersonNumber.text = @"总排名：未知";
        _PersonName.text = @"未登录，请点击登陆";
        _PersondistanceNumber.text = @"总里程";
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    

    if ([[XIU_Login curLoginUser] userImg].length > 0) {
       
         [_PersonImageView sd_setImageWithURL:[NSURL URLWithString:[XIU_Login curLoginUser].userImg] placeholderImage:[UIImage imageNamed:@"头像"]];
    }else {
        _PersonImageView.image = [UIImage imageNamed:@"头像"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
