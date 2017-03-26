//
//  BLEViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/11.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "BLEViewController.h"
#import "Constant.h"
#import "BackProgressView.h"
#import "GraProgressView.h"
#import "IndicatorProgressView.h"
#import "ShapeProgressView.h"
#import "SerialGATT.h"
#import "RunResultViewController.h"
#import "NSString+CHISLIM_BLE.h"
#import "HKPlayVoice.h"
@interface BLEViewController ()
{
    CGFloat _topOffset;
    CGFloat speedNum;
    int slopeNum;

    NSString *modelDis;
    NSString *modelKcar;
    NSString *modelTime;
    
    
    NSString *modelValue;
    BOOL isModelValue;
}


@property (weak, nonatomic) IBOutlet UIView *slopeControlView;

@property (nonatomic, strong) UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

//@property (nonatomic, strong)

@property (nonatomic, strong) UIImageView *carSque;

@property (nonatomic, strong) BackProgressView *backView; /** 底色进度条 */
@property (nonatomic, strong) GraProgressView *graView; /** 渐变进度条 */
@property (nonatomic,strong) NSTimer *proTimer;

@property (nonatomic, strong) IndicatorProgressView *radarView; /** 扇形 */
@property (nonatomic, strong) IndicatorProgressView *indicatorView; /** 扇形 */

//@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *endButton;


@property (weak, nonatomic) IBOutlet UIView *BpmView;
@property (weak, nonatomic) IBOutlet UIView *KcalView;
@property (weak, nonatomic) IBOutlet UIView *TimeView;
@property (weak, nonatomic) IBOutlet UIView *KmView;

@property (weak, nonatomic) IBOutlet UILabel *BpmLab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UILabel *KmLab;
@property (weak, nonatomic) IBOutlet UILabel *KcalLab;

@property (weak, nonatomic) IBOutlet UIImageView *BmpImageView;

@property (weak, nonatomic) IBOutlet UIImageView *TimeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *KmImageView;

@property (weak, nonatomic) IBOutlet UIImageView *KcalImageView;

@property (strong, nonatomic) UILabel *maxLab;
@property (strong, nonatomic) UILabel *minLab;

@property (weak, nonatomic) IBOutlet UILabel *slopeLab;

@property (nonatomic, strong) NSMutableArray *KcarImageArr;
@property (nonatomic, strong) NSMutableArray *KmImageArr;
@property (nonatomic, strong) NSMutableArray *TimeImageArr;
@property (nonatomic, strong) NSMutableArray *BmpImageArr;
@end

@implementation BLEViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBaseAttribute];
    [self initProgressView];
 
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notice:) name:@"RunMainNotification" object:nil];
    [self addTap];
    
    
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSString *str = @"EE,A1,IDchislim,108,FF";
    
    NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
    [_sensor write:_sensor.activePeripheral data:data];
  //  self.startButton.hidden = YES;
    self.endButton.hidden = NO;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    isModelValue = NO;
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:model_Value]);
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:model_Value]) {
        isModelValue = YES;
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:model_Value];
//        modelType = [dic objectForKey:@"type"];
        modelValue = [dic objectForKey:@"value"];
        if ([[dic objectForKey:@"type"] isEqualToString:@"dis"]) {
            modelDis = [dic objectForKey:@"type"];
        }if ([[dic objectForKey:@"type"] isEqualToString:@"kcar"]) {
            modelKcar =  [dic objectForKey:@"type"];
        }if ([[dic objectForKey:@"type"] isEqualToString:@"time"]) {
            modelTime = [dic objectForKey:@"type"];
        }
        
    }
    
    _backButton.hidden = YES;
    
    [_endButton setHalfCornerRadius];

    self.maxLab.text = @"25";
    self.minLab.text = @"0";
    _BmpImageView.animationImages = self.BmpImageArr;
    _BmpImageView.animationDuration = 6*0.15;
    _BmpImageView.animationRepeatCount = 0;
    [_BmpImageView startAnimating];
    _KmImageView.animationImages = self.KmImageArr;
    _KmImageView.animationDuration = 6*0.15;
    _KmImageView.animationRepeatCount = 0;
    [_KmImageView startAnimating];
    _KcalImageView.animationImages = self.KcarImageArr;
    _KcalImageView.animationDuration = 6*0.15;
    _KcalImageView.animationRepeatCount = 0;
    [_KcalImageView startAnimating];
    _TimeImageView.animationImages = self.TimeImageArr;
    _TimeImageView.animationDuration = 6*0.15;
    _TimeImageView.animationRepeatCount = 0;
    [_TimeImageView startAnimating];
    
    _carSque.userInteractionEnabled = YES;
    
}



