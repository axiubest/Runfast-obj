//
//  XIU_ModifyAvatarViewController.m
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/16.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_ModifyAvatarViewController.h"

#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"

#import "XIU_MyCenterTitleValueMoreCell.h"
#import "XIU_MyCenterModifyAvatarCell.h"
#import "UserInfoDetailTagCell.h"
#import "XIU_SettingTextViewController.h"

#import "NSDate+Helper.h"
#import "NSDate+Common.h"
#import "UITableView+Common.h"
#import "HKFileTool.h"

#import "AFNetworking.h"
#import "QNUploadManager.h"
#import "HTTPHandier.h"
/**
 个人信息修改
 */
@interface XIU_ModifyAvatarViewController ()
{
    XIU_MyCenterModifyAvatarCell *UserHeaderIconcell;
    UIImage *tmpImage;
}
@property (strong, nonatomic) XIU_User *curUser;
@property (nonatomic, strong) UITableView *XIUTableView;

@end

#define kPaddingLeftWidth 15.0
@implementation XIU_ModifyAvatarViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackImageView:self.view];
    
    self.title = @"个人信息";
     self.curUser = [[XIU_User alloc] init];
    self.curUser = [XIU_Login curLoginUser];
    
    //    添加myTableView
    _XIUTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, KWIDTH, KHEIGHT) style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor clearColor];
        ;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        TableView_ResignClass(XIU_MyCenterTitleValueMoreCell, kCellIdentifier_TitleValueMore);
        TableView_ResignClass(XIU_MyCenterModifyAvatarCell, kCellIdentifier_XIU_MyCenterModifyAvatar);
        TableView_ResignClass(UserInfoDetailTagCell, kCellIdentifier_UserInfoDetailTagCell);
        
        [self.view addSubview:tableView];
        tableView;
    });
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UserHeaderIconcell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_XIU_MyCenterModifyAvatar forIndexPath:indexPath];
        UserHeaderIconcell.curUser = _curUser;
        [tableView addLineforPlainCell:UserHeaderIconcell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
        return UserHeaderIconcell;
    }else {
        
        

        XIU_MyCenterTitleValueMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TitleValueMore forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    NSLog(@"%@", self.curUser);
                    NSLog(@"%@", [XIU_Login curLoginUser]);
                    
                    [cell setTitleStr:@"昵称" valueStr:[XIU_Login curLoginUser].username];
                    break;
                case 1:
                    [cell setTitleStr:@"性别" valueStr:self.curUser.usersex];
                    
                    break;
                case 2:
                    [cell setTitleStr:@"生日" valueStr:self.curUser.birth];
                    break;
                case 3:
                    [cell setTitleStr:@"爱好" valueStr:self.curUser.userhobby];
                    break;
                default:
                    break;
            }
            
        }
        
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cellHeight = [XIU_MyCenterModifyAvatarCell cellHeight];
    }else {
        cellHeight = [XIU_MyCenterTitleValueMoreCell cellHeight];
    }
    return cellHeight;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 1)];
    [headerView setHeight:20.0];
    return headerView;
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XIU_WeakSelf(self);
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
        [actionSheet showInView:self.view];
        
    }else if (indexPath.section == 1)  {
        switch (indexPath.row) {
            case UserInformationItemStyle_userName: {
                XIU_SettingTextViewController *vc = [XIU_SettingTextViewController settingTextVCWithTitle:@"昵称" textValue:_curUser.username  doneBlock:^(NSString *textValue) {
                    weakself.curUser.username = textValue;
                    self.curUser.username = textValue;
                    [XIU_Login saveNewUserInfoWithUser:self.curUser];
                    [self request];
                    [weakself.XIUTableView reloadData];
                    //                    request
                }];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case UserInformationItemStyle_sex: {
                [ActionSheetStringPicker showPickerWithTitle:nil rows:@[@[@"男", @"女", @"未知"]] initialSelection:@[_curUser.usersex] doneBlock:^(ActionSheetStringPicker *picker, NSArray * selectedIndex, NSArray *selectedValue) {
                    
                    weakself.curUser.usersex = selectedValue.lastObject;
                    [XIU_Login saveNewUserInfoWithUser:self.curUser];
                    [self request];
                    [weakself.XIUTableView reloadData];
                    
                } cancelBlock:nil origin:self.view];
            }
                break;
            case UserInformationItemStyle_birthday: {
                NSDate *curDate = [NSDate dateFromString:_curUser.birth withFormat:@"yyyy-MM-dd"];
                if (!curDate) {
                    curDate = [NSDate dateFromString:@"1990-01-01" withFormat:@"yyyy-MM-dd"];
                }
                ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                    weakself.curUser.birth = [selectedDate string_yyyy_MM_dd];
                    
                    [XIU_Login saveNewUserInfoWithUser:self.curUser];
                     [self request];
                    [weakself.XIUTableView reloadData];
                    //                    request
                } cancelBlock:^(ActionSheetDatePicker *picker) {
                    
                } origin:self.view];
                picker.minimumDate = [[NSDate date] offsetYear:-120];
                picker.maximumDate = [NSDate date];
                [picker showActionSheetPicker];
                
            }
                break;
            case UserInformationItemStyle_hobby: {
                XIU_SettingTextViewController *vc = [XIU_SettingTextViewController settingTextVCWithTitle:@"爱好" textValue:_curUser.userhobby  doneBlock:^(NSString *textValue) {
                    weakself.curUser.userhobby = textValue;
                            [XIU_Login saveNewUserInfoWithUser:self.curUser];
                     [self request];
                    [weakself.XIUTableView reloadData];
                    //                    request
                }];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            default:
                break;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIActionSheetDelegate M
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    
    if (buttonIndex == 0) {
        //        拍照
        //        if (![Helper checkCameraAuthorizationStatus]) {
        //            return;
        //        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if (buttonIndex == 1){

        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];//进入照相界面
    
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage, *originalImage;
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
#warning --------------------------黄昆--------------------------------
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
            NSLog(@"%@",originalImage);
            
            UserHeaderIconcell.userIconView.image = originalImage;
        }else if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum){
            originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(originalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            UserHeaderIconcell.userIconView.image = originalImage;
            
        }
    }];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    tmpImage = image;
    if (error != NULL) {
        NSLog(@"保存失败");
    }else{
        NSLog(@"图片保存成功");
        
        [HKFileTool hk_removeFile:iconPath containSelf:YES complete:nil];
        NSData *iconData =  UIImageJPEGRepresentation(image, 1.0);
        [iconData writeToFile:iconPath atomically:YES];
        
        UserHeaderIconcell.userIconView.image = [UIImage imageNamed:iconPath];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"iconImage" object:nil];
        
        [self requestPic];
        
    }
}

