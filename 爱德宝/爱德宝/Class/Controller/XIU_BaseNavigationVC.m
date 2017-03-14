//
//  XIU_BaseNavigationVC.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_BaseNavigationVC.h"
static NSString *navgationBackgroundImageName = @"toumingbg";
@interface XIU_BaseNavigationVC ()

@end

@implementation XIU_BaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:navgationBackgroundImageName] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[self imageWithColor:[UIColor clearColor]]];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};

      

}



- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
