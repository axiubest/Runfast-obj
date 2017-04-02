//
//  XIU_NetAPIManager.m
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/13.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_NetAPIManager.h"
#import "XIU_NetAPIClient.h"
#import "MJExtension.h"

#import "WorldGradeModel.h"
#import "HistorygradeModel.h"
#import "QuestionModel.h"
@implementation XIU_NetAPIManager

+ (instancetype)sharedManager {
    static XIU_NetAPIManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}



- (void)request_Login_WithPath:(NSString *)path Params:(id)params andBlock:(void (^)(id data, NSError *error))block {
    
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        
        id loginData = [[data objectForKey:@"data"] objectForKey:@"user"];
        
        if ([[data objectForKey:@"data"] objectForKey:@"ranking"]) {
                 [[NSUserDefaults standardUserDefaults]setObject:[[data objectForKey:@"data"] objectForKey:@"ranking"] forKey:user_ranking];
            
        }
   
        
        if (loginData) {
            [XIU_Login doLogin:loginData];
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
            user.identified = [loginData objectForKey:@"identified"];
            block(user, nil);

        }else {
            block(nil,error);
        }

    }];
}

//http://localhost:8080/userbeancontrol/registuserbeaninfo?userphone=123456789&userpass=555

- (void)request_ResignWithPhoneNumber:(NSString *)phone Psw:(NSString *)psw andBlock:(void (^)(id data, NSError *error))block {
    
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:@"http://112.74.28.179:8080/adbs/userbeancontrol/registuserbeaninfo?" withParams:@{@"userphone" : phone, @"userpass" :psw, @"identified" : MAINUUID} withMethodType:Get andBlock:^(id data, NSError *error) {
        
        NSDictionary *obj = [[data objectForKey:@"data"] objectForKey:@"user"];
        if (obj) {
            block(obj, nil);
        }else {
           block(nil,error);
        }
    }];
}


- (void)request_WorldGrade_WithPath:(NSString *)path Params:(id)params andBlock:(void (^)(id data, NSError *error))block {
    
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:path withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        NSArray *requestData = [[data objectForKey:@"data"] objectForKey:@"collectionlist"];
        
        if (requestData) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *obj in requestData) {
                WorldGradeModel *model = [[WorldGradeModel alloc] init];
                model.ids = [obj objectForKey:@"id"];
                model.allCir = [obj objectForKey:@"allCir"];
                model.userImg = [obj objectForKey:@"userImg"];
                model.allDis = [obj objectForKey:@"allTime"];
                model.username = [obj objectForKey:@"username"];
                [arr addObject:model];
            }
            block(arr, nil);
            
        }else {
            block(nil,error);
        }
        
    }];

}


- (void)request_HistoryGradeBlock:(void (^)(id data, NSError *error))block {
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:@"http://112.74.28.179:8080/adbs/sporthistory/getsporthitorylist?" withParams:@{@"userId" : @"2"} withMethodType:Get andBlock:^(id data, NSError *error) {
        NSArray *requestData = [[data objectForKey:@"data"] objectForKey:@"sporthitorylist"];
        
        if (requestData) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *obj in requestData) {
                HistorygradeModel *model = [[HistorygradeModel alloc] init];
                model.ids = [obj objectForKey:@"id"];
                model.allCor = [obj objectForKey:@"allCor"];
                model.sportDate = [obj objectForKey:@"sportDate"];
                model.sportTime = [obj objectForKey:@"sportTime"];

                model.allDis = [obj objectForKey:@"alldis"];
                
                [arr addObject:model];
            }
            block(arr, nil);
            
        }else {
            block(nil,error);
        }
        
    }];
}



/**
 http://localhost:8080/sporthistory/addsporthistory?userId=2&sportTime=2555&alldis=15.5&allCor=16.45
 */
- (void)request_SaveSportGradeWithKm:(NSString *)km Time:(NSString *)time KCar:(NSString *)Kcar Block:(void (^)(id data, NSError *error))block {
    
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:@"http://112.74.28.179:8080/adbs/sporthistory/addsporthistory?" withParams:@{@"userId":[NSNumber numberWithInt:[[[XIU_Login curLoginUser] userId] intValue]], @"sportTime" : [NSNumber numberWithFloat:[time integerValue]], @"alldis" :[NSNumber numberWithFloat:[km floatValue]], @"allCor" : [NSNumber numberWithFloat:[Kcar floatValue]]} withMethodType:Get andBlock:^(id data, NSError *error) {
        
        NSLog(@"%@", data);
        if (data) {
          NSDictionary *obj = [[data objectForKey:@"data"] objectForKey:@"userBean"];
            NSDictionary* localSavr =  [[data objectForKey:@"data"] objectForKey:@"sportHistoryBean"];
//          CGFloat *f =  [[[NSUserDefaults standardUserDefaults] objectForKey:sportDis] floatValue];
          CGFloat f = [[[NSUserDefaults standardUserDefaults] objectForKey:sport_now_dis] floatValue];
            CGFloat now = [[localSavr objectForKey:@"alldis"] floatValue];
            CGFloat num = f + now;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.0f", num] forKey:sport_now_dis];
            
            [XIU_Login doLogin:obj];
                block(data, nil);
        }else {
            block(nil, error);
        }
        
    }];

}


- (void)request_UpdateUserInformationWithModel:(XIU_User *)user Block:(void (^)(id data, NSError *error))block {
    
    NSLog(@"%@", user);
//
//    
    
    
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:@"http://112.74.28.179:8080/adbs/userbeancontrol/updateuserbeaninfo?" withParams:@{@"id":user.userId,@"name":user.username,@"usersex":user.usersex,@"birth":user.birth ,@"userhobby":user.userhobby,@"userImg":user.userImg,@"weight":user.weight,@"height":user.height} withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            
            block(data, nil);
        }else {
            block(nil, error);
        }
    }];
}


- (void)request_QuestionWithPage:(int)page Block:(void (^)(id data, NSError *error))block {
    
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:[NSString stringWithFormat:@"http://112.74.28.179:8080/adbs/questionControl/getquestionlist?keyWord=&page=%d&size=8", page] withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *obj =  [[data objectForKey:@"data"]objectForKey:@"questionlist"];
            for (NSDictionary *dic in obj) {
                QuestionModel *m  =[[QuestionModel alloc] init];
              m.quesAnswer =  [dic objectForKey:@"quesAnswer"];
              m.quesTitle =  [dic objectForKey:@"quesTitle"];
            m.countUseful =  [dic objectForKey:@"countUseful"];
                
                            m.quesType =  [dic objectForKey:@"quesType"];
                [arr addObject:m];
            }
            block(arr, nil);
        } else {
            block(nil, error);
        }
        
    }];
}
@end
