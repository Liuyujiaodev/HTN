//
//  MineViewController.m
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "MineViewController.h"
#import "MineTabelView.h"
#import "MineTableViewCell.h"
#import "InfoViewController.h"
#import "MyCardViewController.h"
#import "MyCouponViewController.h"
#import "ChangePasswordViewController.h"
#import "AddressManagerViewController.h"
#import "OrderListViewController.h"
#import "MyCollectionViewController.h"
#import "AppDelegate.h"
#import "MoneyViewController.h"
#import <Masonry.h>
#import "ChatListVC.h"
#import "QYSDK.h"
#import <JPUSHService.h>
#import "AfterSaleViewController.h"
#import "UIView+WZLBadge.h"
#import "UITabBarItem+WZLBadge.h"

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, assign) BOOL showMoney;
@property (nonatomic, assign) BOOL showVoucher;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _showMoney = YES;
    _showVoucher = NO;
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -G_STATUSBAR_HEIGHT, G_SCREEN_WIDTH, G_SCREEN_HEIGHT+G_STATUSBAR_HEIGHT-G_TABBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineCell"];

//    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 30)];
//    label1.text = @"1.1.9";
//    label1.textAlignment = NSTextAlignmentCenter;
//    label1.numberOfLines = 0;
//    label1.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    label1.textColor = TitleColor;
//    label1.font = [UIFont systemFontOfSize:12];
//
//    _tableView.tableFooterView = label1;
    
    [self.view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadInfo) name:@"NeedReload" object:nil];
   
    if (_showMoney)
    {
        [self getWalletInfo];
    }
}

- (void)reloadInfo
{
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"tempHeader"]];
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 320)];
        _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 260)];
        topView.backgroundColor = [UIColor colorFromHexString:@"#E0C16A"];
        [_headerView addSubview:topView];
        
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-30, 85, 60, 60)];
//        _headerImg.backgroundColor = [UIColor grayColor];
//        [dataDic valueForKey:@"avatarUrl"]
//        _headerImg.image = [UIImage imageNamed:@"tempHeader"];
        [_headerImg sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"tempHeader"]];
        _headerImg.layer.cornerRadius = 30;
        _headerImg.clipsToBounds = YES;
        [_headerView addSubview:_headerImg];
        
        
        [_headerView addSubview:self.nameLabel];
        
        UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, G_STATUSBAR_HEIGHT+10, 80, 20)];
        [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoutBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:logoutBtn];
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(15, 215, G_SCREEN_WIDTH-30, 90)];
        botView.backgroundColor = [UIColor whiteColor];
        botView.layer.cornerRadius = 5;
        [_headerView addSubview:botView];
        
        UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
        orderLabel.textColor = TitleColor;
        orderLabel.text = @"我的订单";
        orderLabel.font = [UIFont systemFontOfSize:13];
        [botView addSubview:orderLabel];
        
        UIButton *orderListBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-130, 10, 100, 15)];
        [orderListBtn setTitle:@"查看全部订单 >" forState:UIControlStateNormal];
        [orderListBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
        orderListBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [orderListBtn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        orderListBtn.tag = 1000;
        [botView addSubview:orderListBtn];
        
        NSArray *array = @[@"待付款",@"待发货",@"已发货",@"已收货"];
        CGFloat width = (G_SCREEN_WIDTH-30)/4-60;
        for (int i=0; i<4; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((width+60)*i+width/2, 30, 60, 50)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"图层 %i",i+7]] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(30, -16, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-5, 18, 10, 5);
            [btn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1001+i;
            [botView addSubview:btn];
            
            
        }
        
    }
    return _headerView;
}



