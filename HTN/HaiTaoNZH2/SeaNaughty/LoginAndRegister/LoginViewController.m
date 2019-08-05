//
//  LoginViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/9.
//  Copyright © 2018年 chilezzz. All rights reserved.
//


#import "LLSegmentBar.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "RDCountDownButton.h"
#import "WXApi.h"
#import "BindingViewController.h"
#import "AgreementVC.h"
#import "SetPasswordViewController.h"
#import "QYSDK.h"
#import <JPUSHService.h>

@interface LoginViewController () <LLSegmentBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,WXApiDelegate>

@property (nonatomic, strong) LLSegmentBar *bar;
@property (nonatomic, strong) UITextField *accountText;
@property (nonatomic, strong) UITextField *passwordText;

@property (nonatomic, strong) UIView *passwordView1;
@property (nonatomic, strong) UIView *passwordView2;
@property (nonatomic, strong) RDCountDownButton *codeBtn;

@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UIView *toolbg;

@property (nonatomic, strong) NSString *area;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录-NZH";
    self.view.backgroundColor = [UIColor whiteColor];
    _area = @"新西兰+64";
    [self initUI];
    
    if (self.needShowPop)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"NeedShowPop"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NeedShowPop"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatAction:) name:@"WECHAT" object:nil];
    
}

- (void)initUI
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, G_STATUSBAR_HEIGHT+44, G_SCREEN_WIDTH, 63)];
    topView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 230, 33)];
    imageView.image = [UIImage imageNamed:@"login2"];
    [topView addSubview:imageView];
    
    _bar = [[LLSegmentBar alloc] initWithFrame:CGRectMake(0, G_STATUSBAR_HEIGHT+130, G_SCREEN_WIDTH, 40)];
    _bar.items = @[@"账号密码登录",@"短信验证登录"];
    [_bar updateWithConfig:^(LLSegmentBarConfig *config) {
        config.itemNC = TextColor;
        config.itemSC = MainColor;
        config.indicatorC = MainColor;
        config.indicatorW = 40;
    }];
    _bar.selectIndex = 0;
    _bar.delegate = self;
    [self.view addSubview:_bar];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, G_STATUSBAR_HEIGHT+170, G_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    
    _accountText = [[UITextField alloc] initWithFrame:CGRectMake(15, G_STATUSBAR_HEIGHT+200, G_SCREEN_WIDTH-30, 30)];
    _accountText.placeholder = @"账号";
    _accountText.delegate = self;
    _accountText.font = [UIFont systemFontOfSize:13];
    _accountText.leftViewMode = UITextFieldViewModeAlways;
    [_accountText addTarget:self action:@selector(phoneInput) forControlEvents:UIControlEventEditingChanged];
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5.5, 10, 16)];
    phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
    phoneImageView.image = [UIImage imageNamed:@"手机"];
    [phoneView addSubview:phoneImageView];
    _accountText.leftView = phoneView;
    [self.view addSubview:_accountText];
    
    [_accountText becomeFirstResponder];
    
    _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_STATUSBAR_HEIGHT+200, 100, 30)];
    _phoneBtn.hidden = YES;
    [_phoneBtn setTitle:@"新西兰+64" forState:UIControlStateNormal];
    [_phoneBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(changeArea) forControlEvents:UIControlEventTouchUpInside];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_phoneBtn];
    
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(15, G_STATUSBAR_HEIGHT+250, G_SCREEN_WIDTH-30, 30)];
    _passwordText.placeholder = @"密码";
    _passwordText.secureTextEntry = YES;
    _passwordText.delegate = self;
    _passwordText.font = [UIFont systemFontOfSize:13];
    _passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    _passwordView1 = [self leftViewWithImageName:@"密码"];
    _passwordText.leftView = _passwordView1;
    
    _passwordView2 = [self leftViewWithImageName:@"验证码"];
    
    [self.view addSubview:_passwordText];
    
    
    _codeBtn = [[RDCountDownButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-90, G_STATUSBAR_HEIGHT+253, 75, 24)];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
    _codeBtn.enabled = NO;
    _codeBtn.layer.cornerRadius = 3;
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_codeBtn addTarget:self action:@selector(sendValidCode) forControlEvents:UIControlEventTouchUpInside];
    _codeBtn.hidden = YES;
    [self.view addSubview:_codeBtn];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, G_STATUSBAR_HEIGHT+230, G_SCREEN_WIDTH-30, 1)];
    lineView1.backgroundColor = LineColor;
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, G_STATUSBAR_HEIGHT+280, G_SCREEN_WIDTH-30, 1)];
    lineView2.backgroundColor = LineColor;
    [self.view addSubview:lineView2];
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_STATUSBAR_HEIGHT+300, 80, 20)];
    [registerBtn setTitle:@"手机快速注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor colorFromHexString:@"#98BAD8"] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registerBtn addTarget:self action:@selector(goToRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-75, G_STATUSBAR_HEIGHT+300, 60, 20)];
    forgetBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor colorFromHexString:@"#98BAD8"] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn addTarget:self action:@selector(goToForget) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_STATUSBAR_HEIGHT+360, G_SCREEN_WIDTH-30, 45)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 8;
    loginBtn.backgroundColor = MainColor;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
