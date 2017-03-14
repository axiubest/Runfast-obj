//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "SliderBarPersonCell.h"
#import "HistoryViewController.h"
#import "movingObjectViewController.h"
#import "WordGradeViewController.h"
#import "MoreViewController.h"
#import "XIU_LoginViewController.h"
#import "XIU_ModifyAvatarViewController.h"
@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource,XIU_LoginViewControllerDelegate>

@end

@implementation LeftSortsViewController


- (void)login {
    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    [tableview registerNib:[UINib nibWithNibName:@"SliderBarPersonCell" bundle:nil] forCellReuseIdentifier:SliderBarPersonIdentifier];
    
}


- (void)mytext:(NSNotification *)not {
    [self.tableview reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [XIU_Login isLogin] ? 6 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {

        SliderBarPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:SliderBarPersonIdentifier];
        
        return cell;
    }
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"世界排名";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"运动目标";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"历史记录";
    }else if (indexPath.row == 4) {
        cell.textLabel.text = @"更多设置";
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"退出";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    switch (indexPath.row) {
        case 0: {
            if ([XIU_Login isLogin]) {
                XIU_ModifyAvatarViewController *vcc = [[XIU_ModifyAvatarViewController alloc] init];
                [self pushViewControllerWithCcontroller:vcc];
            }else {
                XIU_LoginViewController *login = [[XIU_LoginViewController alloc] init];
                login.XIUDelegate = self;
                [self pushViewControllerWithCcontroller:login];
            }
        }
            
            break;
        case 1: {
            WordGradeViewController *vc = [[WordGradeViewController alloc] init];
            [self pushViewControllerWithCcontroller:vc];
        }
            
            break;
        case 2: {
            movingObjectViewController *vc = [[movingObjectViewController alloc] init];
            [self pushViewControllerWithCcontroller:vc];
            

        }
          
            break;
        case 3: {
            HistoryViewController *vc = [[HistoryViewController alloc] init];
            [self pushViewControllerWithCcontroller:vc];
        }
            
            break;
        
        case 4:{
            MoreViewController *vc = [[MoreViewController alloc] init];
             [self pushViewControllerWithCcontroller:vc];
        }
            
            break;
        case 5:{
            [XIU_Login doLogOut];
            [self HUDWithText:@"您已退出登录"];
            [self.tableview reloadData];
        }
            
            break;
        default:
            break;
    }

   
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ( indexPath.row == 0) {
        return 180;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
