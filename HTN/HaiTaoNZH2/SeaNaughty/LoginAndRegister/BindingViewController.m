//
//  BindingViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/12.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "BindingViewController.h"
#import <Masonry.h>
#import "RDCountDownButton.h"
#import "SetPasswordViewController.h"
#import <JPUSHService.h>

@interface BindingViewController ()

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *namelabel;

@property (nonatomic, strong) UITextField *accountText;

@property (nonatomic, strong) UIButton *phoneBtn;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) RDCountDownButton *codeBtn;
@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UIView *toolbg;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageUrl;



@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定账号";
    _area = @"新西兰+64";
    _param = [[NSMutableDictionary alloc] init];
    [_param setObject:self.unionid forKey:@"unionId"];
    [self initUI];
    
    [self getUserInfo];
}

- (void)initUI
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT, G_SCREEN_WIDTH, 63)];
    topView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 230, 33)];
    imageView.image = [UIImage imageNamed:@"login2"];
    [topView addSubview:imageView];
    
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+63, G_SCREEN_WIDTH, 200)];
    bgView.image = [UIImage imageNamed:@"bg_person"];
    [self.view addSubview:bgView];
    
    _headerView = [[UIImageView alloc] init];
    [bgView addSubview:_headerView];
    _headerView.layer.cornerRadius = 40;
    _headerView.clipsToBounds = YES;
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerX.equalTo(bgView);
        make.top.mas_equalTo(30);
    }];
    
    _namelabel = [[UILabel alloc] init];
    [bgView addSubview:_namelabel];
    _namelabel.textColor = TitleColor;
    _namelabel.font = [UIFont systemFontOfSize:14];
    _namelabel.numberOfLines = 0;
    _namelabel.textAlignment = NSTextAlignmentCenter;
    [_namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.equalTo(bgView.mas_right).offset(-15);
        make.top.equalTo(_headerView.mas_bottom).offset(15);
        make.height.equalTo(@45);
    }];
    
    
    _accountText = [[UITextField alloc] initWithFrame:CGRectMake(120, G_NAV_HEIGHT+280, G_SCREEN_WIDTH-150, 30)];
    _accountText.placeholder = @"手机号";
    _accountText.font = [UIFont systemFontOfSize:13];
    _accountText.leftViewMode = UITextFieldViewModeAlways;
    _accountText.keyboardType = UIKeyboardTypePhonePad;
    [_accountText addTarget:self action:@selector(phoneInput) forControlEvents:UIControlEventEditingChanged];
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5.5, 10, 16)];
    phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
    phoneImageView.image = [UIImage imageNamed:@"手机"];
    [phoneView addSubview:phoneImageView];
    _accountText.leftView = phoneView;
    [self.view addSubview:_accountText];
    
    _phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+280, 100, 30)];
    [_phoneBtn setTitle:@"新西兰+64" forState:UIControlStateNormal];
    [_phoneBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
    [_phoneBtn addTarget:self action:@selector(changeArea) forControlEvents:UIControlEventTouchUpInside];
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_phoneBtn];
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+330, G_SCREEN_WIDTH-30, 30)];
    _codeTextField.placeholder = @"手机验证码";
    _codeTextField.font = [UIFont systemFontOfSize:13];
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    UIView *mimaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *mimaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 12, 14)];
    mimaImageView.image = [UIImage imageNamed:@"验证码"];
    mimaImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mimaView addSubview:mimaImageView];
    _codeTextField.leftView = mimaView;
    [self.view addSubview:_codeTextField];
    
    _codeBtn = [[RDCountDownButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-90, G_NAV_HEIGHT+333, 75, 24)];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
    _codeBtn.enabled = NO;
    _codeBtn.layer.cornerRadius = 3;
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_codeBtn addTarget:self action:@selector(sendValidCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_codeBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+310, G_SCREEN_WIDTH-30, 1)];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+360, G_SCREEN_WIDTH-30, 1)];
    lineView1.backgroundColor = LineColor;
    [self.view addSubview:lineView1];
    
    _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+400, G_SCREEN_WIDTH-30, 45)];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextBtn.layer.cornerRadius = 8;
    //    _nextBtn.enabled = NO;
    _nextBtn.backgroundColor = MainColor;
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
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

