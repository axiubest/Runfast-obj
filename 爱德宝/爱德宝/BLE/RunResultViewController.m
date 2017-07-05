//
//  RunResultViewController.m
//  爱德宝Demo
//
//  Created by A-XIU on 2017/3/9.
//  Copyright © 2017年 XIU. All rights reserved.
//

#import "RunResultViewController.h"
#import "MainPageViewController.h"
#import "XIU_ShareView.h"
@interface RunResultViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *BottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UILabel *KcalLab;
@property (weak, nonatomic) IBOutlet UILabel *KmLab;

@end

@implementation RunResultViewController

- (IBAction)SureBtn:(id)sender {
    
    [self request];
    
    MainPageViewController *main = [[MainPageViewController alloc] init];
    [self.navigationController pushViewController:main animated:YES];
}

- (IBAction)ShareBtn:(id)sender {
    
     [XIU_ShareView showShareView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
        self.navigationController.navigationBarHidden = YES;
    _TimeLab.text = [NSString stringWithFormat:@"%@ m:s", _Time];
    _KcalLab.text = [NSString stringWithFormat:@"%@KCal", _Kcal];
    _KmLab.text = [NSString stringWithFormat:@"%@Km", _Km];
    
    _BottomImageView.layer.cornerRadius = _BottomImageView.frame.size.height / 2;
    _BottomImageView.layer.masksToBounds = YES;
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)request {

    NSString *tmp = [[_Time componentsSeparatedByString:@"."] firstObject];
    
    [[XIU_NetAPIManager sharedManager] request_SaveSportGradeWithKm:[NSString stringWithFormat:@"%@", _Km] Time:[NSString stringWithFormat:@"%@", tmp] KCar:[NSString stringWithFormat:@"%@", _Kcal] Block:^(id data, NSError *error) {
        if (data) {
            [self HUDWithText:@"数据上传成功"];
        }else {
            
        }
    }];
}




@end
