//
//  ForgetViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/9.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ForgetViewController.h"
#import "RDCountDownButton.h"
#import "FindPasswordViewController.h"

@interface ForgetViewController () <UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UITextField *accountText;

@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) RDCountDownButton *codeBtn;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIView *toolbg;

@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UITextField *passwordTextField1;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    _area = @"新西兰+64";
    [self initUI];
}

- (void)initUI
{
    _accountText = [[UITextField alloc] initWithFrame:CGRectMake(120, G_NAV_HEIGHT+100, G_SCREEN_WIDTH-150, 30)];
    _accountText.placeholder = @"手机号";
    _accountText.font = [UIFont systemFontOfSize:13];
    _accountText.leftViewMode = UITextFieldViewModeAlways;
    _accountText.keyboardType = UIKeyboardTypePhonePad;
    _accountText.delegate = self;
    [_accountText addTarget:self action:@selector(phoneInput) forControlEvents:UIControlEventEditingChanged];
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5.5, 10, 16)];
    phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
    phoneImageView.image = [UIImage imageNamed:@"手机"];
    [phoneView addSubview:phoneImageView];
    _accountText.leftView = phoneView;
    [self.view addSubview:_accountText];
    
    _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+100, 100, 30)];
    [_phoneBtn setTitle:@"新西兰+64" forState:UIControlStateNormal];
    [_phoneBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(changeArea) forControlEvents:UIControlEventTouchUpInside];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_phoneBtn];
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+150, G_SCREEN_WIDTH-30, 30)];
    _codeTextField.placeholder = @"手机验证码";
    _codeTextField.font = [UIFont systemFontOfSize:13];
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    [_codeTextField addTarget:self action:@selector(zzz) forControlEvents:UIControlEventEditingChanged];
    UIView *mimaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *mimaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 12, 14)];
    mimaImageView.image = [UIImage imageNamed:@"验证码"];
    mimaImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mimaView addSubview:mimaImageView];
    _codeTextField.leftView = mimaView;
    [self.view addSubview:_codeTextField];
    
    _codeBtn = [[RDCountDownButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-90, G_NAV_HEIGHT+153, 75, 24)];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
    _codeBtn.enabled = NO;
    _codeBtn.layer.cornerRadius = 3;
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_codeBtn addTarget:self action:@selector(sendValidCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+130, G_SCREEN_WIDTH-30, 1)];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+180, G_SCREEN_WIDTH-30, 1)];
    lineView1.backgroundColor = LineColor;
    [self.view addSubview:lineView1];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT, G_SCREEN_WIDTH, 50)];
    topView.backgroundColor = [UIColor colorFromHexString:@"#FFFDF0"];
    [self.view addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 16, 16)];
    imageView.image = [UIImage imageNamed:@"笑脸"];
    [topView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 200, 20)];
    label.text = @"请重置密码并妥善保管";
    label.textColor = TitleColor;
    label.font = [UIFont systemFontOfSize:12];
    [topView addSubview:label];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, G_NAV_HEIGHT+208, 12, 14)];
    imageView2.image = [UIImage imageNamed:@"密码"];
    [self.view addSubview:imageView2];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, G_NAV_HEIGHT+258, 12, 14)];
    imageView1.image = [UIImage imageNamed:@"密码"];
    [self.view addSubview:imageView1];
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(40, G_NAV_HEIGHT+200, G_SCREEN_WIDTH-55, 30)];
    _passwordText.placeholder = @"密码（6-16位密码，区分大小写）";
    _passwordText.secureTextEntry = YES;
    _passwordText.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_passwordText];
    
    _passwordTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(40, G_NAV_HEIGHT+250, G_SCREEN_WIDTH-55, 30)];
    _passwordTextField1.placeholder = @"再次输入密码";
    _passwordTextField1.secureTextEntry = YES;
    _passwordTextField1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_passwordTextField1];
    
    UIView *lineView11 = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+230, G_SCREEN_WIDTH-30, 1)];
    lineView11.backgroundColor = LineColor;
    [self.view addSubview:lineView11];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+280, G_SCREEN_WIDTH-30, 1)];
    lineView2.backgroundColor = LineColor;
    [self.view addSubview:lineView2];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+300, G_SCREEN_WIDTH-30, 48)];
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sureBtn.backgroundColor = MainColor;
    sureBtn.layer.cornerRadius = 10;
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (void)sendValidCode
{
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
    
    [_codeTextField becomeFirstResponder];
    
    
    MJWeakSelf;
    
    NSArray *array = [_area componentsSeparatedByString:@"+"];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:_accountText.text forKey:@"phone"];
    
    [param setObject:array[1] forKey:@"code"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/sendPwdCode" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            _codeBtn.enabled = NO;
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [SVProgressHUD dismissWithDelay:1];
            
            [weakSelf.codeBtn startCountDownWithSecond:60];
            weakSelf.codeBtn.backgroundColor = MainColor;
            [weakSelf.codeBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"%zds重新获取",second];
                return title;
            }];
            [weakSelf.codeBtn countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
                weakSelf.codeBtn.enabled = YES;
                weakSelf.codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
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

- (void)phoneInput
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

- (void)zzz
{
    if (_accountText.text.length > 0 && _codeTextField.text.length >0)
    {
        _nextBtn.backgroundColor = MainColor;
        _nextBtn.enabled = YES;
    }
    
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
            [obj resignFirstResponder];
        }
    }];
    
    self.toolbg.hidden = NO;
}

