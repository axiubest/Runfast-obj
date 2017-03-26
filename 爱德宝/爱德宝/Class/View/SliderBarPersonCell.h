//
//  SliderBarPersonCell.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const SliderBarPersonIdentifier = @"SliderBarPersonCell";
@interface SliderBarPersonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *PersonImageView;

@property (weak, nonatomic) IBOutlet UILabel *PersonName;

@property (weak, nonatomic) IBOutlet UILabel *PersonNumber;

@property (weak, nonatomic) IBOutlet UILabel *PersondistanceNumber;

- (void)setValue;
@end
