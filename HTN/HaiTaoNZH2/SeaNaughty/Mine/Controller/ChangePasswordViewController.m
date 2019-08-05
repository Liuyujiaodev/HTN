//
//  ChangePasswordViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "QYSDK.h"
#import "MineViewController.h"
#import <JPUSHService.h>

@interface ChangePasswordViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, strong) UITextField *oldTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UITextField *password1TextField;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LineColor;
    
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.btnView];
    
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
        _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 280)];
        topView.backgroundColor = [UIColor colorFromHexString:@"#E0C16A"];
        [_headerView addSubview:topView];
        
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-30, 85, 60, 60)];
        [_headerImg sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"tempHeader"]];
        _headerImg.layer.cornerRadius = 30;
        _headerImg.clipsToBounds = YES;
        [_headerView addSubview:_headerImg];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, G_SCREEN_WIDTH-40, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = [NSString stringWithFormat:@"Hi，%@，欢迎登录NZH~", [[NSUserDefaults standardUserDefaults] valueForKey:@"fullName"]];
        [_headerView addSubview:_nameLabel];
        
        UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, G_STATUSBAR_HEIGHT+10, 80, 20)];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:logoutBtn];
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(15, 215, G_SCREEN_WIDTH-30, 160)];
        botView.backgroundColor = [UIColor whiteColor];
        botView.layer.cornerRadius = 5;
        [_headerView addSubview:botView];
        
        NSArray *array = @[@"当前账号:",@"旧密码:",@"新密码:",@"确认新密码:"];
        for (int i=0; i<4; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40*i, 100, 20)];
            label.text = array[i];
            label.textColor = TitleColor;
            label.font = [UIFont systemFontOfSize:14];
            [botView addSubview:label];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(13, 40*i, G_SCREEN_WIDTH-56, 1)];
            lineView.backgroundColor = LineColor;
        
            
            UITextField *rightLabel = [[UITextField alloc] initWithFrame:CGRectMake(100, 10+40*i, G_SCREEN_WIDTH-160, 20)];
            rightLabel.tag = i+100;
            rightLabel.textColor = TextColor;
            rightLabel.font = [UIFont systemFontOfSize:14];
            rightLabel.textAlignment = NSTextAlignmentRight;
            [botView addSubview:rightLabel];
            
            if (i!=0)
            {
                rightLabel.secureTextEntry = YES;
                rightLabel.enabled = YES;
                [botView addSubview:lineView];
            }
            
            if (i==0)
            {
                rightLabel.enabled = NO;
                rightLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginName"];
            }
            
        }
        
        _oldTextField = [_headerView viewWithTag:101];
        _passwordTextField = [_headerView viewWithTag:102];
        _password1TextField = [_headerView viewWithTag:103];
        
        
    }
    return _headerView;
}

- (UIView *)btnView
{
    if (!_btnView)
    {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-G_TABBAR_HEIGHT, G_SCREEN_WIDTH, 48)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_btnView addSubview:lineView];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, G_SCREEN_WIDTH/2, 47)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:MainColor forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [_btnView addSubview:cancleBtn];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2, 1, G_SCREEN_WIDTH/2, 47)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.backgroundColor = MainColor;
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:sureBtn];
        
    }
    return _btnView;
}

#pragma mark - 取消
- (void)cancleAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确定
- (void)sureAction
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if (_oldTextField.text.length > 0)
    {
        [param setObject:_oldTextField.text forKey:@"loginPassword"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
        [SVProgressHUD dismissWithDelay:1.3];
        return;
    }
    
    if (_password1TextField.text.length >= 6 && [_password1TextField.text isEqualToString:_passwordTextField.text])
    {
        [param setObject:_passwordTextField.text forKey:@"newPassword"];
    }
    else if (_passwordTextField.text.length < 6 || _password1TextField.text.length < 6)
    {
        [SVProgressHUD showErrorWithStatus:@"密码长度不能少于6位"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else if (![_password1TextField.text isEqualToString:_passwordTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    MJWeakSelf;
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/changePwd" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
     
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
//            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
//            [SVProgressHUD dismissWithDelay:1];
            weakSelf.passwordTextField.text = @"";
            weakSelf.oldTextField.text = @"";
            weakSelf.password1TextField.text = @"";
            
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"customerId"];
            
//            LoginViewController *vc = [[LoginViewController alloc] init];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.numberOfLines = 0;
            hud.detailsLabel.text = @"修改成功!正在为您返回到登录页面,请稍候";
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 退出登录
- (void)logoutAction
{
    [[QYSDK sharedSDK] logout:^(BOOL success) {
        NSLog(@"success = %i", success);
    }];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReload" object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sessionId"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _nameLabel.text = [NSString stringWithFormat:@"Hi，%@，欢迎登录NZH~", [[NSUserDefaults standardUserDefaults] valueForKey:@"fullName"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