#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return _showMoney ? 1+_showVoucher : _showVoucher;
    }
    else
        return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"我的消息",@"个人信息",@"我的会员卡",@"我的收藏夹",@"修改密码",@"地址管理",@"售后细则",@"版本号"];
    NSArray *imageArray = @[@"wdxx",@"图层 11",@"图层 12",@"图层 13",@"图层 14",@"图层 15",@"售后细则",@""];
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
    
    
    if (indexPath.section==0)
    {
        if (_showMoney)
        {
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"账户余额";
                cell.leftLogo.image = [UIImage imageNamed:@"账户"];
            }
            else if (indexPath.row == 1)
            {
                cell.titleLabel.text = @"优惠券";
                cell.leftLogo.image = [UIImage imageNamed:@"优惠券"];
            }
        }
        else
        {
            cell.titleLabel.text = @"优惠券";
            cell.leftLogo.image = [UIImage imageNamed:@"优惠券"];
        }
    }
    else
    {
        cell.titleLabel.text = array[indexPath.row];
        cell.leftLogo.image = [UIImage imageNamed:imageArray[indexPath.row]];
        cell.showUpdate = NO;
        if (indexPath.row == 7)
        {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appversion = [infoDictionary valueForKey:@"CFBundleShortVersionString"];
            cell.detailLabel.text = appversion;
            cell.hideArrow = YES;
            cell.titleLabel.frame = CGRectMake(15, 10, 45, 24);
        }
        else
        {
            cell.hideArrow = NO;
            cell.detailLabel.text = @"";
            cell.titleLabel.frame = CGRectMake(50, 10, 300, 24);
        }
        
    }
    
    if (indexPath.row==0)
    {
        cell.lineView.hidden = YES;
    }
    
    if (_showMoney && indexPath.section == 0 && indexPath.row == 0 && _money.length>=1)
    {
        NSString *temp = [NSString stringWithFormat:@"账户余额 (%@)",_money];
        NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:temp];
        [astr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(5, temp.length-5)];
        cell.titleLabel.attributedText = astr;
    }
    
    if (indexPath.section == 1 && indexPath.row == 7)
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"NeedUpdate"] isEqualToString:@"YES"])
        {
            cell.showUpdate = YES;
            [cell.titleLabel showBadge];
        }
        else
        {
            cell.showUpdate = NO;
            [cell.titleLabel clearBadge];
        }
        
    }
    else
    {
        cell.showUpdate = NO;
        [cell.titleLabel clearBadge];
    }
    
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"avatarUrl"]] placeholderImage:[UIImage imageNamed:@"tempHeader"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            ChatListVC *vc = [[ChatListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            InfoViewController *vc = [[InfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2)
        {
            MyCardViewController *vc = [[MyCardViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 3)
        {
            MyCollectionViewController *vc = [[MyCollectionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 4)
        {
            ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 5)
        {
            AddressManagerViewController *vc = [[AddressManagerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 6)
        {
            //TODO 售后细则
            AfterSaleViewController *vc = [[AfterSaleViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 7)
        {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"NeedUpdate"] isEqualToString:@"YES"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ShowUpdateAlert"];
                NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1447223817?mt=8"; //更换id即可
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
            else
            {
                MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                loadingHud.mode = MBProgressHUDModeText;
                loadingHud.label.text = @"您已是最新版本";
                [loadingHud showAnimated:YES];
                [loadingHud hideAnimated:YES afterDelay:1.2];
            }
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 0)
    {
        if (_showMoney)
        {
            MoneyViewController *vc = [[MoneyViewController alloc] init];
            vc.money = _money;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            MyCouponViewController *vc = [[MyCouponViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        MyCouponViewController *vc = [[MyCouponViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)orderBtnAction:(UIButton *)btn
{
    int temp = (int)btn.tag-1000;
    if (temp>1) {
        temp = temp+1;
    }
    OrderListViewController *vc = [[OrderListViewController alloc] init];
    vc.selectIndex = temp;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 退出登录
- (void)logoutAction
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"customerId"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"sessionId"];
    
    [[QYSDK sharedSDK] logout:^(BOOL success) {
//        NSLog(@"success = %i", success);
    }];
    
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:1];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedReload" object:nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tabbar.selectedIndex = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
    
}

- (void)getCustomerInfo
{
    
    NSDictionary *param = @{@"customerId":[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"]};
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/info" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 获取余额
- (void)getWalletInfo
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:@"1" forKey:@"pageNumber"];
    [param setObject:@"10" forKey:@"pageSize"];
    
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/getWalletInfo" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
    
        id temp = result[@"data"][@"walletSum"];
        
        if ([temp isKindOfClass:[NSNumber class]])
        {
            _money = [result[@"data"][@"walletSum"] stringValue];
        }
        else
            _money = result[@"data"][@"walletSum"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
            
        });
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)getVoucher
{
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/voucher/activityList" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *data = result[@"data"];
            NSDictionary *voucherInfo = data[@"voucherInfo"];
            NSNumber *status = voucherInfo[@"status"];
            NSInteger statu = [status integerValue];
            if (statu == 1)
            {
                _showVoucher = YES;
                [_tableView reloadData];
            }
            
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        _nameLabel.text = [NSString stringWithFormat:@"%@", @""];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tabbar.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needlogin" object:nil];
        return;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        _nameLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"fullName"]];
        [self getWalletInfo];
//        [self getCustomerInfo];
        [self getVoucher];
//        webapi/voucher/activityList
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = NO;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, G_SCREEN_WIDTH-40, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"fullName"]];
    }
    return _nameLabel;
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
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