- (void)addTap {
    UISwipeGestureRecognizer *speedleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipesLeft:)];
    UISwipeGestureRecognizer *speedright = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipesRight:)];
    
    speedleft.direction = UISwipeGestureRecognizerDirectionLeft;
    speedright.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *slopeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSlopeSwipesLeft:)];
    UISwipeGestureRecognizer *sloperight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSlopeSwipesRight:)];
    
    slopeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    sloperight.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    
    [self.carSque addGestureRecognizer:speedleft];
    [self.carSque addGestureRecognizer:speedright];
    [self.slopeControlView addGestureRecognizer:slopeleft];
    [self.slopeControlView addGestureRecognizer:sloperight];
}


#pragma mark----------------------速度手势
- (void)handleSwipesLeft:(UISwipeGestureRecognizer *)sender {
    if (speedNum == 0.6) {
        speedNum = 1;
    }
    if (speedNum>0) {
        speedNum-=1;
    }else{
        speedNum = 0;
    }
    if (speedNum<=0.6) {
        speedNum = 1;
        //return;(if you do,the app will improve performance)
    }
    
    [self setUpBLEValue:[NSString stringWithFormat:@"%.1f", speedNum] WithAttribute:@"p"];
    [self changeRadarViewJian];
}
- (void)handleSwipesRight:(UISwipeGestureRecognizer *)sender {
    if (speedNum == 0.6) {
        speedNum = 1;
    }
    if (speedNum<[_maxLab.text floatValue]) {
        speedNum+=1;
    }else{
        speedNum = [_maxLab.text floatValue];
    }
    
    [self setUpBLEValue:[NSString stringWithFormat:@"%.1f", speedNum] WithAttribute:@"p"];
    [self changeRadarViewPlus];
}
#pragma mark----------------------速度手势



#pragma mark----------------------坡度手势
- (void)handleSlopeSwipesLeft:(UISwipeGestureRecognizer *)sender {
    slopeNum >0?--slopeNum:0;
    [self setUpBLEValue:[NSString stringWithFormat:@"%d", slopeNum] WithAttribute:@"s"];
    if (slopeNum == 0) {
        [self HUDWithText:@"坡度已到达最小值"];
    }
}

- (void)handleSlopeSwipesRight:(UISwipeGestureRecognizer *)sender {
    slopeNum <18?++slopeNum:18;
    if (slopeNum == 18) {
        [self HUDWithText:@"坡度已到达最大值"];
    }
    [self setUpBLEValue:[NSString stringWithFormat:@"%d", slopeNum] WithAttribute:@"s"];
}
- (void)setUpBLEValue:(NSString *)value WithAttribute:(NSString *)attribute {
    //    value = @"1";
    NSString *str = [NSString XIU_BLEStringAppendingHaracteristics:value WithFunc:attribute];
    

    NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
    [self.sensor write:self.sensor.activePeripheral data:data];

}

