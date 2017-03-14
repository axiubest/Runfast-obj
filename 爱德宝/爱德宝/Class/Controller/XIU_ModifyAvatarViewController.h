//
//  XIU_ModifyAvatarViewController.h
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/16.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//


typedef NS_ENUM(NSInteger, UserInformationItemStyle) {
//    UserInformationItemStyle_Header,
    UserInformationItemStyle_userName,
    UserInformationItemStyle_sex,
    UserInformationItemStyle_birthday,
    UserInformationItemStyle_hobby
};


#import "XIU_BaseViewController.h"
@interface XIU_ModifyAvatarViewController : XIU_BaseViewController<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end
