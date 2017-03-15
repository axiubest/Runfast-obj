//
//  QMS_RunViewController.m
//  CHISLIM
//
//  Created by A-XIU on 16/8/15.
//  Copyright © 2016年 XIU. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>

#import "QMS_QMSRunViewController.h"

//#import "BLEDeviceViewController.h"
#import "SerialGATT.h"



@interface QMS_QMSRunViewController ()<BTSmartSensorDelegate,UIAlertViewDelegate,UITableViewDataSource,CBPeripheralManagerDelegate,UITableViewDelegate>
{
    CGFloat speedNum;
    int slopeNum;
    NSString *BLEStr;
    
    NSString *calories; //ca
    
    NSString *time;     //t

    NSString *distance; //dis
    
    NSString * heart;   //h
    
    NSString *slope;    //s
    
}


@property (weak, nonatomic) IBOutlet UIButton *chickedMainBtn;

//速度控制快捷按钮
@property (weak, nonatomic) IBOutlet UIButton *QuickBtn;


@property (weak, nonatomic) IBOutlet UILabel *heartLab;

@property (weak, nonatomic) IBOutlet UIView *averageSpeedLab;

@property (weak, nonatomic) IBOutlet UILabel *calorieLab;


@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

/**
 *速度显示屏
 */
@property (weak, nonatomic) IBOutlet UILabel *speedlab;
/**
 *坡度显示屏
 */

@property (weak, nonatomic) IBOutlet UILabel *slopeLab;

@property (nonatomic,strong) UITableView * mainTableView;

@property (nonatomic,strong) CBPeripheralManager * centralManager;

     //蓝牙
@property (weak, nonatomic) IBOutlet UIImageView *blueToothImageView;

@property (weak, nonatomic) IBOutlet UILabel *SearchBtnLab;

@property (nonatomic, strong) NSString *tvRecv;


@property (nonatomic, strong) NSString *speed;

// 是否连接成功
@property (nonatomic, assign) BOOL isConnect;


@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@property (weak, nonatomic) IBOutlet UIImageView *cutLine;


//button(longPressBtn)
@property (weak, nonatomic) IBOutlet UIButton *slopeUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *slopeDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *speedDownBtn;
@property (weak, nonatomic) IBOutlet UIButton *speedUpBtn;
@property (nonatomic, strong) CBPeripheral *Peripheral;

@property (nonatomic,strong) NSTimer *timer;




@end

@implementation QMS_QMSRunViewController
@synthesize sensor;
@synthesize peripheralViewControllerArray;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self AlertTableViewHidden];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //是否隐藏线
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
  
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

#pragma mark chicked quick buttom button
- (IBAction)cickedQuickBtn:(id)sender {


}

#pragma mark chicked buttom quick button Delegate

- (void)chickedQuickBtn:(UIButton *)button
{
    
    NSLog(@"%ld", button.tag);
    
    switch (button.tag) {
        case 0:
            [self setUpBLEValue:[NSString stringWithFormat:@"3.0"] WithAttribute:@"p"];
            break;
        case 1:
            [self setUpBLEValue:[NSString stringWithFormat:@"5.0"] WithAttribute:@"p"];
            break;
        case 2:
            [self setUpBLEValue:[NSString stringWithFormat:@"7.0"] WithAttribute:@"p"];
            break;
        case 3:
            [self setUpBLEValue:[NSString stringWithFormat:@"9.0"] WithAttribute:@"p"];
            break;
        case 4:
            [self setUpBLEValue:[NSString stringWithFormat:@"10.0"] WithAttribute:@"p"];
            break;
        case 5:
            [self setUpBLEValue:[NSString stringWithFormat:@"12.0"] WithAttribute:@"p"];
            break;
        default:
            break;
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];

    
    _tvRecv = [NSString string];
    _speed = [NSString string];
    
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    self.centralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(0, 0)];


    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(100, 100, KWIDTH - 100, 400) style:UITableViewStylePlain];
    _mainTableView.hidden = YES;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    _QuickBtn.hidden = YES;
    
    [self buttomButtonHidden:YES];
    

}

#pragma mark chicked Back btn Method
- (IBAction)chickedBackBtn:(id)sender {
  
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, KHEIGHT, KWIDTH, KHEIGHT);
    }];

}