#pragma mark create lable
-(void)notice:(NSNotification *)sender{
    
    
    NSString *BaseString = [[sender userInfo] objectForKey:@"main"];
    
    if ([BaseString containsString:@"FF"]) {
        NSArray *subArr = [BaseString componentsSeparatedByString:@","];
        NSLog(@"--%@---",subArr);

        for (NSString *str in subArr) {
            if ([str containsString:@"st"]) continue;
            if ([str containsString:@"mp"]) continue;
            if ([str containsString:@"sf"]) continue;
            if ([str containsString:@"ms"]) {
                _maxLab.text = [str substringFromIndex:2];
                continue;
            }if ([str containsString:@"mi"]) {
                _minLab.text = [str substringFromIndex:2];
                continue;
            }
            if ([str containsString:@"EE"])  continue;
            if ([str containsString:@"ca"]) {
                self.KcalLab.text = [str substringFromIndex:2];
//                if (modelKcar) {
//                    [[str substringFromIndex:2] floatValue] >= [modelKcar floatValue] ? [self HUDWithText:@"您已达标卡路里数"] : @"";
//                }
            }
            if ([str containsString:@"dis"]) {
                self.KmLab.text = [str substringFromIndex:3];
//                if (modelDis) {
//                    [[str substringFromIndex:3] floatValue] >=[modelDis floatValue]? [self HUDWithText:@"您已达标公里数"] : @"";
//                }
                continue;
            }
            if ([str containsString:@"h"]) {
                self.BpmLab.text = [str substringFromIndex:1];
                continue;
            }
            if ([str containsString:@"s"]) {
                self.slopeLab.text = [str substringFromIndex:1];

                slopeNum = [[str substringFromIndex:1] floatValue];
            }
            if ([str containsString:@"p"]) {
                self.graView.num = [[str substringFromIndex:1] floatValue];
                speedNum = [[str substringFromIndex:1] floatValue];
                [self valueForProgressView];
            }if ([str containsString:@"t"]) {
                NSString *timeStr = [str substringFromIndex:1];
                if (![timeStr isEqualToString:@"0.00"]) {
                }
                
                self.TimeLab.text = timeStr;
//                if (modelTime) {
//                    [timeStr floatValue] >=[modelTime floatValue]? [self HUDWithText:@"您已达标时间数"] : @"";
//                }

                
            }
        }
    }
}


- (void)valueForProgressView {
    self.graView.num = speedNum;
    self.radarView.arcAngle = speedNum;
    self.indicatorView.arcAngle = speedNum;
    [self.indicatorView changeRedrawRange];
    [self.radarView changeRedrawRange];
}

#pragma mark - private
- (void)initProgressView{
    
    // 底色进度条
    self.backView.frame = CGRectMake(-8, 10, self.carSque.width, self.carSque.height);
    [self.carSque addSubview:self.backView];
    
    // 渐变进度条
    self.graView.frame = self.backView.frame;
    [self.carSque addSubview:self.graView];
    // 渐变设置
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.graView.frame;
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    CGColorRef color1 = GLRGBColor(1, 133, 241).CGColor;
    CGColorRef color2 = GLRGBColor(141, 60, 184).CGColor;
    gradientLayer.colors = @[(__bridge id)color1, (__bridge id)color2];
    gradientLayer.mask = self.graView.layer;
    [self.carSque.layer addSublayer:gradientLayer];
    self.graView.frame = gradientLayer.bounds;
    
    // 扇形
//    self.radarView.frame = CGRectMake(-8, 10, self.carSque.width, self.carSque.height);
//    self.radarView.radius = self.carSque.width * 0.35;
//    self.radarView.arcAngle = 0;
    //    self.radarView.indicatorWidth = 0.1;
    //    self.radarView.indicatorAlpha = 0.70; // 指针透明度
    self.radarView.offsetAngle = beginAngle;
    self.radarView.isRader = NO;
    [self.carSque addSubview:self.radarView];
    // 渐变
    CAGradientLayer *gradientLayerRadarView = [[CAGradientLayer alloc] init];
    gradientLayerRadarView.frame = self.radarView.frame;
    gradientLayerRadarView.startPoint = CGPointMake(0, 0.5);
    gradientLayerRadarView.endPoint = CGPointMake(1, 0.5);
    CGColorRef color3 = GLRGBA(1, 133, 241, 0.0).CGColor;
    CGColorRef color4 = GLRGBA(72, 204, 201, 0.0).CGColor;
    CGColorRef color5 = GLRGBA(72, 204, 201, 0.15).CGColor;
    CGColorRef color6 = GLRGBA(72, 204, 201, 0.36).CGColor;
    gradientLayerRadarView.colors = @[(__bridge id)color3, (__bridge id)color4, (__bridge id)color5, (__bridge id)color6];
    gradientLayerRadarView.mask = self.radarView.layer;
    [self.carSque.layer addSublayer:gradientLayerRadarView];
    self.radarView.frame = gradientLayerRadarView.bounds;
    
    // 指针
    self.indicatorView.frame = CGRectMake(-8, 10, self.carSque.width, self.carSque.height);
    self.indicatorView.radius = self.carSque.width * 0.35; // 绘制半径
    self.indicatorView.arcAngle = 0; // 扇形角度范围，default： 0
    self.indicatorView.indicatorWidth = 0; // 指针宽度
    self.indicatorView.indicatorAlpha = 0.25; // 指针透明度
    self.indicatorView.offsetAngle = beginAngle;
    self.indicatorView.isRader = YES;
    [self.carSque addSubview:self.indicatorView];

}



