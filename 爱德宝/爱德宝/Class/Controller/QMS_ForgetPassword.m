//
//  QMS_ForgetPassword.m
//  CHISLIM
//
//  Created by XIUDeveloper on 2016/12/3.
//  Copyright © 2016年 XIU. All rights reserved.


#import "QMS_ForgetPassword.h"
#import "HTTPHandier.h"
#import "NSString+TextField.h"
#import "QMS_Message.h"
#import "HTTPHandier.h"
#import "MainPageViewController.h"
//#import "QMS_UserDefaultsInfromation.h"
@interface QMS_ForgetPassword ()
{
    NSInteger _count;
}
@property (weak, nonatomic) IBOutlet UITextField *PhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *VerificationCodeNum;
@property (weak, nonatomic) IBOutlet UIButton *GetVerficationBtn;
@property (weak, nonatomic) IBOutlet UIButton *NextBtn;
@property (weak, nonatomic) IBOutlet UITextField *firstPwd;
@property (weak, nonatomic) IBOutlet UITextField *secondPwd;
@property (weak, nonatomic) IBOutlet UIView *chinaView;
@property (nonatomic,strong) NSString *messageCode;
@end

@implementation QMS_ForgetPassword
- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *color = [UIColor whiteColor];
    _PhoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName: color}];
        _VerificationCodeNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: color}];
       _firstPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName: color}];
       _secondPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再输入一次" attributes:@{NSForegroundColorAttributeName: color}];
//       _VerificationCodeNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    //    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
    //    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
    
}
#pragma mark keyBoardChange
-(void)keyBoardChange:(NSNotification *)not{
    
    CGFloat keyboardEndY = [not.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
    CGFloat different;
    if (CGRectGetMaxY(self.NextBtn.frame)>keyboardEndY) {
        different = keyboardEndY- CGRectGetMaxY(self.NextBtn.frame);
    }else{
        different = 0;
    }
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = different;
        self.view.frame = frame;
    }];
    
}