#pragma mark chiked Main Control Btn Method
- (IBAction)chickedMainontrolBtn:(id)sender {
    
    
//      ----------------BLE---------------
    
        [self setUpBlueTooth];
    
}

- (void)setUpBlueTooth {
    if ([sensor activePeripheral]) {
        [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
        sensor.activePeripheral = nil;
    }if ([self.peripheralViewControllerArray count]) {
            sensor.peripherals = nil;
            [peripheralViewControllerArray removeAllObjects];
            [_mainTableView reloadData];
    }
    sensor.delegate = self;
    
    _SearchBtnLab.text = @"正在搜索";
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [sensor findBLKSoftPeripherals:5];

}

-(void) scanTimer:(NSTimer *)timer
{
    
        _SearchBtnLab.text = @"搜索设备";
    
}

//- (void)chickedMainBtn:(UIButton *)Scan {
//
//    
//    
//    if ([sensor activePeripheral]) {
//
//        [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
//        sensor.activePeripheral = nil;
//        //            }
//    }
//    
//    if ([sensor peripherals]) {
//        
//        sensor.peripherals = nil;
//        [peripheralViewControllerArray removeAllObjects];
//        [_mainTableView reloadData];
//    }
//    
//    sensor.delegate = self;
//
//    _SearchBtnLab.text = @"正在搜索";
//    
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
//    
//    [sensor findBLKSoftPeripherals:5];
//}


#pragma mark--delegate 搜索到蓝牙设备回调方法


#pragma mark select bluetooth method
- (void)chickedAlertMetohd {
    NSLog(@"ckicked btn of alert");
    
}



#pragma mark chicked control Btn
// speed
- (IBAction)chickedSpeedControl:(UIButton *)sender {
    if (sender.tag == 10) {
        if (speedNum<0.6) {
            speedNum = 0.6;
        }
        if (speedNum<18) {
            speedNum+=0.1;
        }else{
            speedNum = 18;
        }
       

        NSLog(@"---%.1f--",speedNum);
        [self setUpBLEValue:[NSString stringWithFormat:@"%.1f", speedNum] WithAttribute:@"p"];

    }else {
        if (speedNum>0) {
            speedNum-=0.1;
        }else{
            speedNum = 0;
        }
        if (speedNum<0.6) {
            speedNum = 0.6;
            //return;(if you do,the app will improve performance)
        }

        [self setUpBLEValue:[NSString stringWithFormat:@"%.1f", speedNum] WithAttribute:@"p"];
    }
}

// slope
- (IBAction)chickedSlopeControl:(UIButton *)sender {
    if (sender.tag == 111) {
//       _slopeLab.text = [NSString stringWithFormat:@"%d", slopeNum <18?++slopeNum:18];
        slopeNum <18?++slopeNum:18;
        [self setUpBLEValue:[NSString stringWithFormat:@"%d", slopeNum] WithAttribute:@"s"];


    }else {
//       _slopeLab.text = [NSString stringWithFormat:@"%d", slopeNum >0?--slopeNum:0];
        slopeNum >0?--slopeNum:0;
        [self setUpBLEValue:[NSString stringWithFormat:@"%d", slopeNum] WithAttribute:@"s"];
        
    }
}


#pragma mark update data
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
   
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

    NSLog(@"value------%@----",value);
    
    
        if ([_tvRecv containsString:@"FF"]) {
        NSArray *subArr = [_tvRecv componentsSeparatedByString:@","];
            NSLog(@"--%@---",subArr);
            
            for (NSString *str in subArr) {
                if ([str containsString:@"st"]) continue;
                if ([str containsString:@"mp"]) continue;
                if ([str containsString:@"sf"]) continue;
                if ([str containsString:@"ms"]) continue;
                if ([str containsString:@"EE"])  continue;
                if ([str containsString:@"ca"]) {
                    self.calorieLab.text = [str substringFromIndex:2];
                }
                if ([str containsString:@"dis"]) {
                    self.distanceLab.text = [str substringFromIndex:3];
                    continue;
                }
                if ([str containsString:@"h"]) {
                    self.heartLab.text = [str substringFromIndex:1];
                    continue;
                }
                if ([str containsString:@"s"]) {
                    self.slopeLab.text = [str substringFromIndex:1];
                    NSLog(@"1111----%@--",self.speedlab.text);
                    slopeNum = [self.slopeLab.text intValue];
                }
                if ([str containsString:@"p"]) {
                    self.speedlab.text = [str substringFromIndex:1];
                    speedNum = [self.speedlab.text floatValue];
                }
                if ([str containsString:@"t"]) {
                    NSString *timeStr = [str substringFromIndex:1];
                    if (![timeStr isEqualToString:@"0.00"]) {
                        static dispatch_once_t onceToken;
                        dispatch_once(&onceToken, ^{
                            if ([self.myDelegate respondsToSelector:@selector(qmsRunViewControllerisStart:)]) {
                                [self.myDelegate qmsRunViewControllerisStart:YES];
                            }
                        });
                    }
                    
                    self.timeLab.text = timeStr;

                }
            }
            
        _tvRecv = @"";
        
    }else{
        _tvRecv =  [_tvRecv stringByAppendingString:value];
    }

}

