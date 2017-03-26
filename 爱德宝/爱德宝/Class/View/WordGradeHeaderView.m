//
//  WordGradeHeaderView.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/9.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "WordGradeHeaderView.h"
#import "UIImageView+WebCache.h"
@interface WordGradeHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *perLab;

@property (weak, nonatomic) IBOutlet UILabel *gradeNumber;

@property (weak, nonatomic) IBOutlet UILabel *distanceLab;
@end

@implementation WordGradeHeaderView

- (void)setvalue {
    _perLab.text = [[XIU_Login curLoginUser] username];
    _gradeNumber.text =[NSString stringWithFormat:@"第%@名", [[NSUserDefaults standardUserDefaults] objectForKey:user_ranking] ] ;
    _distanceLab.text =[NSString stringWithFormat:@"%@Km",[[XIU_Login curLoginUser] allDis]] ;
    

    if ([XIU_Login curLoginUser].userImg.length > 0) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[XIU_Login curLoginUser].userImg]];
    }else {
        _imageView.image = [UIImage imageNamed:@"头像"];

    }
    
//    if ([UIImage imageNamed:iconPath]) {
//        _imageView.image = [UIImage imageNamed:iconPath];
//    }else {
//        _imageView.image = [UIImage imageNamed:@"头像"];
//
//    }

}
@end
