//
//  SliderTableViewCell.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/10.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "SliderTableViewCell.h"

@implementation SliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _SearchView.on = NO;
    [_SearchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}


- (void)switchAction:(UISwitch *)s {
    if (s.on) {
        [[NSUserDefaults standardUserDefaults] setObject:@"screen_light_on" forKey:@"screen_light"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"screen_light_down" forKey:@"screen_light"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
