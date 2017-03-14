//
//  movingObjectViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/9.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "movingObjectViewController.h"
#import "ASValueTrackingSlider.h"
@interface movingObjectViewController ()<ASValueTrackingSliderDataSource>
{
    NSDate *nowDate;
    NSDate *sevenDate;
    NSInteger day;
    CGFloat dis;
    
}
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property (weak, nonatomic) IBOutlet UIButton *MonthButton;

@property (weak, nonatomic) IBOutlet UILabel *mubiaoLab;

@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *slider;


@property (weak, nonatomic) IBOutlet UILabel *startLab;
@property (weak, nonatomic) IBOutlet UILabel *endLab;
@end

@implementation movingObjectViewController


- (IBAction)clickweek:(id)sender {
    day = 7;
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 100.0;
    _MonthButton.backgroundColor = [UIColor colorWithHexString:@"1D5F1E"];
    _weekButton.backgroundColor = [UIColor colorWithHexString:@"00AAFF"];
    NSTimeInterval  oneDay = 24*60*60*1;
    sevenDate = [nowDate initWithTimeIntervalSinceNow:+oneDay*7];
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy.MM.dd"];
    NSString *sevenDateStr  =[formater stringFromDate:sevenDate];
    _endLab.text = sevenDateStr;
    
}

- (IBAction)clickedmonth:(id)sender {
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 500.0;
    day = 30;
    
    _MonthButton.backgroundColor = [UIColor colorWithHexString:@"30C302"];
    _weekButton.backgroundColor = [UIColor colorWithHexString:@"0B5486"];
    
    NSTimeInterval  oneDay = 24*60*60*1;
    NSDate *monthdate = [nowDate initWithTimeIntervalSinceNow:+oneDay*30];
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy.MM.dd"];
    NSString *sevenDateStr  =[formater stringFromDate:monthdate];
    _endLab.text = sevenDateStr;

    


}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    day = 7;
    dis = 50;
     self.navigationController.interactivePopGestureRecognizer.enabled=NO;
    _weekButton.layer.masksToBounds = YES;
    _weekButton.layer.cornerRadius = _weekButton.width/ 2;
    
    _MonthButton.layer.masksToBounds = YES;
    _MonthButton.layer.cornerRadius = _MonthButton.width / 2;
    
    nowDate = [NSDate date];
   NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy.MM.dd"];
    NSString *currentDateStr = [formater stringFromDate:nowDate];
    _startLab.text = currentDateStr;
    
    NSTimeInterval  oneDay = 24*60*60*1;
   sevenDate = [nowDate initWithTimeIntervalSinceNow:+oneDay*7];
    NSString *sevenDateStr  =[formater stringFromDate:sevenDate];
    _endLab.text = sevenDateStr;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"运动目标";
    [self createNavgationButtonWithImageNmae:nil  title:@"保存" target:self action:@selector(save) type: UINavigationItem_Type_RightItem];
    
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"Km"];
    [tempFormatter setNegativeSuffix:@"Km"];

    self.slider.dataSource = self;
    [self.slider setNumberFormatter:tempFormatter];
    self.slider.minimumValue = 0.0;
    self.slider.maximumValue = 100.0;
    self.slider.popUpViewCornerRadius = 16.0;
    
    self.slider.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:26];
    self.slider.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    UIColor *coldBlue = [UIColor colorWithHue:0.6 saturation:0.7 brightness:1.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithHue:0.55 saturation:0.75 brightness:1.0 alpha:1.0];
    UIColor *green = [UIColor colorWithHue:0.3 saturation:0.65 brightness:0.8 alpha:1.0];
    UIColor *yellow = [UIColor colorWithHue:0.15 saturation:0.9 brightness:0.9 alpha:1.0];
    UIColor *red = [UIColor colorWithHue:0.0 saturation:0.8 brightness:1.0 alpha:1.0];

    [self.slider setPopUpViewAnimatedColors:@[coldBlue, blue, green, yellow, red]
                               withPositions:@[@-20, @0, @5, @25, @60]];
}

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    _mubiaoLab.text = [NSString stringWithFormat:@"我的目标:%@", [slider.numberFormatter stringFromNumber:@(value)]];
    dis = value;
    value = roundf(value);
    NSString *s;
    if (self.slider.maximumValue == 500.0) {
        if (value < 250.0) {
            s =  [NSString stringWithFormat:@"💪 %@", [slider.numberFormatter stringFromNumber:@(value)]];
        } else if (value > 250.0 && value < 388.0) {
            s = [NSString stringWithFormat:@"😎 %@ 😎", [slider.numberFormatter stringFromNumber:@(value)]];
        } else if (value >= 388.0) {
            s = [NSString stringWithFormat:@"⚠️ %@", [slider.numberFormatter stringFromNumber:@(value)]];;
        }
        return s;
    }else {
        if (value < 29.0) {
            s =  [NSString stringWithFormat:@"💪 %@", [slider.numberFormatter stringFromNumber:@(value)]];
        } else if (value > 29.0 && value < 70.0) {
            s = [NSString stringWithFormat:@"😎 %@ 😎", [slider.numberFormatter stringFromNumber:@(value)]];
        } else if (value >= 70.0) {
            s = [NSString stringWithFormat:@"⚠️ %@", [slider.numberFormatter stringFromNumber:@(value)]];;
        }
        return s;
    }
    

}


- (void)save {
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld", (long)day] forKey:sportDay];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lf", dis] forKey:sportDis];
    [self pushViewControllerWithCcontroller:[[MainPageViewController alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
