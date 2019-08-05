//
//  RegisterViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/9.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "RegisterViewController.h"
#import "RDCountDownButton.h"
#import "MaxAuthCodeView.h"
#import "AgreementVC.h"
#import <YYText.h>

@interface RegisterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountText;

@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UIView *toolbg;

@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) UITextField *nameTextField;

@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UITextField *password1TextField;

@property (nonatomic, strong) UITextField *imageCodeTextField;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) RDCountDownButton *codeBtn;

@property (nonatomic, strong) MaxAuthCodeView *authcodeImage;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册-NZH";
    _area = @"新西兰+64";
    
    [self initUI];
}

- (void)initUI
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT, G_SCREEN_WIDTH, 63)];
    topView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 230, 33)];
    imageView.image = [UIImage imageNamed:@"login2"];
    [topView addSubview:imageView];
    
    
    _accountText = [[UITextField alloc] initWithFrame:CGRectMake(120, G_NAV_HEIGHT+100, G_SCREEN_WIDTH-150, 30)];
    _accountText.placeholder = @"手机号码是您的登录账号";
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
    
    NSArray *array = @[@"",@"昵称",@"密码",@"密码",@"短信验证码",@"短信验证码"];
    for (int i=0; i<6; i++)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+130+50*i, G_SCREEN_WIDTH-30, 1)];
        lineView.backgroundColor = LineColor;
        [self.view addSubview:lineView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, G_NAV_HEIGHT+108+50*i, 12, 14)];
        if (i>0)
        {
            imageView.image = [UIImage imageNamed:array[i]];
            [self.view addSubview:imageView];
        }
    }
    
    _nameTextField = [self textFieldWithIndex:1];
    _nameTextField.placeholder = @"昵称（长度不超过20）";
    
    _passwordTextField = [self textFieldWithIndex:2];
    _passwordTextField.placeholder = @"密码 （6-16位密码，区分大小写）";
    _passwordTextField.secureTextEntry = YES;
    
    _password1TextField = [self textFieldWithIndex:3];
    _password1TextField.placeholder = @"确认密码";
    _password1TextField.secureTextEntry = YES;
    
    _imageCodeTextField = [self textFieldWithIndex:4];
    _imageCodeTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _imageCodeTextField.placeholder = @"图片验证码";
    
    _codeTextField = [self textFieldWithIndex:5];
    _codeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _codeTextField.placeholder = @"短信验证码";
    
    _codeBtn = [[RDCountDownButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-90, G_NAV_HEIGHT+353, 75, 24)];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
    _codeBtn.enabled = NO;
    _codeBtn.layer.cornerRadius = 3;
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_codeBtn addTarget:self action:@selector(sendValidCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeBtn];
    
    self.authcodeImage = [[MaxAuthCodeView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, G_NAV_HEIGHT+300, 90, 30)];
    [self.view addSubview:self.authcodeImage];
    [self.authcodeImage getAuthcode];
    
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+420, G_SCREEN_WIDTH-30, 48)];
    registerBtn.backgroundColor = MainColor;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    registerBtn.layer.cornerRadius = 10;
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-60, G_NAV_HEIGHT+480, 45, 15)];
    [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorFromHexString:@"#98BAD8"] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginBtn];
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(20, G_NAV_HEIGHT+480, G_SCREEN_WIDTH-40, 40)];
    label.numberOfLines = 0;
    NSString *str = [NSString stringWithFormat:@"登录即表示您已阅读、理解并同意《注册协议》，若您不同意协议或政策，请勿进行后续操作！"];
//    label.text = str;
    NSMutableAttributedString *sss = [[NSMutableAttributedString alloc] initWithString:str];
//    [sss addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#4a7cdb"] range:NSMakeRange(15, 6)];
    [sss yy_setTextHighlightRange:NSMakeRange(15, 6) color:[UIColor colorFromHexString:@"#4a7cdb"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        AgreementVC *vc = [[AgreementVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    label.attributedText = sss;
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-80, G_NAV_HEIGHT+520, 60, 20)];
    [btn setTitle:@"去登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexString:@"#4a7cdb"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
    _accountText.text = @"";
    [_phoneBtn setTitle:_area forState:UIControlStateNormal];
    
}

- (void)cancelAction
{
    self.toolbg.hidden = YES;
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.toolbg.hidden = YES;
}


#pragma mark - 注册
- (void)registerAction
{
    if (_accountText.text.length <= 2)
    {
        [SVProgressHUD showErrorWithStatus:@"请确保手机号码无误"];
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
    
    if ([_accountText.text isEqualToString:@"11111111111"])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号格式错误"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (_nameTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (_passwordTextField.text.length <6 || _passwordTextField.text.length > 16)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入6-16位的密码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (![_passwordTextField.text isEqualToString:_password1TextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (![[_imageCodeTextField.text uppercaseString] isEqualToString:[self.authcodeImage.authCodeStr uppercaseString]])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的图形验证码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (_codeTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入短信验证码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
//    NSString *countryCode = [_area stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSArray *array = [_area componentsSeparatedByString:@"+"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_accountText.text forKey:@"phone"];
    [param setObject:array[1] forKey:@"countryCode"];
    [param setObject:_nameTextField.text forKey:@"fullName"];
    [param setObject:_passwordTextField.text forKey:@"password"];
    [param setObject:_codeTextField.text forKey:@"code"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/register" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [SVProgressHUD dismissWithDelay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.label.text = result[@"message"];
                [hud1 hideAnimated:YES afterDelay:1.2];
                
            });
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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


- (UITextField *)textFieldWithIndex:(int)index
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(40, G_NAV_HEIGHT+100+50*index, G_SCREEN_WIDTH-55, 30)];
    textField.textColor = TextColor;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = self;
    textField.tag = 100+index;
    [self.view addSubview:textField];
    return textField;
}

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
    
    
    if (![[_imageCodeTextField.text uppercaseString] isEqualToString:[self.authcodeImage.authCodeStr uppercaseString]])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的图形验证码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
   
    
    NSArray *array = [_area componentsSeparatedByString:@"+"];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_accountText.text forKey:@"phone"];
    [param setObject:array[1] forKey:@"code"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/sendVerCode" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
             _codeBtn.enabled = NO;
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [SVProgressHUD dismissWithDelay:1];
            [_codeTextField resignFirstResponder];
            
            [weakSelf.codeBtn startCountDownWithSecond:60];
//            [weakSelf.codeBtn setTitleColor:MainColor forState:UIControlStateNormal];
            weakSelf.codeBtn.backgroundColor = MainColor;
            [weakSelf.codeBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"%zds重新获取",second];
                return title;
            }];
            [weakSelf.codeBtn countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
                weakSelf.codeBtn.enabled = YES;
//                [weakSelf.codeBtn setTitleColor:TextColor forState:UIControlStateNormal];
                weakSelf.codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
                return @"获取验证码";
                
            }];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.label.text = result[@"message"];
                [hud1 hideAnimated:YES afterDelay:1.2];
                
            });
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
   
}

- (void)loginAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
