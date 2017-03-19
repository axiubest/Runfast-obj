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
    if ([XIU_Login isLogin]) {
        _PersonName.text = [XIU_Login curLoginUser].username;
        _PersonNumber.text =[NSString stringWithFormat:@"总排名:%@", [XIU_Login curLoginUser].username];
        _PersondistanceNumber.text = [NSString stringWithFormat:@"总里程:%@", [XIU_Login curLoginUser].allDis];
        
        [_PersonImageView sd_setImageWithURL:[NSURL URLWithString:[XIU_Login curLoginUser].userImg] placeholderImage:[UIImage imageNamed:@"头像"]];
    }else {
        _PersonNumber.text = @"总排名：未知";
        _PersonName.text = @"未登录，请点击登陆";
        _PersondistanceNumber.text = @"总里程";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
