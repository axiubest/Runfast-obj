//
//  BLEListTableViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/12.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "BLEListTableViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDeviceViewController.h"

@interface BLEListTableViewController ()<UITableViewDelegate, UITableViewDataSource,BTSmartSensorDelegate,CBPeripheralManagerDelegate>
@property (nonatomic,strong) CBPeripheralManager * centralManager;


@property (nonatomic, weak) UITableView *table;
@end

@implementation BLEListTableViewController
@synthesize sensor;
@synthesize peripheralViewControllerArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    i.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    [self.view addSubview:i];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KWIDTH, KHEIGHT) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    _table = table;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
    
    
    
    
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    self.centralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(0, 0)];
    
    
    if ([sensor activePeripheral]) {
        
        [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
        sensor.activePeripheral = nil;
    }
    
    if ([sensor peripherals]) {
        
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [table reloadData];
    }
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"----%ld", self.peripheralViewControllerArray.count);
        return [self.peripheralViewControllerArray count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    // Configure the cell
    NSUInteger row = [indexPath row];
    BLEDeviceViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
    

    return cell;
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
    
    BLEDeviceViewController *controller = [[BLEDeviceViewController alloc] init];
    controller.peripheral = peripheral;
    controller.sensor = sensor;
    [peripheralViewControllerArray addObject:controller];
    _table.hidden = NO;
    [_table reloadData];
}


@end