-(int)dealTime:(NSString *)timeStr{
    int timeI = [timeStr intValue];
    NSRange rang = [timeStr rangeOfString:@"."];
    NSString *secondStr = [timeStr substringFromIndex:rang.location+rang.length];
    int second = [secondStr intValue];
    return timeI*60+second;
}



- (void)setUpBLEValue:(NSString *)value WithAttribute:(NSString *)attribute {
    
//    value = @"1";
//   NSString *str = [NSString XIU_BLEStringAppendingHaracteristics:value WithFunc:attribute];
//    
//    NSLog(@"----------------------------------");
//    NSLog(@"%@---", str);
//    NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
//    [sensor write:sensor.activePeripheral data:data];
//    [sensor read:sensor.activePeripheral];
}

#pragma mark  tableView-Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.peripheralViewControllerArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [sensor.manager stopScan];
//    NSUInteger row = [indexPath row];
    
    [self AlertTableViewHidden];
    
//    BLEDeviceViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    if (sensor.activePeripheral && sensor.activePeripheral != _Peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = _Peripheral;
    
    [sensor connect:sensor.activePeripheral];
    
    _mainTableView.hidden = YES;
}

- (void)AlertTableViewHidden {
    _mainTableView.hidden = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"peripheral";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    // Configure the cell
//    NSUInteger row = [indexPath row];
//    BLEDeviceViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
//    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = _Peripheral.name;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


-(void)setConnect
{
    [self buttomButtonHidden:NO];
    
    self.isConnect = YES;

}

-(void)setDisconnect
{
     self.isConnect = NO;
    if ([self.myDelegate respondsToSelector:@selector(qmsRunViewControllerisStart:)]) {
        [self.myDelegate qmsRunViewControllerisStart:NO];
    }

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
    _mainTableView.hidden = NO;
    [_mainTableView reloadData];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self AlertTableViewHidden];
    
    
}


#pragma mark ---start----
- (IBAction)startBtnClick:(id)sender {
    
    if (!self.isConnect) {
        return;
    }
    
    if ([self.myDelegate respondsToSelector:@selector(qmsRunViewControllerisStart:)]) {
        [self.myDelegate qmsRunViewControllerisStart:YES];
    }
    
    NSString *str = @"EE,A1,IDchislim,108,FF";
    
    
    NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:data];
    
}
#pragma mark ---end----
- (IBAction)endBtnClick:(id)sender {


    if (!self.isConnect) {
        return;
    }
    
    if ([self.myDelegate respondsToSelector:@selector(qmsRunViewControllerisStart:)]) {
        [self.myDelegate qmsRunViewControllerisStart:NO];
    }
    
        self.isConnect = NO;
    
        NSString *str = @"EE,A0,IDchislim,107,FF";
        
        NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
        [sensor write:sensor.activePeripheral data:data];
    
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sensor disconnect:sensor.activePeripheral];
    });



}


#pragma mark startbtn endbtn mainbtn hidden
- (void)buttomButtonHidden:(BOOL)boolHidden {
}

//  蓝牙异常退出

-(void)abNormalConnect{
    self.isConnect = NO;
    [self endBtnClick:nil];
}

@end
