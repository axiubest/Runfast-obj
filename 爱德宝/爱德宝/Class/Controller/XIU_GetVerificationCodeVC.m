//
//  XIU_GetVerificationCodeVC.m
//  BASEPRODUCT
//
//  Created by XIUDeveloper on 2017/1/7.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_GetVerificationCodeVC.h"
#import "MainPageViewController.h"
#import "QMS_Message.h"
static id _instance = nil;
@interface XIU_GetVerificationCodeVC ()
{
    NSInteger _count;
    NSTimer *_Timer;
    NSString *messageCode;
}
@property (nonatomic, weak)UITextField *VerificationField;

@property (nonatomic, weak)UITextField *PasswordField;



@property (nonatomic, weak)UIButton *nextButton;

@property (nonatomic, weak)UIButton *getVerificationNum;


@end

@implementation XIU_GetVerificationCodeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手机快速注册";
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    image.frame  =CGRectMake(0, 0, KWIDTH, KHEIGHT);
    [self.view addSubview:image];
    [self creatSubView];
//    [self getCode];
}

- (void)getCode {
    NSString *code = [NSString stringWithFormat:@"%u%u%u%u%u%u",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
    [QMS_Message messageHttpWithNumber:_PhoneNumberStr verification:code block:^(BOOL isOK) {
        if (isOK) {
            messageCode = code;
        }else{
            NSLog(@"自己去找bug");
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)creatSubView {
    UILabel *topLab = [[UILabel alloc] init];
    topLab.text = [NSString stringWithFormat:@"请输入%@收到的短信验证码", _PhoneNumberStr];
    topLab.textColor = [UIColor whiteColor];
    topLab.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:topLab];
    
    UITextField *VerificationField = [[UITextField alloc] init];
    VerificationField.placeholder = @"   请输入验证码";
    VerificationField.keyboardType = UIKeyboardTypePhonePad;
    VerificationField.backgroundColor = [UIColor whiteColor];
    [VerificationField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    VerificationField.clearButtonMode = 1;
    [SV addSubview:VerificationField];
    _VerificationField = VerificationField;
    
    UITextField *PasswordField = [[UITextField alloc] init];
    PasswordField.placeholder = @"   请输入密码";
    PasswordField.keyboardType = UIKeyboardTypePhonePad;
    PasswordField.backgroundColor = [UIColor whiteColor];
    [PasswordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    PasswordField.clearButtonMode = 1;
    [SV addSubview:PasswordField];
    _PasswordField = PasswordField;
    
    
    
    UIButton *getVerificationNum = [[UIButton alloc] init];
    [getVerificationNum setTitle:@"获取验证码" forState:UIControlStateNormal];
    getVerificationNum.titleLabel.font = [UIFont systemFontOfSize:15];
    getVerificationNum.tintColor = [UIColor whiteColor];
    getVerificationNum.backgroundColor = [UIColor lightGrayColor];
    [getVerificationNum addTarget:self action:@selector(chickedGetVerificationBtn:) forControlEvents:UIControlEventTouchUpInside];
    getVerificationNum.userInteractionEnabled = YES;
    [SV addSubview:getVerificationNum];
    _getVerificationNum = getVerificationNum;
    
    
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.enabled = NO;
    [nextButton setTintColor:[UIColor whiteColor]];
    [nextButton setBackgroundColor:[UIColor lightGrayColor]];
    [nextButton addTarget:self action:@selector(chickedNextButton) forControlEvents:UIControlEventTouchUpInside];
    [SV addSubview:nextButton];
    _nextButton = nextButton;
    _count = 60;
    nextButton.enabled = NO;
    _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];


    
    
    
//-----------masonry layout------------
    
    [topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(300, 15));
        make.top.offset(90);
        make.left.offset(20);
    }];
    
    [VerificationField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(LAND_CONTORL_HEIGHT);
        make.left.offset(20);
        make.top.equalTo(topLab.mas_bottom).with.offset(15);
        make.width.offset(KWIDTH / 2);
    }];

    [getVerificationNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(VerificationField.mas_right).with.offset(10);
        make.right.offset(-20);
        make.height.offset(LAND_CONTORL_HEIGHT);
        make.top.equalTo(VerificationField.mas_top);
    }];
    
    
    [PasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SV).with.offset(20);
        make.right.equalTo(SV).with.offset(-20);
        make.height.offset(LAND_CONTORL_HEIGHT);
        make.top.equalTo(getVerificationNum.mas_bottom).with.offset(30);
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SV).with.offset(20);
        make.right.equalTo(SV).with.offset(-20);
        make.height.offset(LAND_CONTORL_HEIGHT);
        make.top.equalTo(PasswordField.mas_bottom).with.offset(30);
        
    }];

}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (_PasswordField.text.length != 0 && _VerificationField.text.length != 0) {
        [self.nextButton setBackgroundColor:[UIColor redColor]];
        self.nextButton.enabled = YES;
        [self.nextButton setTintColor:[UIColor whiteColor]];
    }else {
    [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"#EEEEEE"]];
        [self.nextButton setTintColor:[UIColor grayColor]];
        self.nextButton.enabled = NO;
        
    }
}


#pragma mark 点击获取验证码按钮
- (void)chickedGetVerificationBtn:(UIButton *)sender{
    _count = 60;
    sender.enabled = NO;
    sender.backgroundColor = [UIColor lightGrayColor];
    sender.tintColor = [UIColor darkGrayColor];
   _Timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
 
}

-(void)timerFired:(NSTimer *)timer
{
    if (_count !=1) {
        _count -=1;
        [self.getVerificationNum setTitle:[NSString stringWithFormat:@"%ld  秒",_count] forState:UIControlStateNormal];
    }
    else
    {
        [timer invalidate];
        self.getVerificationNum.enabled = YES;
        [self.getVerificationNum setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self getCode];
        self.getVerificationNum.backgroundColor = [UIColor redColor];
        self.getVerificationNum.tintColor = [UIColor whiteColor];
        
    }
}

//下一步按钮
- (void)chickedNextButton {
    //验证码判断
//    if (![_VerificationField.text isEqualToString:messageCode]) {
//        [self HUDWithText:@"验证码输入错误"];
//        return;
//    }
    //网络请求
    [self request];
}

- (void)request {
    [[XIU_NetAPIManager sharedManager] request_ResignWithPhoneNumber:_PhoneNumberStr Psw:_PasswordField.text andBlock:^(id data, NSError *error) {
        if (data) {
            NSLog(@"%@", data);
            
            [XIU_Login doLogin:data];
            [self HUDWithText:@"注册成功"];

            [self pushViewControllerWithCcontroller:[[MainPageViewController alloc] init]];
            
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resignTableViewReloData" object:nil];
            
        }else {
            [self HUDWithText:@"注册失败"];
        }
    }];
}

-(void)dealloc {
    [self invaldateTimer];
}

- (void)invaldateTimer {
    [_Timer invalidate];
    _Timer = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self invaldateTimer];
}


@end
