//
//  XIU_BaseViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_BaseViewController.h"

@interface XIU_BaseViewController ()

@end

@implementation XIU_BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView *imageview = [[UIImageView alloc] initWithFrame:FULLRECT];
//    imageview.image = [UIImage imageNamed:BackImageName];
    
//    [self.view addSubview:imageview];
    

}

- (void)setBackImageView:(UIView *)view {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    img.frame = view.frame;
    [view addSubview:img];
}

- (void)pushViewControllerWithCcontroller:(id)controller {
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    [tempAppDelegate.mainNavigationController pushViewController:controller animated:NO];
}

- (void)HUDWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.5];

}

- (BOOL)isLogin {
  return   [XIU_Login isLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showEmptyDataSetViewWithTitle:(NSDictionary *)emptyDictionary {
    
}


- (void)createNavgationButtonWithImageNmae:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action type:(UINavigationItem_Type)navigationItem_Type {
    if (title == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0, 0, 25, 25);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *Item = [[UIBarButtonItem alloc]initWithCustomView:button];
        if (navigationItem_Type == UINavigationItem_Type_LeftItem) {
            self.navigationItem.leftBarButtonItem = Item;
        }else if (navigationItem_Type == UINavigationItem_Type_RightItem) {
            self.navigationItem.rightBarButtonItem = Item;
        }
    }else if (imageName == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 40, 25);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *Item = [[UIBarButtonItem alloc]initWithCustomView:button];
        if (navigationItem_Type == UINavigationItem_Type_LeftItem) {
            self.navigationItem.leftBarButtonItem = Item;
        }else if (navigationItem_Type == UINavigationItem_Type_RightItem) {
            self.navigationItem.rightBarButtonItem = Item;
        }
    }else {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-5, -5, 30, 30)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(backView.x, backView.y, 25, 25);
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:button];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:10.f];
        label.tag = 888;
        label.textAlignment = 1;
        label.textColor = [UIColor blackColor];
        label.text = title;
        [backView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).with.offset(0);
            
            make.centerX.equalTo(button.mas_centerX);
        }];
        
        UIBarButtonItem *Item = [[UIBarButtonItem alloc]initWithCustomView:backView];
        if (navigationItem_Type == UINavigationItem_Type_LeftItem) {
            self.navigationItem.leftBarButtonItem = Item;
        }else if (navigationItem_Type == UINavigationItem_Type_RightItem) {
            self.navigationItem.rightBarButtonItem = Item;
        }
        
        
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
