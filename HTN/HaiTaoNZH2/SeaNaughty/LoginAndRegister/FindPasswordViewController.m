//
//  FindPasswordViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/23.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "FindPasswordViewController.h"


@interface FindPasswordViewController ()

@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UITextField *passwordTextField1;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    
    [self initUI];
}

- (void)initUI
{
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
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, G_NAV_HEIGHT+78, 12, 14)];
    imageView2.image = [UIImage imageNamed:@"密码"];
    [self.view addSubview:imageView2];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, G_NAV_HEIGHT+128, 12, 14)];
    imageView1.image = [UIImage imageNamed:@"密码"];
    [self.view addSubview:imageView1];
    
    _passwordText = [[UITextField alloc] initWithFrame:CGRectMake(40, G_NAV_HEIGHT+70, G_SCREEN_WIDTH-55, 30)];
    _passwordText.placeholder = @"输入密码，长度不能少于6位";
    _passwordText.secureTextEntry = YES;
    _passwordText.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_passwordText];

    _passwordTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(40, G_NAV_HEIGHT+120, G_SCREEN_WIDTH-55, 30)];
    _passwordTextField1.placeholder = @"再次输入密码";
    _passwordTextField1.secureTextEntry = YES;
    _passwordTextField1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_passwordTextField1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+100, G_SCREEN_WIDTH-30, 1)];
    lineView1.backgroundColor = LineColor;
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+150, G_SCREEN_WIDTH-30, 1)];
    lineView2.backgroundColor = LineColor;
    [self.view addSubview:lineView2];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, G_NAV_HEIGHT+200, G_SCREEN_WIDTH-30, 48)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sureBtn.backgroundColor = MainColor;
    sureBtn.layer.cornerRadius = 10;
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
}

- (void)sureAction
{
    
    if (_passwordText.text.length > 0)
    {
//        [_param setObject:_passwordText.text forKey:@"loginPassword"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
        [SVProgressHUD dismissWithDelay:1.3];
        return;
    }
    
    if (_passwordText.text.length >= 6 && [_passwordText.text isEqualToString:_passwordTextField1.text])
    {
        [_param setObject:_passwordText.text forKey:@"newPassword"];
    }
    else if (_passwordText.text.length < 6 || _passwordTextField1.text.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码长度不能少于6位"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else if (![_passwordText.text isEqualToString:_passwordTextField1.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/resetPwd" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        
   
        
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
