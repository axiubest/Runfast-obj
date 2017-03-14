//
//  XIU_NetAPIManager.h
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/13.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XIU_NetAPIManager : NSObject
+ (instancetype)sharedManager;



#pragma mark----login
- (void)request_Login_WithPath:(NSString *)path Params:(id)params andBlock:(void (^)(id data, NSError *error))block;

- (void)request_ResignWithPhoneNumber:(NSString *)phone Psw:(NSString *)psw andBlock:(void (^)(id data, NSError *error))block;
#pragma mark----worldGrade
- (void)request_WorldGrade_WithPath:(NSString *)path Params:(id)params andBlock:(void (^)(id data, NSError *error))block;

#pragma mark----History
- (void)request_HistoryGradeBlock:(void (^)(id data, NSError *error))block;
@end