- (void)initBaseAttribute{
    
    self.view.backgroundColor = GLRGBA(0, 1, 10, 1.0);
    _topOffset = 25;
    // 背景1
    [self.view addSubview:self.bgView];
    self.bgView.frame = CGRectMake(0, _topOffset, GLScreenWidth, 443);
    // carSque
    [self.view addSubview:self.carSque];
    self.carSque.size = CGSizeMake(339, 326);
    self.carSque.y = _topOffset;
    self.carSque.centerX = GLScreenWidth * 0.5;
}


#pragma mark - progress control
- (void)changeRadarViewPlus{
    // 1.进度块
    CGFloat maxFloat = [self.maxLab.text floatValue];
    self.graView.num += 1;
    if (self.graView.num > maxFloat) {
        self.graView.num = maxFloat;
        [self HUDWithText:@"已达到最大值"];
        
    }
    // 2.扇形
    self.radarView.arcAngle += 1;
    if (self.radarView.arcAngle >= maxFloat)  {
        self.radarView.arcAngle = maxFloat;
        [self.radarView changeRedrawRange];
    }
    
    // 3.指针
    self.indicatorView.arcAngle += 1;
    if (self.indicatorView.arcAngle >= maxFloat)  {
        self.indicatorView.arcAngle = maxFloat;
        [self.indicatorView changeRedrawRange];
        return;
    }
    
    // 4.扇形+指针重绘
    [self.indicatorView changeRedrawRange];
    [self.radarView changeRedrawRange];
}

- (void)changeRadarViewJian{
    CGFloat minFloat = [_minLab.text floatValue];
    self.graView.num -= 1;
    if (self.graView.num < minFloat) {
        self.graView.num = minFloat;
        [self HUDWithText:@"已达到最小值"];
    }
    self.radarView.arcAngle -= 1;
    if (self.radarView.arcAngle <= minFloat)  {
        self.radarView.arcAngle = minFloat;
        [self.radarView changeRedrawRange];
    }
    
    self.indicatorView.arcAngle -= 1;
    if (self.indicatorView.arcAngle <= minFloat)  {
        self.indicatorView.arcAngle = minFloat;
        [self.indicatorView changeRedrawRange];

        return;
    }
    
    [self.indicatorView changeRedrawRange];
    [self.radarView changeRedrawRange];
}

- (IBAction)clickedEndButton:(id)sender {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:model_Value];
    NSString *str = @"EE,A0,IDchislim,107,FF";
    NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
    [_sensor write:_sensor.activePeripheral data:data];
    
#pragma mark 正式解开
//    if ([_KmLab.text integerValue] < 1) {
//        [self HUDWithText:@"您的运动里程过少，不予保存。"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        return;
//    }
    [[NSUserDefaults standardUserDefaults] setObject:_KmLab.text forKey:sport_now_dis];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_sensor disconnect:_sensor.activePeripheral];
    });
        RunResultViewController *result = [[RunResultViewController alloc] init];
        result.Km = _KmLab.text;
        result.Kcal = _KcalLab.text;
        result.Time = _TimeLab.text;
        [self.navigationController pushViewController:result animated:YES];
    

}


