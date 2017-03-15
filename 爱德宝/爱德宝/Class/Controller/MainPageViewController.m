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
#import "CLDashboardProgressView.h"
#import "BLEViewController.h"
#import "BLEListTableViewController.h"
#import "SerialGATT.h"
#import "QMS_QMSRunViewController.h"
#import "BLEDeviceViewController.h"
#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
#define arc_size KWIDTH
#define progressWidth 15

@interface MainPageViewController ()
{
}
@property (nonatomic, weak)CLDashboardProgressView *disProgressView;
@property (nonatomic, weak)CLDashboardProgressView *dayProgressView;

@property (nonatomic, retain) NSMutableSet *peripheralViewControllerSet;
@property (nonatomic,strong) CBPeripheralManager * centralManager;

@end


@implementation MainPageViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";

    UIImageView *image = [[UIImageView alloc] initWithFrame:FULLRECT];
    image.image = [UIImage imageNamed:BackImageName];
    [self.view addSubview:image];
    [self setBackImageView:self.view];

    [self createNavgationButtonWithImageNmae:@"我的" title:nil target:self action:@selector(openOrCloseLeftList) type:UINavigationItem_Type_LeftItem];
    
        [self createNavgationButtonWithImageNmae:nil title:@"连接" target:self action:@selector(clickedBLE) type:UINavigationItem_Type_RightItem];
    
    [self createUI];
    
    [self createProgressView];
}


#pragma mark draw


- (void)createProgressView {
    
    CLDashboardProgressView *disprogress = [[CLDashboardProgressView alloc] initWithFrame:CGRectMake(0, 0, arc_size, arc_size)];
    disprogress.backgroundColor = [UIColor whiteColor];
    disprogress.outerRadius = 160; // 外圈半径
    disprogress.innerRadius = 140;  // 内圈半径
    disprogress.beginAngle = 140;    // 起始角度
    disprogress.blockAngle = 8;   // 每个进度块的角度
    disprogress.gapAngle = 0;     // 两个进度块的间隙的角度
    disprogress.progressColor = [UIColor greenColor]; // 进度条填充色
    disprogress.trackColor    = [UIColor darkGrayColor];   // 进度条痕迹填充色
    disprogress.outlineColor  = [UIColor grayColor];  // 进度条边框颜色
    disprogress.outlineWidth  = 0.5;                    // 进度条边框线宽
    
    disprogress.blockCount = 26;   // 进度块的数量
    disprogress.minValue = 0;      // 进度条最小数值
    disprogress.maxValue = 100;    // 进度条最大数值
    disprogress.currentValue = 10; // 进度条当前数值
    
    disprogress.showShadow = NO;  // 是否显示阴影
    disprogress.shadowOuterRadius = 85; // 阴影外圈半径
    disprogress.shadowInnerRadius = 10; // 阴影内圈半径
    disprogress.shadowFillColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];   // 阴影颜色
    
    disprogress.autoAdjustAngle = YES;  // 自动调整角度
    disprogress.center = self.view.center;
    disprogress.backgroundColor = [UIColor clearColor];
    _disProgressView = disprogress;
    [self.view addSubview:_disProgressView];
    
    
    
    
    CLDashboardProgressView *progress = [[CLDashboardProgressView alloc] initWithFrame:CGRectMake(0, 0, arc_size, arc_size)];
    progress.backgroundColor = [UIColor whiteColor];
    progress.outerRadius = _disProgressView.outerRadius - 30; // 外圈半径
    progress.innerRadius = _disProgressView.innerRadius - 20;  // 内圈半径
    progress.beginAngle = 140;    // 起始角度
    progress.blockAngle = 8;   // 每个进度块的角度
    progress.gapAngle = 0;     // 两个进度块的间隙的角度
    progress.progressColor = [UIColor whiteColor]; // 进度条填充色
    progress.trackColor    = [UIColor darkGrayColor];   // 进度条痕迹填充色
    progress.outlineColor  = [UIColor grayColor];  // 进度条边框颜色
    progress.outlineWidth  = 0;                    // 进度条边框线宽
    
    progress.blockCount = 26;   // 进度块的数量
    progress.minValue = 0;      // 进度条最小数值
    progress.maxValue = 100;    // 进度条最大数值
    progress.currentValue = 10; // 进度条当前数值
    
    progress.showShadow = NO;  // 是否显示阴影
    progress.shadowOuterRadius = 85; // 阴影外圈半径
    progress.shadowInnerRadius = 10; // 阴影内圈半径
    progress.shadowFillColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];   // 阴影颜色
    
    progress.autoAdjustAngle = YES;  // 自动调整角度
    progress.center = self.view.center;
    progress.backgroundColor = [UIColor clearColor];
    _dayProgressView = progress;
    [self.view addSubview:_dayProgressView];
    
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, 50)];
    lab.font = [UIFont systemFontOfSize:50 weight:2];
    lab.textAlignment = 1;
    lab.textColor = [UIColor whiteColor];
    lab.text = [NSString stringWithFormat:@"%.f",_disProgressView.currentValue];
    lab.center = CGPointMake(SV.center.x, SV.center.y - 40);
    [self.view addSubview:lab];
    
    UILabel *allLab = [[UILabel alloc] init];
    allLab.textColor  = [UIColor lightGrayColor];
    allLab.text = @"100km";
    [self.view addSubview:allLab];
    [allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.centerX.mas_equalTo(lab.mas_centerX);
    }];
    
    UILabel *nowDayLab = [[UILabel alloc] init];
    nowDayLab.textColor  = [UIColor lightGrayColor];
    nowDayLab.font = [UIFont systemFontOfSize:22 weight:1];
    nowDayLab.text = @"100km";
    [self.view addSubview:nowDayLab];
    [nowDayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allLab.mas_bottom).with.offset(10);
        make.centerX.mas_equalTo(allLab.mas_centerX);
    }];

    
}




- (void)clickedBLE {
    
    
    QMS_QMSRunViewController *v = [[QMS_QMSRunViewController alloc] init];

    [self.navigationController pushViewController:v animated:YES];
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
    
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(SV.mas_centerX);
        make.top.equalTo(historyBtn);
        make.bottom.equalTo(historyBtn);
        make.width.equalTo(@1);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:line2];
    line2.frame = CGRectMake(20, historyBtn.y + historyBtn.height + 10, KWIDTH - 40, 1);
}

- (void)clickedQuickStartBtn {
    BLEViewController *ble = [[BLEViewController alloc] init];
    [self.navigationController pushViewController:ble animated:YES];
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

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
    switch (peripheral.state) {
            //蓝牙开启且可用
        case CBPeripheralManagerStatePoweredOn:
            break;
        default:
            break;
    }
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

