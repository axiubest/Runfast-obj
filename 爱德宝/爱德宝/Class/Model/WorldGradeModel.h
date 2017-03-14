//
//  WorldGradeModel.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/13.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorldGradeModel : NSObject

//"allCir": 32.9,
//"userImg": "",
//"allDis": 31,
//"id": 2,
//"allTime": 5110,
//"username": ""

@property (nonatomic, strong) NSNumber *allCir, *allDis, *ids, *allTime;
@property (nonatomic, copy) NSString *userImg, *username;

@end