//    if ([WXApi isWXAppInstalled])
//    {
//        
//        UILabel *sanfangLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-140, G_SCREEN_WIDTH, 15)];
//        sanfangLabel.text = @"- 第三方登录 -";
//        sanfangLabel.textAlignment = NSTextAlignmentCenter;
//        sanfangLabel.font = [UIFont systemFontOfSize:11];
//        sanfangLabel.textColor = LightGrayColor;
//        [self.view addSubview:sanfangLabel];
//        
//        UIButton *wxBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-24, G_SCREEN_HEIGHT-100, 48, 48)];
//        [wxBtn setBackgroundImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
//        [wxBtn addTarget:self action:@selector(goToWX) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:wxBtn];
//    }
    
    
}

- (void)phoneInput
{
    if (_bar.selectIndex == 1)
    {
        if ([_area containsString:@"86"])
        {
            if (_accountText.text.length > 0 && [[_accountText.text substringToIndex:1] isEqualToString:@"1"])
            {
                _codeBtn.enabled = YES;
                _codeBtn.backgroundColor = MainColor;
                [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else
            {
                _codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
                _codeBtn.enabled = NO;
                [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }
        else
        {
            if (_accountText.text.length > 0)
            {
                _codeBtn.enabled = YES;
                _codeBtn.backgroundColor = MainColor;
                [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else
            {
                _codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
                _codeBtn.enabled = NO;
                [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    
    [_accountText resignFirstResponder];
    
    if (toIndex != fromIndex)
    {
        if (toIndex == 0)
        {
            _passwordText.leftView = _passwordView1;
            _passwordText.placeholder = @"密码";
            _codeBtn.hidden = YES;
            _phoneBtn.hidden = YES;
            _accountText.frame = CGRectMake(15, G_STATUSBAR_HEIGHT+200, G_SCREEN_WIDTH-30, 30);
            _passwordText.secureTextEntry = YES;
            _passwordText.keyboardType = UIKeyboardTypeNamePhonePad;
            _accountText.placeholder = @"账号";
            _accountText.keyboardType = UIKeyboardTypeNamePhonePad;
            _accountText.text = @"";
            _passwordText.text = @"";
            [_accountText becomeFirstResponder];
        }
        else if (toIndex == 1)
        {
            _passwordText.leftView = _passwordView2;
            _passwordText.placeholder = @"验证码";
            _codeBtn.hidden = NO;
            _phoneBtn.hidden = NO;
            _accountText.frame = CGRectMake(120, G_STATUSBAR_HEIGHT+200, G_SCREEN_WIDTH-130, 30);
            _passwordText.secureTextEntry = NO;
            _passwordText.keyboardType = UIKeyboardTypeDecimalPad;
            _accountText.keyboardType = UIKeyboardTypeDecimalPad;
            _accountText.placeholder = @"手机号";
            _accountText.text = @"";
            _passwordText.text = @"";
            [_accountText becomeFirstResponder];
        }
    }
}

#pragma mark - 登录
- (void)loginAction
{    
    MJWeakSelf;
    
    
   
    NSArray *array = [_area componentsSeparatedByString:@"+"];
    
    BOOL loginByPassword = NO;
    
    if (_accountText.text.length>0&&_passwordText.text.length>0)
    {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        
        
        NSString *zzz = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
        
        NSString *url = [NSString stringWithFormat:@"%@/user/handleLogin",zzz];
        
        
        if (_bar.selectIndex == 0)
        {
            [param setObject:_accountText.text forKey:@"accountVal"];
            [param setObject:_passwordText.text forKey:@"passwordVal"];
            
            loginByPassword = YES;
            
        }
        else
        {
            
//            url = @"/webapi/customer/signIn";
            url = [NSString stringWithFormat:@"%@/user/handleLoginByPhoneCode",zzz];
            [param setObject:_accountText.text forKey:@"phone"];
            [param setObject:_passwordText.text forKey:@"code"];
            [param setObject:array[1] forKey:@"countryCode"];
            [param setObject:@"app" forKey:@"deviceType"];
            loginByPassword = NO;
        }
        
        [AppService requestHTTPMethod:@"post" URL:url parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                NSDictionary *dataDic = result[@"data"];
                if ([dataDic.allKeys containsObject:@"isNewCustomer"])
                {
                    SetPasswordViewController *vc = [[SetPasswordViewController alloc] init];
                    vc.param = param;
                    vc.url = @"";
                    vc.name = @"小主";
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    NSNumber *customerIdNum = result[@"data"][@"id"];
                    NSString *customerId = [NSString stringWithFormat:@"%@", customerIdNum];
                    NSString *fullName = result[@"data"][@"fullName"];
                    NSString *sessionId = result[@"sessionId"];
                    
                    NSString *monthlyStatement = [result[@"data"][@"monthlyStatement"] stringValue];
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                    [SVProgressHUD dismissWithDelay:1.0];
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
                    [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"fullName"];
                    [[NSUserDefaults standardUserDefaults] setObject:weakSelf.accountText.text forKey:@"loginName"];
                    [[NSUserDefaults standardUserDefaults] setObject:monthlyStatement forKey:@"monthlyStatement"];
                    [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:@"sessionId"];
                    
                    [JPUSHService setAlias:customerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                        
                        NSLog(@"%@", iAlias);
                        
                    } seq:1];
                    
                    if ([[dataDic valueForKey:@"avatarUrl"] isKindOfClass:[NSString class]])
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[dataDic valueForKey:@"avatarUrl"] forKey:@"avatarUrl"];
                    }
                    else
                        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"avatarUrl"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReload" object:nil];
                }
                
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud1.mode = MBProgressHUDModeText;
                    hud1.detailsLabel.text = result[@"message"];
                    [hud1 hideAnimated:YES afterDelay:1.2];
                });
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.detailsLabel.text = @"登录失败";
                [hud1 hideAnimated:YES afterDelay:1.2];
            });
            
        }];
    }
    else
    {
        return;
    }
}

#pragma mark - 注册
- (void)goToRegister
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 忘记密码
- (void)goToForget
{
    ForgetViewController *vc = [[ForgetViewController alloc] init];
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 跳转微信
- (void)goToWX
{

//    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
        
//    }
//    else {
//        [self setupAlertController];
//    }
}


- (void)wechatAction:(NSNotification *)notification
{
    NSDictionary *wechatDic = notification.object;
    
    
    NSLog(@"wechatDic = %@", wechatDic);
    
    if (![wechatDic.allKeys containsObject:@"unionid"])
    {
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:wechatDic[@"unionid"] forKey:@"unionId"];
    
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/getInfoByOpenId" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
      
        
        NSDictionary *temp = result[@"data"];
        
        
        if (temp.allKeys.count==0)
        {
            BindingViewController *vc = [[BindingViewController alloc] init];
            vc.access_token = wechatDic[@"access_token"];
            vc.openid = wechatDic[@"openid"];
            vc.unionid = wechatDic[@"unionid"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
            [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
            [SVProgressHUD dismissWithDelay:1.0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            NSNumber *customerIdNum = result[@"data"][@"id"];
            NSString *customerId = [NSString stringWithFormat:@"%@", customerIdNum];
            NSString *fullName = result[@"data"][@"fullName"];
            
            [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
            [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"fullName"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.accountText.text forKey:@"loginName"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReload" object:nil];
            [JPUSHService setAlias:customerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                
                NSLog(@"%@", iAlias);
                
            } seq:1];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];
    
}



#pragma mark - 设置弹出提示语
- (void)setupAlertController {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 获取验证码
- (void)sendValidCode
{

    MJWeakSelf;

    if (_accountText.text.length < 2)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入完整手机号码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    NSString *temp = [_accountText.text substringWithRange:NSMakeRange(0, 2)];
    if ([_area containsString:@"64"] && ![temp isEqualToString:@"02"])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入以02开头的完整号码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else if ([_area containsString:@"61"] && ![temp isEqualToString:@"04"])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入以04开头的完整号码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else if ([_area containsString:@"86"] && _accountText.text.length != 11)
    {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    
    NSArray *array = [_area componentsSeparatedByString:@"+"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_accountText.text forKey:@"phone"];
    [param setObject:array[1] forKey:@"code"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/sendSignInCode" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            _codeBtn.enabled = NO;
            MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud1.mode = MBProgressHUDModeText;
            hud1.label.text = @"发送成功";
            [hud1 hideAnimated:YES afterDelay:1.2];
            
            [_passwordText resignFirstResponder];
            
            [weakSelf.codeBtn startCountDownWithSecond:60];
            _codeBtn.backgroundColor =[UIColor colorFromHexString:@"#CECECE"];
            [weakSelf.codeBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"%zds重新获取",second];
                return title;
            }];
            [weakSelf.codeBtn countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
                weakSelf.codeBtn.enabled = YES;
                _codeBtn.backgroundColor =MainColor;
                return @"获取验证码";
            }];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{

                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.detailsLabel.text = result[@"message"];
                [hud1 hideAnimated:YES afterDelay:1.2];

            });
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}


#pragma mark - 改变区号
- (void)changeArea
{
    _codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
    _codeBtn.enabled = NO;
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]])
        {
            UITextField *text = obj;
            [text resignFirstResponder];
        }
    }];
    
    self.toolbg.hidden = NO;
}

- (void)doneAction
{
    self.toolbg.hidden = YES;
    
    [_phoneBtn setTitle:_area forState:UIControlStateNormal];
    
}

- (void)cancelAction
{
    self.toolbg.hidden = YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *arrray = @[@"新西兰+64",@"中国+86",@"澳大利亚+61"];
    
    return arrray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *array = @[@"新西兰+64",@"中国+86",@"澳大利亚+61"];
    self.accountText.text = @"";
    _area = array[row];
}

- (UIView *)leftViewWithImageName:(NSString *)imageName
{
    UIView *mimaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *mimaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 12, 14)];
    mimaImageView.image = [UIImage imageNamed:imageName];
    mimaImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mimaView addSubview:mimaImageView];
    
    return mimaView;
}

- (UIView *)toolbg
{
    if (!_toolbg)
    {
        _toolbg = [[UIView alloc]initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-192, G_SCREEN_WIDTH,192)];
        _toolbg.backgroundColor = [UIColor whiteColor];
        _toolbg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        doneBtn.frame = CGRectMake(G_SCREEN_WIDTH - 60, 0, 60, 30);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor colorWithRed:52/255.0f green:129/255.0f blue:196/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        doneBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame = CGRectMake(0, 0, 60, 30);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:52/255.0f green:129/255.0f blue:196/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        
        [_toolbg addSubview:cancelBtn];
        [_toolbg addSubview:doneBtn];
        
        UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, G_SCREEN_WIDTH, 172)];
        pickView.delegate = self;
        pickView.dataSource = self;
        pickView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_toolbg addSubview:pickView];
        
        [self.view addSubview:_toolbg];
    }
    return _toolbg;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.toolbg.hidden = YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==_accountText && _bar.selectIndex == 1) {
        return [self validateNumber:string];
    }
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
@end
