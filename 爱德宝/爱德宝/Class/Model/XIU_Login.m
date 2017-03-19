//
//  XIU_Login.m
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/11.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_Login.h"
#import "MJExtension.h"
#import "NSDictionary+Common.h"

#define kLoginStatus @"login_status"
#define kLoginUserDict @"user_dict"


static XIU_User *curLoginUser;
@implementation XIU_Login

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.phone = @"";
        self.password = @"";
    }
    return self;
}

- (NSString *)toPath {
    return @"http://112.74.28.179:8080/adbs/userbeancontrol/loginByPhone?";
}

+ (NSString *)toPath {
    return @"http://112.74.28.179:8080/adbs/userbeancontrol/loginByPhone?";
}
#pragma mark 相应key-Value在此修改---密码加密调用[self.password sha1Str]
- (NSDictionary *)params {
    NSMutableDictionary *param = @{@"userphone": self.phone,
                                    @"userpass" : self.password,}.mutableCopy;
    return param;
}

+(BOOL)isLogin {
  NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
    return loginStatus.boolValue;
 
}

+ (void)doLogin:(NSDictionary *)loginData {
    if (loginData) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithBool:YES] forKey:kLoginStatus];
        
     NSDictionary *tmpDic = [loginData deleteAllNullValue:loginData];
        
        [defaults setObject:tmpDic forKey:kLoginUserDict];

        
//        curLoginUser = [XIU_User mj_objectWithKeyValues:loginData];
        XIU_User *user = [[XIU_User alloc] init];
        
        user.username = [loginData objectForKey:@"username"];
         user.usersex = [loginData objectForKey:@"usersex"];
         user.birth = [loginData objectForKey:@"birth"];
         user.userImg = [loginData objectForKey:@"userImg"];
         user.userhobby = [loginData objectForKey:@"userhobby"];
         user.userphone = [loginData objectForKey:@"userphone"];
         user.userpass = [loginData objectForKey:@"userpass"];
         user.userfrom = [loginData objectForKey:@"userfrom"];
         user.channelid = [loginData objectForKey:@"channelid"];
         user.weight = [loginData objectForKey:@"weight"];
         user.height = [loginData objectForKey:@"height"];
         user.allDis = [loginData objectForKey:@"allDis"];
         user.allCir = [loginData objectForKey:@"allCir"];
         user.allTime = [loginData objectForKey:@"allTime"];
         user.userId = [loginData objectForKey:@"id"];
        curLoginUser = user;
        [defaults synchronize];

#pragma mark 在此还应进行所有登录过的用户信息保存
    }else {
        [XIU_Login doLogOut];
    }
}



+ (XIU_User *)curLoginUser {
    if (!curLoginUser) {
        NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (loginData) {
            XIU_User *user = [[XIU_User alloc] init];
            user.username = [loginData objectForKey:@"username"];
            user.usersex = [loginData objectForKey:@"usersex"];
            user.birth = [loginData objectForKey:@"birth"];
            user.userImg = [loginData objectForKey:@"userImg"];
            user.userhobby = [loginData objectForKey:@"userhobby"];
            user.userphone = [loginData objectForKey:@"userphone"];
            user.userpass = [loginData objectForKey:@"userpass"];
            user.userfrom = [loginData objectForKey:@"userfrom"];
            user.channelid = [loginData objectForKey:@"channelid"];
            user.weight = [loginData objectForKey:@"weight"];
            user.height = [loginData objectForKey:@"height"];
            user.allDis = [loginData objectForKey:@"allDis"];
            user.allCir = [loginData objectForKey:@"allCir"];
            user.allTime = [loginData objectForKey:@"allTime"];
            user.userId = [loginData objectForKey:@"id"];
            curLoginUser = user;
            return curLoginUser;

        }
        curLoginUser = nil;
    }
    return curLoginUser;

}

+(void)doLogOut {
    if ([self isLogin]) {
        
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:kLoginStatus];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kLoginUserDict];

        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    推送注销
    //缓存删除
}
@end
