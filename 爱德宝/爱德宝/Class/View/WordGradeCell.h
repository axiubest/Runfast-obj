//
//  WordGradeCell.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/9.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorldGradeModel.h"
@interface WordGradeCell : UITableViewCell



- (void)dataSource:(WorldGradeModel *)model count:(NSInteger)count;

@end