//- (IBAction)clickedStartButton:(id)sender {
//
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//    
//    NSString *str = @"EE,A1,IDchislim,108,FF";
//    
//    NSData *data = [str dataUsingEncoding:[NSString defaultCStringEncoding]];
//    [_sensor write:_sensor.activePeripheral data:data];
//    self.endButton.hidden = NO;
//
//}
- (void)changeLowView {
    
    self.graView.num -= 1;
    if (self.graView.num <= 1) {
        self.graView.num = 1;
        [self HUDWithText:@"已达到最小值"];
//        self.graView.numLabel.text = [NSString stringWithFormat:@"%ld", ]
        
    }
    // 2.扇形
    self.radarView.arcAngle -= 1;
    if (self.radarView.arcAngle >= SCORE)  {
        self.radarView.arcAngle = SCORE;
        [self.radarView changeRedrawRange];
    }
    
    // 3.指针
    self.indicatorView.arcAngle += 1;
    if (self.indicatorView.arcAngle >= SCORE)  {
        self.indicatorView.arcAngle = SCORE;
        [self.indicatorView changeRedrawRange];
        [self.proTimer invalidate];
        self.proTimer = nil;
        return;
    }
    
    // 4.扇形+指针重绘
    [self.indicatorView changeRedrawRange];
    [self.radarView changeRedrawRange];

}

- (IBAction)PresentViewControllerBackButtonClick:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 懒加载
- (UIImageView *)bgView{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"car_bg_top"];
    }
    return _bgView;
}

- (UIImageView *)carSque{
    if (!_carSque) {
        _carSque = [[UIImageView alloc] init];
        _carSque.image = [UIImage imageNamed:@"car_sque"];
    }
    return _carSque;
}

- (BackProgressView *)backView{
    if (!_backView) {
        _backView = [[BackProgressView alloc] init];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

- (GraProgressView *)graView{
    if (!_graView) {
        _graView = [[GraProgressView alloc] init];
        _graView.backgroundColor = [UIColor clearColor];
    }
    return _graView;
}

- (IndicatorProgressView *)radarView{
    if (!_radarView) {
        _radarView = [[IndicatorProgressView alloc] init];
        _radarView.backgroundColor = [UIColor clearColor];
    }
    return _radarView;
}

- (IndicatorProgressView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[IndicatorProgressView alloc] init];
        _indicatorView.backgroundColor = [UIColor clearColor];
    }
    return _indicatorView;
}

-(UILabel *)maxLab {
    if (!_maxLab) {
        _maxLab = [[UILabel alloc] init];
        _maxLab.text = @"0";
        
        _maxLab.textColor = [UIColor lightGrayColor];
        [self.backView addSubview:_maxLab];
        [_maxLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView.mas_bottom).with.offset(-60);
            make.right.equalTo(self.backView.mas_right).with.offset(-60);
        }];
    }
    return _maxLab;
}

-(UILabel *)minLab {
    if (!_minLab) {
        _minLab = [[UILabel alloc] init];
        _minLab.text = @"0";
        
        _minLab.textColor = [UIColor lightGrayColor];
        [self.backView addSubview:_minLab];
        [_minLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backView.mas_bottom).with.offset(-60);
            make.left.equalTo(self.backView.mas_left).with.offset(60);
        }];

    }
    return _minLab;
}


-(NSMutableArray *)KcarImageArr {
    if (!_KcarImageArr) {
        _KcarImageArr = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *str = [NSString stringWithFormat:@"icon_calories%d", i];
            UIImage *img = [UIImage imageNamed:str];
            [_KcarImageArr addObject:img];
        }
    }
    return _KcarImageArr;

}

-(NSMutableArray *)KmImageArr {
    if (!_KmImageArr) {
        _KmImageArr = [NSMutableArray array];
        for (int i = 1; i < 6; i++) {
            NSString *str = [NSString stringWithFormat:@"icon_distance%d", i];
            UIImage *img = [UIImage imageNamed:str];
            [_KmImageArr addObject:img];
            
        }
    }
    return _KmImageArr;
    
}

-(NSMutableArray *)TimeImageArr {
    if (!_TimeImageArr) {
        _TimeImageArr = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *str = [NSString stringWithFormat:@"time%d", i];
            UIImage *img = [UIImage imageNamed:str];
            [_TimeImageArr addObject:img];
        }
    }
    return _TimeImageArr;
    
}

-(NSMutableArray *)BmpImageArr {
    if (!_BmpImageArr) {
        _BmpImageArr = [NSMutableArray array];
        for (int i = 1; i < 7; i++) {
            NSString *str = [NSString stringWithFormat:@"icon_heart%d", i];
            UIImage *img = [UIImage imageNamed:str];
            [_BmpImageArr addObject:img];

        }
    }
    return _BmpImageArr;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
