//
//  MainPageViewController.m
//  LeftSlide
//
//  Created by huangzhenyu on 15/6/18.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "MainPageViewController.h"
#import "AppDelegate.h"
#import "HistoryViewController.h"
#import "ModeSelectionVC.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";

    
    UIImageView *image = [[UIImageView alloc] initWithFrame:FULLRECT];
    image.image = [UIImage imageNamed:BackImageName];
    [self.view addSubview:image];

    [self createNavgationButtonWithImageNmae:@"我的" title:nil target:self action:@selector(openOrCloseLeftList) type:UINavigationItem_Type_LeftItem];
    
        [self createNavgationButtonWithImageNmae:nil title:@"连接" target:self action:@selector(clickedBLE) type:UINavigationItem_Type_RightItem];
    
    [self createUI];
    
}

- (void)clickedBLE {
    
}

- (void)createUI {
    UIButton *quickBt = [[UIButton alloc] init];
    [quickBt setTitle:@"快速开始" forState:UIControlStateNormal];
    [quickBt setTintColor:[UIColor whiteColor]];
    [quickBt addTarget:self action:@selector(clickedQuickStartBtn) forControlEvents:UIControlEventTouchUpInside];
    quickBt.backgroundColor = [UIColor colorWithHexString:@"28A65E"];

    quickBt.layer.masksToBounds = YES;
    quickBt.layer.cornerRadius = 20;
    
    [self.view addSubview:quickBt];
    [quickBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.bottom.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@45);
        
    }];
    
    CreateButton *historyBtn = [[CreateButton alloc] initWithFrame:CGRectMake(40, KHEIGHT - 200, 100, 100) Title:@"历史记录" ImageName:@"历史记录"];
    [historyBtn bk_whenTapped:^{

            HistoryViewController *vc = [[HistoryViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:historyBtn];
    


    
    CreateButton *styleSelectBtn  = [[CreateButton alloc] initWithFrame:CGRectMake(KWIDTH - 40 - 100 , historyBtn.y, historyBtn.width, historyBtn.height) Title:@"模式选择" ImageName:@"控制属性设置"];
    [styleSelectBtn bk_whenTapped:^{
        ModeSelectionVC *select = [[ModeSelectionVC alloc] init];
        [self.navigationController pushViewController:select animated:YES];
    }];
    [self.view addSubview:styleSelectBtn];
}

- (void)clickedQuickStartBtn {
    
}

- (void) openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}



@end


@implementation CreateButton

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageName:(NSString*)ImageName {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:ImageName];
        [self addSubview:image];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor  =[UIColor lightGrayColor];
        lab.text = title;
        lab.textAlignment = 1;
        [self addSubview:lab];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image.mas_bottom).with.offset(15);
            make.centerX.equalTo(self.mas_centerX);
        }];
    }
    return self;
    
}
@end

