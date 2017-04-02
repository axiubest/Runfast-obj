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

#define vBackBarButtonItemName  @"backArrow.png"    //导航条返回默认图片名
#define arc_size KWIDTH
#define progressWidth 15

@interface MainPageViewController ()<CBPeripheralManagerDelegate,BTSmartSensorDelegate,ModeSelectionDelegate, BLEListTableViewDelegate>
{
    CGFloat speedNum;
    int slopeNum;
    NSString *BLEStr;
    
    NSString *calories; //ca
    
    NSString *time;     //t
    
    NSString *distance; //dis
    
    NSString * heart;   //h
    
    NSString *slope;    //s
    
    CGFloat NowDis;
    
}


@property (nonatomic, weak)CLDashboardProgressView *disProgressView;
@property (nonatomic, weak)CLDashboardProgressView *dayProgressView;
// 是否连接成功
@property (nonatomic, assign) BOOL isConnect;
@property (nonatomic, retain) NSMutableSet *peripheralViewControllerSet;
@property (nonatomic,strong) CBPeripheralManager * centralManager;
@property (nonatomic, strong) CBPeripheral *Peripheral;
@property (nonatomic,strong) NSTimer *timer;
@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;
@property (nonatomic, strong) NSString *tvRecv;
@property (nonatomic, strong) NSString *speed;

@property (nonatomic, weak) UILabel *allLabel;
@property (nonatomic, weak) UILabel *nowDayLabel;

@property (nonatomic,weak) UILabel *currentNum;

@end


@implementation MainPageViewController
@synthesize sensor;
@synthesize peripheralViewControllerArray;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NowDis = [[NSUserDefaults standardUserDefaults] objectForKey:sport_now_dis] ? [[[NSUserDefaults standardUserDefaults] objectForKey:sport_now_dis] floatValue] : 0;
    
    

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
    
    _allLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:sportDis] ? [NSString stringWithFormat:@"%@Km", [[NSUserDefaults standardUserDefaults] objectForKey:sportDis]] : @"请设置目标" ;
    self.nowDayLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:sportDay] ?[NSString stringWithFormat:@"%@天", [[NSUserDefaults standardUserDefaults] objectForKey:sportDay]]  :  @"0天";
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:sportStartDate]){
        self.currentNum.text = @"第0天";
        return;
    }
    NSDate *startDate = [[NSUserDefaults standardUserDefaults] objectForKey:sportStartDate];
    
    NSDate *dateFor = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat  =@"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:dateFor];
    fmt.dateFormat  =@"yyyy-MM-dd";
    NSDate *create = [fmt dateFromString:dateStr];
    
    NSTimeInterval delta = [create timeIntervalSinceDate:startDate];
    NSInteger num = delta/86400+1;
    NSInteger totalNum = [[[NSUserDefaults standardUserDefaults] objectForKey:sportDay] integerValue];
    self.currentNum.text = [NSString stringWithFormat:@"第%ld天",num<totalNum?num:totalNum];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"主界面";
    
    NSLog(@"%@", kPathDocument);
    NSLog(@"%@", [XIU_Login curLoginUser].userImg);
    
    _tvRecv = [NSString string];
    _speed = [NSString string];
    UIImageView *image = [[UIImageView alloc] initWithFrame:FULLRECT];
    image.image = [UIImage imageNamed:BackImageName];
    [self.view addSubview:image];
    [self setBackImageView:self.view];

    [self createNavgationButtonWithImageNmae:@"我的" title:nil target:self action:@selector(openOrCloseLeftList) type:UINavigationItem_Type_LeftItem];
    
        [self createNavgationButtonWithImageNmae:nil title:@"连接" target:self action:@selector(clickedBLE) type:UINavigationItem_Type_RightItem];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 60, 60)];
    label.center = CGPointMake(KWIDTH/2 - 70, KHEIGHT/2 + 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    self.currentNum = label;
    
    
    [self createProgressView];
    [self createUI];

    [self createBLE];
}


- (void)createBLE {
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    self.centralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(0, 0)];
}

#pragma mark draw


- (void)createProgressView {
    
    NSInteger disNum = [[NSUserDefaults standardUserDefaults] objectForKey:sportDis] ?  [[[NSUserDefaults standardUserDefaults] objectForKey:sportDis] integerValue] : 300;;
    
    NSInteger allDayNum =  [[NSUserDefaults standardUserDefaults] objectForKey:sportDay] ? [[[NSUserDefaults standardUserDefaults] objectForKey:sportDay] integerValue] : 7;

    
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
    disprogress.maxValue = disNum;    // 进度条最大数值
    disprogress.currentValue = NowDis; // 进度条当前数值
    
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
    progress.innerRadius = _disProgressView.innerRadius - 15;  // 内圈半径
    progress.beginAngle = 120;    // 起始角度
    progress.blockAngle = 8;   // 每个进度块的角度
    progress.gapAngle = 0;     // 两个进度块的间隙的角度
    progress.progressColor = [UIColor whiteColor]; // 进度条填充色
    progress.trackColor    = [UIColor darkGrayColor];   // 进度条痕迹填充色
    progress.outlineColor  = [UIColor grayColor];  // 进度条边框颜色
    progress.outlineWidth  = 0;                    // 进度条边框线宽
    
    progress.blockCount = 26;   // 进度块的数量
    progress.minValue = 0;      // 进度条最小数值
    progress.maxValue = allDayNum;    // 进度条最大数值
    progress.currentValue =  [self.currentNum.text floatValue]; // 进度条当前数值
    
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
    lab.text = [NSString stringWithFormat:@"%.f",NowDis];
    lab.center = CGPointMake(SV.center.x, SV.center.y - 40);
    [self.view addSubview:lab];
    
    UILabel *allLab = [[UILabel alloc] init];
    allLab.textColor  = [UIColor lightGrayColor];
    _allLabel = allLab;
    allLab.text = @"100km";
    [self.view addSubview:allLab];
    [allLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom);
        make.centerX.mas_equalTo(lab.mas_centerX);
    }];

    
}


