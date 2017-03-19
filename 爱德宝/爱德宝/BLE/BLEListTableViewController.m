//
//  BLEListTableViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/12.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "BLEListTableViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface BLEListTableViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, weak) UITableView *table;
@end

@implementation BLEListTableViewController

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
    
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peripheralViewControllerArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _Peripheral.name];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_MyDelegate FindPeripheral];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
