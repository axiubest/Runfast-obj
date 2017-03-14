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
        id requestData = [[data objectForKey:@"data"] objectForKey:@"user"];
        
        if ([[data objectForKey:@"data"] objectForKey:@"ranking"]) {
                 [[NSUserDefaults standardUserDefaults]setObject:[data valueForKey:@"ranking"] forKey:@"user_ranking"]; ;
        }
   
        
        if (requestData) {
            [XIU_Login doLogin:requestData];
            XIU_User *user = [XIU_User mj_objectWithKeyValues:requestData];

            block(user, nil);

        }else {
            block(nil,error);
        }

    }];
}

//http://localhost:8080/userbeancontrol/registuserbeaninfo?userphone=123456789&userpass=555

- (void)request_ResignWithPhoneNumber:(NSString *)phone Psw:(NSString *)psw andBlock:(void (^)(id data, NSError *error))block {
    [[XIU_NetAPIClient sharedJsonClient] requestJsonDataWithPath:@"http://112.74.28.179:8080/adbs/registuserbeaninfo?" withParams:@{@"userphone" : phone, @"userpass" :psw} withMethodType:Get andBlock:^(id data, NSError *error) {
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
@end