- (void)setUp {

    self.NextBtn.layer.cornerRadius = 4;
    _NextBtn.layer.masksToBounds = YES;
#pragma mark  chinaView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chinaViewClick)];
    [self.chinaView addGestureRecognizer:tap];
    
}
-(void)chinaViewClick{
    NSLog(@"chinaViewClick");
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ChickedNextBtn:(id)sender {
    
    if (!self.PhoneNum.text.length) {
        [self alterMessage:@"手机号不能为空"];
        [self.PhoneNum becomeFirstResponder];
        return;
    }
    if (!self.firstPwd.text.length){
        [self alterMessage:@"密码不能为空"];
        [self.firstPwd becomeFirstResponder];
        return;
    }
    if (!self.secondPwd.text.length){
        [self alterMessage:@"确认密码不能为空"];
        [self.secondPwd becomeFirstResponder];
        return;
    }
    if (!self.VerificationCodeNum.text.length) {
        [self alterMessage:@"验证码不能为空"];
        [self.VerificationCodeNum becomeFirstResponder];
        return;
    }
    if (![self.firstPwd.text isEqualToString:self.secondPwd.text]) {
        [self alterMessage:@"确认密码和密码一样哦"];
        [self.firstPwd becomeFirstResponder];
        return;
    }
    if (![NSString valiMobile:self.PhoneNum.text]){
        [self alterMessage:@"请输入正确的手机号码"];
        [self.PhoneNum becomeFirstResponder];
        return;
    }
    
    //    NSLog(@"需要验证验证码");
    if (![self.VerificationCodeNum.text isEqualToString:self.messageCode]) {
        [self alterMessage:@"验证码不正确"];
        return;
    }
    
    [self request];
}
-(void)alterMessage:(NSString *)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"找回密码失败" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark---------------------------
#pragma mark chicked GetVerfication Button

- (IBAction)ChickedGetVerficationBtn:(id)sender {
    [self sendCode];
    NSString *code = [NSString stringWithFormat:@"%u%u%u%u%u%u",arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
    NSLog(@"%@", code);
    [QMS_Message messageHttpWithNumber:self.PhoneNum.text verification:code block:^(BOOL isOK) {
        if (isOK) {
            self.messageCode = code;
        }else{
            NSLog(@"自己去找bug");
        }
    }];
    
}

-(void)sendCode
{
    NSString *msg;
    if ([self.PhoneNum.text isEqualToString:@""]||(self.PhoneNum.text==NULL)) {
        msg =@"手机号码不能为空";
    }
    if (msg.length !=0) {
        UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }
    [self performSelector:@selector(countClick) withObject:nil];
}

-(void)countClick
{
    _GetVerficationBtn.enabled =NO;
    _count = 60;
    [_GetVerficationBtn setTitle:@"60秒" forState:UIControlStateDisabled];
    [_GetVerficationBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

-(void)timerFired:(NSTimer *)timer
{
    if (_count !=1) {
        _count -=1;
        [_GetVerficationBtn setTitle:[NSString stringWithFormat:@"%ld  秒",_count] forState:UIControlStateDisabled];
    }
    else
    {
        [timer invalidate];
        _GetVerficationBtn.enabled = YES;
        [_GetVerficationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
#pragma mark---------------------------

- (void)request {
    
    NSString *path = [NSString stringWithFormat:@"112.74.28.179:8080/adbs/userbeancontrol/updateuserbeanpass?userphone=%@&userpass=%@", self.PhoneNum.text, self.secondPwd.text];
    [HTTPHandier getDataByString:path WithBodyString:nil WithDataBlock:^(id responceObject) {
        [self HUDWithText:@"修改成功"];
        [self dissmissFirstResponder];
        [self landHTTPRequest];
    }];
}





- (void)dissmissFirstResponder {
    [self.PhoneNum resignFirstResponder];
    [self.VerificationCodeNum resignFirstResponder];
}


#pragma mark 登录网络请求
//http://localhost:8080/Weiaibenpao/UserServlet?dowhat=getOneByPhone&userPhone=11111111&userPass=11111111&channelId=7987998798
- (void)landHTTPRequest {
    NSString *path = [NSString stringWithFormat:@"%@loginByPhone?userphone=%@&userpass=%@",BASEURL, self.PhoneNum.text, self.secondPwd.text];
    
    [HTTPHandier getDataByString:path WithBodyString:nil WithDataBlock:^(id responceObject) {
        NSDictionary * obj = [[responceObject objectForKey:@"data"] objectForKey:@"user"];
        if (!obj) {
            [self HUDWithText:@"修改密码失败"];
            return;
        }
       [self saveDictionary:obj];
        NSString *userPhone = [obj objectForKey:@"userphone"];
        NSString *password = [obj objectForKey:@"userpass"];
        
        if ([self.PhoneNum.text isEqualToString:userPhone] && [self.secondPwd.text isEqualToString:password] ) {
            //登陆成功进入下一个界面
            
            [[NSUserDefaults standardUserDefaults]setObject:self.PhoneNum.text forKey:@"uid"];
            [self.view endEditing:NO];
            MainPageViewController *main = [[MainPageViewController alloc] init];
            [self.navigationController pushViewController:main animated:YES];
            
        }else {
            //登陆失败
            
            //            [_activity stopAnimating];
            [self showInfo:@"账号或密码输入错误"];
        }
        
    }];
}


- (void)saveDictionary:(NSDictionary *)dic {
    [XIU_Login doLogin:dic];
}

#pragma mark - public
-(void)showInfo:(NSString* )infoStr{
    
    UILabel* lbl = [[UILabel alloc]init];
    lbl.text = infoStr;
    lbl.font = [UIFont systemFontOfSize:10.f];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = [UIColor blackColor];
    lbl.frame = CGRectMake(0, 0, 150, 50);
    lbl.center = CGPointMake(KWIDTH/2, KHEIGHT/2);
    lbl.alpha = 0.0;
    
    [self.view addSubview:lbl];
    [UIView animateWithDuration:1.0 animations:^{
        lbl.alpha = 0.7;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            lbl.alpha = 0.0;
        } completion:^(BOOL finished) {
            [lbl removeFromSuperview];
            
        }];
        
    }];
}

@end
