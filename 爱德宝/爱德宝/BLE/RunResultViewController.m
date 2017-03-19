//
//  RunResultViewController.m
//  爱德宝Demo
//
//  Created by A-XIU on 2017/3/9.
//  Copyright © 2017年 XIU. All rights reserved.
//

#import "RunResultViewController.h"

@interface RunResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *BottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UILabel *KcalLab;
@property (weak, nonatomic) IBOutlet UILabel *KmLab;

@end

@implementation RunResultViewController



- (IBAction)SureBtn:(id)sender {
    [self request];
}

- (IBAction)ShareBtn:(id)sender {
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    _TimeLab.text = [NSString stringWithFormat:@"%@ m:s", _Time];
    _KcalLab.text = [NSString stringWithFormat:@"%@KCal", _Kcal];
    _KmLab.text = [NSString stringWithFormat:@"%@Km", _Km];
    
    _BottomImageView.layer.cornerRadius = _BottomImageView.frame.size.height / 2;
    _BottomImageView.layer.masksToBounds = YES;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request {
    [[XIU_NetAPIManager sharedManager] request_SaveSportGradeWithKm:@"12" Time:@"333" KCar:@"3443" Block:^(id data, NSError *error) {
        
    }];
}

@end
