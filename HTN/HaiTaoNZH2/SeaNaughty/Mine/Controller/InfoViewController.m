//
//  InfoViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "InfoViewController.h"
#import "QYSDK.h"
#import <JPUSHService.h>
#import "ActivityMsgListVC.h"
#import "PushListVC.h"

@interface InfoViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) UIView *botView;


@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = LineColor;
    
    [self.view addSubview:self.headerView];
    
    [self.view addSubview:self.btnView];
    [self getInfo];
    
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
//        _headerImg.backgroundColor = [UIColor grayColor];
        _headerImg.layer.cornerRadius = 30;
        [_headerImg sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"tempHeader"]];
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
        
        _botView = [[UIView alloc] initWithFrame:CGRectMake(15, 215, G_SCREEN_WIDTH-30, 160)];
        _botView.backgroundColor = [UIColor whiteColor];
        _botView.layer.cornerRadius = 5;
        [_headerView addSubview:_botView];
        
        NSArray *array = @[@"账号:",@"昵称:",@"邮箱:",@"手机号码:"];
//        NSArray *array1 = @[@"huihuihui",@"木南",@"12345678@qq.com",@"123456789"];
        for (int i=0; i<4; i++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+40*i, 100, 20)];
            label.text = array[i];
            label.textColor = TitleColor;
            label.font = [UIFont systemFontOfSize:14];
            [_botView addSubview:label];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(13, 40*i, G_SCREEN_WIDTH-56, 1)];
            lineView.backgroundColor = LineColor;
            
            if (i!=0)
            {
                [_botView addSubview:lineView];
            }
            
            UITextField *rightLabel = [[UITextField alloc] initWithFrame:CGRectMake(100, 10+40*i, G_SCREEN_WIDTH-160, 20)];
            rightLabel.tag = i+100;
            rightLabel.textColor = TextColor;
            rightLabel.font = [UIFont systemFontOfSize:14];
            rightLabel.textAlignment = NSTextAlignmentRight;
            [_botView addSubview:rightLabel];
            if (i == 0 || i == 3)
            {
                rightLabel.enabled = NO;
            }
            
        }
        
        
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

- (void)getInfo
{
    UITextField *loginText = (UITextField *)[_botView viewWithTag:100];
    UITextField *nameText = (UITextField *)[_botView viewWithTag:101];
    UITextField *emailText = (UITextField *)[_botView viewWithTag:102];
    UITextField *phoneText = (UITextField *)[_botView viewWithTag:103];
    
    
    MJWeakSelf;
    NSDictionary *param = @{@"customerId":[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"]};
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/info" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        weakSelf.info = result[@"data"];
        
        weakSelf.nameLabel.text = weakSelf.info[@"fullName"];
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.info[@"fullName"] forKey:@"fullName"];
        loginText.text = weakSelf.info[@"loginName"];
        nameText.text = weakSelf.info[@"fullName"];
        emailText.text = weakSelf.info[@"email"];
        phoneText.text = weakSelf.info[@"phone"];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark - 取消
- (void)cancleAction
{
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.isFromMessage)
    {
        if (self.navigationController.viewControllers.count > 1)
        {
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[ActivityMsgListVC class]] || [vc isKindOfClass:[PushListVC class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 确定
- (void)sureAction
{
    MJWeakSelf;
    UITextField *nameText = (UITextField *)[_botView viewWithTag:101];
    UITextField *emailText = (UITextField *)[_botView viewWithTag:102];
    
    // 邮箱格式验证
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:nameText.text forKey:@"fullName"];
    
    // 邮箱确认必填2019-6-10
    if(emailText.text.length<=0){
        [SVProgressHUD showErrorWithStatus:@"请填写邮箱"];
        [SVProgressHUD dismissWithDelay:1.0];
        return ;
    }
    
    if([emailTest evaluateWithObject:emailText.text]){
        [param setObject:emailText.text forKey:@"email"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写正确的邮箱格式"];
        [SVProgressHUD dismissWithDelay:1.0];
        return ;
    }
   

    
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/updateInfo" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
       
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [SVProgressHUD dismissWithDelay:1.0];
            [weakSelf getInfo];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            [SVProgressHUD dismissWithDelay:1.0];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - 退出登录
- (void)logoutAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
    [[QYSDK sharedSDK] logout:^(BOOL success) {
        NSLog(@"success = %i", success);
    }];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReload" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sessionId"];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
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
