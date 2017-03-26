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

    }else {
        [XIU_Login doLogOut];
    }
}



+ (XIU_User *)curLoginUser {
    if (!curLoginUser) {
        NSDictionary *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserDict];
        
        XIU_User *user = [[XIU_User alloc] init];

        [[NSUserDefaults standardUserDefaults] synchronize];
        if (loginData) {
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
            user.identified = [loginData objectForKey:@"identified"];
            curLoginUser = user;
            NSLog(@"%@" ,curLoginUser);

            return curLoginUser;
            
        }
    }
    return curLoginUser;

}


+(void)saveNewUserInfoWithUser:(XIU_User *)user {
    
  NSDictionary *dic = @{@"id":user.userId,
                        @"usersex":user.usersex,
                        @"allCir":user.allCir,
                        @"allDis":user.allDis,
                        @"channelid":user.channelid,
                        @"birth":user.birth ? user.birth : @"",
                        @"weight":user.weight,
                        @"userpass":user.userpass,
                        @"username":user.username,
                        @"userphone":user.userphone,
                        @"height":user.height,
                        @"userImg":user.userImg,
                        @"userhobby":user.userhobby,
                        @"userfrom":user.userfrom,
                        @"allTime":user.allTime,
                        @"identified":user.identified ? user.identified : @""};
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kLoginUserDict];
   }

+(void)doLogOut {
    if ([self isLogin]) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginStatus];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:kLoginUserDict];

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:user_ranking];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    推送注销
    //缓存删除
}
@end
