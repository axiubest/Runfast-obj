//
//  XIU_BaseViewController.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UINavigationItem_Type) {
    UINavigationItem_Type_LeftItem,
    UINavigationItem_Type_RightItem
};

@interface XIU_BaseViewController : UIViewController

- (void)pushViewControllerWithCcontroller:(id)controller;
- (void)setBackImageView:(UIView *)view;

- (BOOL)isLogin;

- (void)createNavgationButtonWithImageNmae:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action type:(UINavigationItem_Type)navigationItem_Type;

- (void)showEmptyDataSetViewWithTitle:(NSDictionary *)emptyDictionary;

- (void)HUDWithText:(NSString *)text;

@end
