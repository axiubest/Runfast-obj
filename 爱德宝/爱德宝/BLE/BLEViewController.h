//
//  BLEViewController.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/11.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
@interface BLEViewController : XIU_BaseViewController

@property (strong, nonatomic) SerialGATT *sensor;
//+(instancetype) shareInstance;
@property (nonatomic, assign) BOOL isContent;
@end