- (void)requestPic {
    NSLog(@"%@", tmpImage);
    
    if (UIImagePNGRepresentation(tmpImage).length == 0) {
        self.curUser.userImg = @"";
        return;
    }else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:@"http://112.74.28.179:8080/Chislim/Travel_notes_Servlet?dowhat=getUpLoadToken" parameters:nil progress:nil success:
         ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"请求成功---%@---%@",(NSString *)responseObject,[responseObject class]);
             NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             
             //request of qiniu server
             QNUploadManager *upManager = [[QNUploadManager alloc] init];
             NSData *data = UIImagePNGRepresentation(tmpImage);
             
             [upManager putData:data key:nil token:str
                       complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                           
                           NSString *tmpStr = [NSString stringWithFormat:@"http://ofplk6att.bkt.clouddn.com/%@", resp[@"key"]];
                           NSLog(@"%@", tmpStr);
                           
                           self.curUser.userImg = [NSString stringWithFormat:@"%@", tmpStr];
                           [self request];
                           
                       } option:nil];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             NSLog(@"请求失败--%@",error);
         }];
        
    }

}

//- (void)requestServerOfChislim:(NSString *)picUrl {
//    [[NSUserDefaults standardUserDefaults] setObject:picUrl forKey:@"userImage"];
//    XIU_Login saveNewUserInfoWithUser:<#(XIU_User *)#>
//    NSString *path = [NSString stringWithFormat:@"%@UserServlet?dowhat=updateUserImg&userId=%@&imageUrl=%@", BASEURL,MAIN_USERID, picUrl];
//    NSString *u8 = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    
//    [HTTPHandier getDataByString:u8 WithBodyString:nil WithDataBlock:^(id responceObject) {
//        NSLog(@"发布成功");
//        
//        [self.XIUTableView reloadData];
//        
//    }];
//    
//}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    _XIUTableView.delegate = nil;
    _XIUTableView.dataSource = nil;
}

- (void)request {
    [[XIU_NetAPIManager sharedManager] request_UpdateUserInformationWithModel:self.curUser Block:^(id data, NSError *error) {
        if (data) {
            [self HUDWithText:@"保存成功"];
        }else {
            [self HUDWithText:@"保存失败"];
        }
    }];
}

@end
