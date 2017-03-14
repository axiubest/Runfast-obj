//
//  QMS_RunViewController.h
//  CHISLIM
//
//  Created by A-XIU on 16/8/15.
//  Copyright © 2016年 XIU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"

@protocol QMS_QMSRunViewControllerDelegate <NSObject>


-(void)qmsRunViewControllerisStart:(BOOL)isStart;

@end

@interface QMS_QMSRunViewController : UIViewController

@property (nonatomic, strong) void(^dismissBlock)();

@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;

-(void) scanTimer:(NSTimer *)timer;
@property (nonatomic,weak)id<QMS_QMSRunViewControllerDelegate> myDelegate;
@end