- (void)doneAction
{
    self.toolbg.hidden = YES;
    _accountText.text = @"";
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
    _area = array[row];
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


- (void)nextAction
{
    
    
    FindPasswordViewController *vc = [[FindPasswordViewController alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:_accountText.text forKey:@"phone"];
    [dic setObject:_codeTextField.text forKey:@"code"];
    vc.param = dic;
    [self.navigationController pushViewController:vc animated:NO];
    
}

- (void)sureAction
{
    NSMutableDictionary *param2 = [[NSMutableDictionary alloc] init];
    if(_accountText.text.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        [SVProgressHUD dismissWithDelay:1.3];
        return;
    }
    if(_codeTextField.text.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        [SVProgressHUD dismissWithDelay:1.3];
        return;
    }
    if (_passwordText.text.length <= 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
        [SVProgressHUD dismissWithDelay:1.3];
        return;
    }
    
    if (_passwordText.text.length >= 6 && _passwordText.text.length <= 16 && [_passwordText.text isEqualToString:_passwordTextField1.text])
    {
        [param2 setObject:_passwordText.text forKey:@"newPassword"];
    }
    else if (_passwordText.text.length < 6 || _passwordTextField1.text.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码长度不能少于6位"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else if (_passwordText.text.length > 16 || _passwordTextField1.text.length > 16)
    {
        [SVProgressHUD showErrorWithStatus:@"密码长度不能多于16位"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else if (![_passwordText.text isEqualToString:_passwordTextField1.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    [param2 setObject:_accountText.text forKey:@"phone"];
    [param2 setObject:_codeTextField.text forKey:@"code"];
    
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/resetPwd" parameters:param2 success:^(NSURLSessionDataTask *task, id result) {
        
        
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.label.text = result[@"密码重置成功"];
                [hud1 hideAnimated:YES afterDelay:1.2];
                
                for (UIViewController *vc in self.navigationController.viewControllers)
                {
                    if ([vc isKindOfClass:[LoginViewController class]])
                    {
                        LoginViewController *loginVC = (LoginViewController *)vc;
                        [self.navigationController popToViewController:loginVC animated:YES];
                    }
                }
                
                [self.navigationController popToViewController:[[LoginViewController alloc] init] animated:YES];
                
            });
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    if (textField==_accountText) {
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