-(UILabel *)nowDayLabel {
    if (!_nowDayLabel) {
        UILabel *nowDayLab = [[UILabel alloc] init];
        
        nowDayLab.textColor  = [UIColor lightGrayColor];
        nowDayLab.font = [UIFont systemFontOfSize:22 weight:1];
        nowDayLab.text = @"100km";
        _nowDayLabel = nowDayLab;
        [self.view addSubview:nowDayLab];
        [nowDayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_allLabel.mas_bottom).with.offset(10);
            make.centerX.mas_equalTo(_allLabel.mas_centerX);
        }];
    }
    return _nowDayLabel;
}

- (void)clickedBLE {
    if ([sensor activePeripheral]) {
        [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
        sensor.activePeripheral = nil;
    }if ([self.peripheralViewControllerArray count]) {
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
    }
    [sensor findBLKSoftPeripherals:5];

    
}

- (void)CoreBluetoothNotCorrectlyInitialized {
    [self HUDWithText:@"CoreBluetooth is not correctly initialized"];
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
    
    CreateButton *historyBtn = [[CreateButton alloc] initWithFrame:CGRectMake(40, KHEIGHT - 230, 100, 100) Title:@"历史记录" ImageName:@"历史记录"];
    [historyBtn bk_whenTapped:^{
        if ([XIU_Login isLogin]) {
            HistoryViewController *vc = [[HistoryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];

        }else {
            [self HUDWithText:@"您未登录请登陆"];
        }
             }];
    [self.view addSubview:historyBtn];
    


    
    CreateButton *styleSelectBtn  = [[CreateButton alloc] initWithFrame:CGRectMake(KWIDTH - 40 - 100 , historyBtn.y, historyBtn.width, historyBtn.height) Title:@"模式选择" ImageName:@"控制属性设置"];
    [styleSelectBtn bk_whenTapped:^{
        ModeSelectionVC *select = [[ModeSelectionVC alloc] init];
        select.MyDelegate = self;
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
    line2.frame = CGRectMake(20, historyBtn.y + historyBtn.height + 30, KWIDTH - 40, 1);
}

- (void)clickedQuickStartBtn {
    if (sensor.activePeripheral && sensor.activePeripheral != _Peripheral) {
        [self HUDWithText:@"无服务"];
        return;
    }
    else if ([self isConnect]) {
        BLEViewController *ble = [[BLEViewController alloc] init];
        ble.sensor = sensor;
        ble.isContent = self.isConnect;
        [self.navigationController pushViewController:ble animated:YES];
        return;
    }
    [self HUDWithText:@"蓝牙未连接"];

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



#pragma mark--delegate 搜索到蓝牙设备回调方法

#pragma mark select bluetooth method
- (void)chickedAlertMetohd {
    NSLog(@"ckicked btn of alert");
    
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


-(void) peripheralFound:(CBPeripheral *)peripheral
{
    if (!peripheral.name) {
        return;
    }
    
    _Peripheral = peripheral;
    [peripheralViewControllerArray addObject:sensor];
    BLEListTableViewController *coller = [[BLEListTableViewController alloc] init];
    coller.peripheralViewControllerArray = peripheralViewControllerArray;
    coller.Peripheral = peripheral;
    coller.MyDelegate = self;
    [self pushViewControllerWithCcontroller: coller];
    
}


-(void)setConnect
{
    
    self.isConnect = YES;
    
}


#pragma mark update data
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    if ([_tvRecv containsString:@"FF"]) {
             NSMutableDictionary *dic = [NSMutableDictionary dictionary];
             dic[@"main"] = _tvRecv;

        NSNotification * notice = [NSNotification notificationWithName:@"RunMainNotification" object:nil userInfo:dic];
        [[NSNotificationCenter defaultCenter]postNotification:notice];

        _tvRecv = @"";

        }
        
    
    else{
        _tvRecv =  [_tvRecv stringByAppendingString:value];
    }
//
}


-(void)setDisconnect
{
    self.isConnect = NO;
//    if ([self.myDelegate respondsToSelector:@selector(qmsRunViewControllerisStart:)]) {
//        [self.myDelegate qmsRunViewControllerisStart:NO];
//    }
    
}


//  蓝牙异常退出

-(void)abNormalConnect{
    self.isConnect = NO;
// 中断链接；
}



#pragma mark BLEListViewDelegate
- (void)FindPeripheral {
    [sensor.manager stopScan];
    
    if (sensor.activePeripheral && sensor.activePeripheral != _Peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = _Peripheral;
    self.isConnect = YES;
    [sensor connect:sensor.activePeripheral];
    [self HUDWithText:@"您已连接蓝牙，现在可以开始跑步了"];
}

#pragma mark model-Delegate
- (void)modelDelegate {
    
    [self clickedQuickStartBtn];
}















@end

@implementation CreateButton

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title ImageName:(NSString*)ImageName {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *image = [[UIImageView alloc] init];
        image.image = [UIImage imageNamed:ImageName];
        image.userInteractionEnabled = YES;
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

