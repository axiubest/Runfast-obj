//
//  ModeSelectionVC.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_BaseViewController.h"

@protocol ModeSelectionDelegate <NSObject>

- (void)modelDelegate;

@end


@interface ModeSelectionVC : UIViewController

@property (nonatomic, assign)id<ModeSelectionDelegate> MyDelegate;

@end
