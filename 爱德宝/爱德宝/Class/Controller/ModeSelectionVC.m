//
//  ModeSelectionVC.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "ModeSelectionVC.h"
#import "AKPickerView.h"


static NSString * timeImage_stateHighLight = @"倒计时";
static NSString * timeImage_stateNormal = @"倒计时 (1)";
static NSString * timeImage_select = @"时间";
static NSString * carImage_stateNormal = @"卡路里1";
static NSString * carImage_stateHighLight = @"卡路里";
static NSString * carImage_select = @"卡路里2";
static NSString * disImage_stateNormal = @"行驶里程1";
static NSString * disImage_stateHighLight = @"行驶里程3";
static NSString * disImage_select = @"行驶里程2";



@interface ModeSelectionVC ()<AKPickerViewDataSource, AKPickerViewDelegate>
{
    NSString * modelTmp;
    NSString * value;
}
@property (weak, nonatomic) IBOutlet UIImageView *TimeImageView;

@property (weak, nonatomic) IBOutlet UIImageView *CarImageView;

@property (weak, nonatomic) IBOutlet UIImageView *DistanceImageView;

@property (weak, nonatomic) IBOutlet UIImageView *SelectImageView;


@property (weak, nonatomic) IBOutlet UIView *TimeView;

@property (weak, nonatomic) IBOutlet UIView *CarView;

@property (weak, nonatomic) IBOutlet UIView *DistanceView;

@property (weak, nonatomic) IBOutlet UILabel *SelectLab;


@property (nonatomic, strong) AKPickerView *pickerView;

@property (nonatomic, strong) NSArray *titles;
@end

@implementation ModeSelectionVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)startButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

    if (value) {
        if (!modelTmp) {
            modelTmp = @"time";
        }
        NSDictionary *obj = @{@"type":modelTmp,@"value":value};
        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:model_Value];
    }


    [_MyDelegate modelDelegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"模式选择";
    self.pickerView = [[AKPickerView alloc] initWithFrame:CGRectMake(10, _SelectLab.bottom, self.view.width - 20, 60)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pickerView];
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:50];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:80];
    self.pickerView.interitemSpacing = 20.0;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerView.highlightedTextColor = [UIColor whiteColor];
    self.pickerView.maskDisabled = false;

    
    
    self.titles = [self createPickerViewStart:8 end:99];
    [self.pickerView reloadData];

    
    [self createPickerViewStart:1 end:99];
    
    
    [_TimeView bk_whenTapped:^{
        
        [self createUpImageWithTimeImage:timeImage_stateHighLight CarImage:carImage_stateNormal DistanceImage:disImage_stateNormal SelectImage:timeImage_select SelectLab:@"时间／min"];
        modelTmp = @"time";
        self.titles = [self createPickerViewStart:8 end:99];
        [self.pickerView reloadData];


    }];
    
    [_CarView bk_whenTapped:^{
           [self createUpImageWithTimeImage:timeImage_stateNormal CarImage:carImage_stateHighLight DistanceImage:disImage_stateNormal SelectImage:carImage_select SelectLab:@"卡路里／Kcal"];
        modelTmp = @"kcal";
        self.titles = [self createPickerViewStart:10 end:99];
        [self.pickerView reloadData];
    }];


    
    [_DistanceView bk_whenTapped:^{
        
        [self createUpImageWithTimeImage:timeImage_stateNormal CarImage:carImage_stateNormal DistanceImage:disImage_stateHighLight SelectImage:disImage_select SelectLab:@"里程／Km"];
        modelTmp = @"dis";
        self.titles = [self createPickerViewStart:1 end:45];
        [self.pickerView reloadData];

    }];

}


- (void)createUpImageWithTimeImage:(NSString *)timeImage CarImage:(NSString *)carImage DistanceImage:(NSString *)distanceImage SelectImage:(NSString *)selectImage SelectLab:(NSString *)selectLab{
    
    _TimeImageView.image = imageNamed(timeImage) ;
    _CarImageView.image = imageNamed(carImage);
    _DistanceImageView.image = imageNamed(distanceImage);
    _SelectImageView.image = imageNamed(selectImage);
    _SelectLab.text = selectLab;
}


- (NSArray *)createPickerViewStart:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSInteger i = start; i <= end; i++) {
//        [tmp addObject:i];  ??????
        [tmp addObject:[NSString stringWithFormat:@"%ld", i]];
    }
    return tmp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    return [self.titles count];
}



- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    return self.titles[item];
}

/*
 - (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
 {
	return [UIImage imageNamed:self.titles[item]];
 }
 */

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    value =[NSString stringWithFormat:@"%@",self.titles[item]] ;
    NSLog(@"%@", self.titles[item]);
    NSLog(@"%@", pickerView);
    
}


@end
