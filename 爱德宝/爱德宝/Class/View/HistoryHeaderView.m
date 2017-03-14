//
//  HistoryHeaderView.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/10.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "HistoryHeaderView.h"

@interface HistoryHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *Kcal;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@end

@implementation HistoryHeaderView

-(void)setKcal:(UILabel *)Kcal {
    _Kcal = Kcal;
    _Kcal.text =[NSString stringWithFormat:@"%@Kcal",[XIU_Login curLoginUser].allCir];
}

-(void)setTime:(UILabel *)time {
    _time = time;
    _time.text = [NSString stringWithFormat:@"%@", [XIU_Login curLoginUser].allTime];
}

-(void)setDistance:(UILabel *)distance {
    _distance = distance;
    _distance.text = [NSString stringWithFormat:@"%@Km", [XIU_Login curLoginUser].allDis];
}

@end
