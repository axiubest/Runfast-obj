//
//  BLEDeviceViewController.m
//  BuleToothText
//
//  Created by try on 14-12-29.
//  Copyright (c) 2014年 TRY. All rights reserved.
//

#import "BLEDeviceViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "QuartzCore/QuartzCore.h"

//#import "NSString+CHISLIM_BLE.h"
@interface BLEDeviceViewController ()<BTSmartSensorDelegate,UITextFieldDelegate>
{
    NSString *BLEStr;
    
    NSString *calories; //cor
    
    NSString *time;     //t
    
    NSString *distance; //dis
    
    NSString *speed;    //p
    
    NSString * heart;   //h
    
    NSString *slope;    //s
}






@end

@implementation BLEDeviceViewController
@synthesize MsgToArduino;
@synthesize theTrackingSwitch;
@synthesize textFromAdruino;
@synthesize tvRecv;
@synthesize lbDevice;

@synthesize rssi_container;

@synthesize peripheral;
@synthesize sensor;

static NSInteger fasong;
static NSInteger jieshou;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.sensor.activePeripheral.name;
    self.sensor.delegate = self;

}


- (void)viewDidUnload
{
    [self setTextFromAdruino:nil];
    [self setTheTrackingSwitch:nil];
    [self setMsgToArduino:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    
    //数据长度
    jieshou += [data length];

    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

    tvRecv.text= [tvRecv.text stringByAppendingString:value];

    [tvRecv scrollRangeToVisible:NSMakeRange(tvRecv.text.length, 1)];
    
    
    
    
    
    tvRecv.text = [tvRecv.text stringByAppendingString:value];
    NSLog(@"----------%@", tvRecv.text);
    if ([tvRecv.text  hasPrefix:@"EE"] && [tvRecv.text  hasSuffix:@"FF"]) {
        NSArray *b = [tvRecv.text  componentsSeparatedByString:@","];
        
        NSRange range = [[b objectAtIndex:10] rangeOfString:@"ca"];
        
        calories = [calories stringByReplacingOccurrencesOfString:[b objectAtIndex:10] withString:@"ca"];
        time = [time stringByReplacingOccurrencesOfString:[b objectAtIndex:19] withString:@"t"];
        distance = [distance stringByReplacingOccurrencesOfString:[b objectAtIndex:15] withString:@"dis"];
        heart = [heart stringByReplacingOccurrencesOfString:[b objectAtIndex:12] withString:@"h"];
        slope = [slope stringByReplacingOccurrencesOfString:[b objectAtIndex:17] withString:@"s"];
        speed = [speed stringByReplacingOccurrencesOfString:[b objectAtIndex:18] withString:@"p"];
        
        NSLog(@"%@, %@, %@, %@, %@, %@, %@", [b objectAtIndex:10], [b objectAtIndex:19], [b objectAtIndex:15], [b objectAtIndex:12], [b objectAtIndex:17], [b objectAtIndex:18], [b objectAtIndex:6]);

        tvRecv.text = @"";

    }
}

#pragma mark write————————————————————————————————
- (IBAction)sendMsgToArduino:(id)sender {
    
    
    NSData *data = [MsgToArduino.text dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
    
    fasong += [data length];
    NSString * charariste = [NSString stringWithFormat:@"TX: %ld , RX: %ld",fasong,jieshou];
    _count.text = charariste;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
