//
//  AppDelegate.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/7.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPageViewController.h"
#import "LeftSortsViewController.h"
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self requestInfo];
    MainPageViewController *mainVC = [[MainPageViewController alloc] init];
    self.mainNavigationController = [[XIU_BaseNavigationVC alloc] initWithRootViewController:mainVC];
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
    self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    self.window.rootViewController = self.LeftSlideVC;
    
   
    return YES;
}

#pragma mark 信息更新
- (void)requestInfo {
    if ([XIU_Login isLogin]) {
        [[XIU_NetAPIManager sharedManager] request_Login_WithPath:[NSString stringWithFormat:@"%@loginByPhone?userphone=%@&userpass=%@",BASEURL, [XIU_Login curLoginUser].userphone, [XIU_Login curLoginUser].userpass] Params:nil andBlock:^(id data, NSError *error) {
            if (data) {
                NSLog(@"信息更新成功");
            }
        }];

    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
