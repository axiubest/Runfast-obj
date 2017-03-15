//
//  BLEListTableViewController.h
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/12.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"

@protocol BLEListTableViewDelegate <NSObject>

- (void)FindPeripheral;

@end

@interface BLEListTableViewController : UIViewController
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;
@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, strong) CBPeripheral *Peripheral;
@property (nonatomic, assign) id<BLEListTableViewDelegate> MyDelegate;
@end