- (void)sendValidCode
{
    if (_accountText.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [_codeTextField becomeFirstResponder];
    
    
    MJWeakSelf;
    
    NSArray *array = [_area componentsSeparatedByString:@"+"];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:_accountText.text forKey:@"phone"];
    
    [param setObject:array[1] forKey:@"code"];
    
    
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/sendSignInCode" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
             _codeBtn.enabled = NO;
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [SVProgressHUD dismissWithDelay:1];
            
            [weakSelf.codeBtn startCountDownWithSecond:60];
            weakSelf.codeBtn.backgroundColor = MainColor;
//            [weakSelf.codeBtn setTitleColor:MainColor forState:UIControlStateNormal];
            [weakSelf.codeBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
                NSString *title = [NSString stringWithFormat:@"%zds重新获取",second];
                return title;
            }];
            [weakSelf.codeBtn countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
                weakSelf.codeBtn.enabled = YES;
                weakSelf.codeBtn.backgroundColor = [UIColor colorFromHexString:@"#CECECE"];
//                [weakSelf.codeBtn setTitleColor:TextColor forState:UIControlStateNormal];
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
            [obj resignFirstResponder];
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
    
    [_param setObject:array[1] forKey:@"countryCode"];
    [_param setObject:_codeTextField.text forKey:@"code"];
    
    SetPasswordViewController *vc = [[SetPasswordViewController alloc] init];
    vc.param = _param;
    vc.url = _imageUrl;
    vc.name = _name;
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/signIn" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        
        if([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *dic = result[@"data"];
            if ([dic.allKeys containsObject:@"isNewCustomer"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:vc animated:YES];
                });
            }
            else
            {
                [self bindWechat:dic[@"id"]];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                NSNumber *customerIdNum = result[@"data"][@"id"];
                NSString *customerId = [NSString stringWithFormat:@"%@", customerIdNum];
                NSString *fullName = result[@"data"][@"fullName"];
                NSString *monthlyStatement = [result[@"data"][@"monthlyStatement"] stringValue];
                [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
                [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"fullName"];
                [[NSUserDefaults standardUserDefaults] setObject:_accountText.text forKey:@"loginName"];
                [[NSUserDefaults standardUserDefaults] setObject:monthlyStatement forKey:@"monthlyStatement"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReload" object:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                [JPUSHService setAlias:customerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                    NSLog(@"%@", iAlias);
                    
                } seq:1];
                
            }

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
   
    
}


- (void)bindWechat:(NSString *)customerId
{
//    { "customerId":1017709, "unionId":"o8wwit1ZK_qxthl4GAeoGkat7mRg", "company":"NZH", "action":"bind" }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:customerId forKey:@"customerId"];
    [param setObject:@"bind" forKey:@"action"];
    [param setObject:_unionid forKey:@"unionId"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/bind" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        if([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


- (void)getUserInfo
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.access_token, self.openid];
    [AppService requestHTTPMethod:@"get" URL:urlString parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        _name = result[@"nickname"];
        _imageUrl = result[@"headimgurl"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_headerView sd_setImageWithURL:[NSURL URLWithString:result[@"headimgurl"]]];
            _namelabel.text = [NSString stringWithFormat:@"Hi,%@,欢迎登录NZH\n请验证您的手机(本操作只需进行一次)", result[@"nickname"]];
        });

//        [_param setObject:result[@"openid"] forKey:@"openid"];
        [_param setObject:result[@"headimgurl"] forKey:@"avatarUrl"];
        [_param setObject:result[@"nickname"] forKey:@"fullName"];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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

@end
