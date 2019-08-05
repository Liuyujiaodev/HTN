//
//  SetPasswordViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/12.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "SetPasswordViewController.h"
#import <Masonry.h>
#import <JPUSHService.h>

@interface SetPasswordViewController ()

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel *namelabel;

@property (nonatomic, strong) UITextField *accountText;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_url] placeholderImage:[UIImage imageNamed:@"tempHeader"]];
    
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
    
     _namelabel.text = [NSString stringWithFormat:@"Hi,%@,欢迎登录NZH\n请设置您的密码", _name];
    
    _accountText = [[UITextField alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+280, G_SCREEN_WIDTH-30, 30)];
    _accountText.placeholder = @"输入密码，长度不能少于6位";
    _accountText.font = [UIFont systemFontOfSize:13];
    _accountText.leftViewMode = UITextFieldViewModeAlways;
    _accountText.secureTextEntry = YES;
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5.5, 10, 16)];
    phoneImageView.contentMode = UIViewContentModeScaleAspectFit;
    phoneImageView.image = [UIImage imageNamed:@"密码"];
    [phoneView addSubview:phoneImageView];
    _accountText.leftView = phoneView;
    [self.view addSubview:_accountText];
    
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+330, G_SCREEN_WIDTH-30, 30)];
    _codeTextField.placeholder = @"再次输入密码";
    _codeTextField.font = [UIFont systemFontOfSize:13];
    _codeTextField.secureTextEntry = YES;
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *mimaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    UIImageView *mimaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 12, 14)];
    mimaImageView.image = [UIImage imageNamed:@"密码"];
    mimaImageView.contentMode = UIViewContentModeScaleAspectFit;
    [mimaView addSubview:mimaImageView];
    _codeTextField.leftView = mimaView;
    [self.view addSubview:_codeTextField];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+310, G_SCREEN_WIDTH-30, 1)];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+360, G_SCREEN_WIDTH-30, 1)];
    lineView1.backgroundColor = LineColor;
    [self.view addSubview:lineView1];
    
    _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+400, G_SCREEN_WIDTH-30, 45)];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    _nextBtn.layer.cornerRadius = 8;
    //    _nextBtn.enabled = NO;
    _nextBtn.backgroundColor = MainColor;
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}


- (void)nextAction
{
    
    if (_accountText.text.length < 6 || _codeTextField.text.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码长度不能少于6位"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else if (![_accountText.text isEqualToString:_codeTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if ([_codeTextField.text isEqualToString:_accountText.text] && _accountText.text.length >= 6)
    {
        
        [_param setObject:_accountText.text forKey:@"password"];
        
        
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/signIn" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
            if([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                NSString *customerId = result[@"data"][@"customerId"];
                NSString *fullName = result[@"data"][@"fullName"];
                NSString *monthlyStatement = [result[@"data"][@"monthlyStatement"] stringValue];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:customerId forKey:@"customerId"];
                [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"fullName"];
                [[NSUserDefaults standardUserDefaults] setObject:_accountText.text forKey:@"loginName"];
                [[NSUserDefaults standardUserDefaults] setObject:monthlyStatement forKey:@"monthlyStatement"];
                [JPUSHService setAlias:customerId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                    NSLog(@"%@", iAlias);
                    
                } seq:1];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                [SVProgressHUD dismissWithDelay:1.2];
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
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
