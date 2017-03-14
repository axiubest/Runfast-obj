//
//  BLEViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/11.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "BLEViewController.h"
#import "CLDashboardProgressView.h"
#import "SerialGATT.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEViewController ()<BTSmartSensorDelegate,CBPeripheralManagerDelegate>
@property (weak, nonatomic) IBOutlet CLDashboardProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressBg;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSString *tvRecv;
@property (nonatomic, strong) NSString *speed;
@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;
@property (nonatomic,strong) CBPeripheralManager * centralManager;



@end

@implementation BLEViewController
@synthesize sensor;
@synthesize peripheralViewControllerArray;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _progressView.outerRadius = 160; // 外圈半径
    _progressView.innerRadius = 130;  // 内圈半径
    _progressView.beginAngle = 140;    // 起始角度
    _progressView.blockAngle = 8;   // 每个进度块的角度
    _progressView.gapAngle = 0;     // 两个进度块的间隙的角度
    _progressView.progressColor = [UIColor whiteColor]; // 进度条填充色
    _progressView.trackColor    = [UIColor colorWithHexString:@"515111"];   // 进度条痕迹填充色
    _progressView.outlineColor  = [UIColor redColor];  // 进度条边框颜色
    _progressView.outlineWidth  = 0;                    // 进度条边框线宽
    
    _progressView.blockCount = 26;   // 进度块的数量
    _progressView.minValue = 0;      // 进度条最小数值
    _progressView.maxValue = 100;    // 进度条最大数值
    _progressView.currentValue = 10; // 进度条当前数值
    
    _progressView.showShadow = NO;  // 是否显示阴影
    _progressView.shadowOuterRadius = 85; // 阴影外圈半径
    _progressView.shadowInnerRadius = 10; // 阴影内圈半径
    _progressView.shadowFillColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];   // 阴影颜色
    
    _progressView.autoAdjustAngle = YES;  // 自动调整角度
    _progressView.center = self.view.center;
    _progressView.backgroundColor = [UIColor clearColor];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bottomConstraint.constant = _progressView.width/2;
 
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    self.centralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(0, 0)];
  

}

-(NSString *)tvRecv {
    if (!_tvRecv) {
        _tvRecv = [NSString string];
    }
    return _tvRecv;
}

-(NSString *)speed {
    if (!_speed) {
        _speed = [NSString string];
    }
    return _speed;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
