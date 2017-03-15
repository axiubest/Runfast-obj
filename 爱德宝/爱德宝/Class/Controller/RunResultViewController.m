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

@end

@implementation RunResultViewController



- (IBAction)SureBtn:(id)sender {
}

- (IBAction)ShareBtn:(id)sender {
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
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

@end
