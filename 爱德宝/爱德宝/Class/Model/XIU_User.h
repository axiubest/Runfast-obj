//
//  XIU_User.h
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/12.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XIU_User : NSObject
{
//    NSString * _userName, *_userPhone, *_userImage, *_userPass, *_userEmail, *_userSex, *_userBirth, *_userIntru, *_channelId, *_hobby;
}

@property (readwrite, nonatomic, strong)NSString *username, *usersex, *birth, *userImg, *userhobby, *userphone, *userpass, *userfrom, *channelid;

@property (readwrite, nonatomic, strong)NSNumber *weight, *height, *allDis, *allCir, *allTime;


@end
