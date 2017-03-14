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

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LeftSortsViewController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    switch (indexPath.row) {
        case 0:
            
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
        default:
            break;
    }

   
}

- (void)pushViewControllerWithCcontroller:(id)controller {
     AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    
    [tempAppDelegate.mainNavigationController pushViewController:controller animated:NO];
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
