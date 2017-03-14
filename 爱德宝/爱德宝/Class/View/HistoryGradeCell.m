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


-(void)setModel:(HistorygradeModel *)model {
    _model = model;
    _DateLab.text = [NSString stringWithFormat:@"%@", _model.sportDate];
    _kCarLab.text = [NSString stringWithFormat:@"%.2f/Kcar", [_model.allCor floatValue]];
    _timeLab.text = [NSString stringWithFormat:@"%.2f/h", [_model.sportTime floatValue]];
    _disLab.text = [NSString stringWithFormat:@"%.f/Km", [_model.allDis floatValue]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
