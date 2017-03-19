//
//  XIU_User.m
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/12.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_User.h"

@implementation XIU_User


//*userName, *userImage, *userPass, *userPhone, *userEmail, *userSex, *userBirth, *userIntru, *channelId, *hobby;

-(id)copyWithZone:(NSZone*)zone {
    XIU_User *user = [[[self class] allocWithZone:zone] init];
    user.username = [_username copy];
    user.usersex = [_usersex copy];
    user.birth = [_birth copy];
    user.weight = [_weight copy];
    user.height = [_height copy];
    user.userImg = [_userImg copy];
    user.userphone = [_userphone copy];
    user.userpass = [_userpass copy];
    user.userfrom = [_userfrom copy];
    user.channelid = [_channelid copy];
    user.allDis = [_allDis copy];
    user.allCir = [_allCir copy];
    user.allTime = [_allTime copy];
    user.userhobby = [_userhobby copy];
    user.userId = [_userId copy];

    return user;
}


//choose XIU_User safe;
- (NSString *)description {
    return @"0x0";
}


- (NSString *)job_str{
    if (_userhobby && _userhobby.length > 0) {
        return _userhobby;
    }else{
        return @"未填写";
    }
}



@end
