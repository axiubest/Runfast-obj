//
//  XIU_LoginViewController.h
//  BASEPRODUCT
//  Created by XIUDeveloper on 2016/12/29.
//  Copyright © 2016年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XIU_LoginViewControllerDelegate <NSObject>
@required
- (void)poplogin;

@end

@interface XIU_LoginViewController : XIU_BaseViewController


@property (nonatomic, assign) id<XIU_LoginViewControllerDelegate> XIUDelegate;

@end
