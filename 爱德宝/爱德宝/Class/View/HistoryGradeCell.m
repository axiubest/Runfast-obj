//
//  HistoryGradeCell.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/10.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "HistoryGradeCell.h"



@interface HistoryGradeCell ()

@property (weak, nonatomic) IBOutlet UILabel *DateLab;

@property (weak, nonatomic) IBOutlet UILabel *kCarLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *disLab;
@end

@implementation HistoryGradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
