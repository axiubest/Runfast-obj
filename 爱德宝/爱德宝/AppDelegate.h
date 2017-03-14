//
//  AppDelegate.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/7.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "XIU_BaseNavigationVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;

@property (strong, nonatomic) XIU_BaseNavigationVC *mainNavigationController;
@end

