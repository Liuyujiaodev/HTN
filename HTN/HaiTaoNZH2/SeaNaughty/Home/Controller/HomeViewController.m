//
//  HomeViewController.m
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableView.h"
#import "ActivityListModel.h"
#import "CommonModelList.h"
#import "ShopListViewController.h"
#import "AppDelegate.h"
#import "CategoryModel.h"
#import "IndexListViewController.h"
#import "BrandListViewController.h"
#import "ProductDetailViewController.h"
#import "BrandAllViewController.h"
#import "SaleListViewController.h"
#import "ListShopViewController.h"
#import "PPNetworkHelper.h"
#import "ProductListModel.h"
#import <UIButton+WebCache.h>
#import <Masonry.h>
#import "H5ViewController.h"
#import "UITabBarItem+WZLBadge.h"
#import <StoreKit/StoreKit.h>

@interface HomeViewController ()

@property (nonatomic, strong) HomeTableView *tableView;
//倒计时任务
@property (nonatomic, strong) dispatch_source_t countDownTimer;
@property (nonatomic, strong) UIView *popupsBgView;
@property (nonatomic, strong) UIImageView *popImageView;
@property (nonatomic, strong) NSDictionary *popDic;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[HomeTableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-G_TABBAR_HEIGHT)];
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reladData];
    }];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
   
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToShopList) name:@"pushToShopList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoList:) name:@"GoToList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoIndexListVC:) name:@"HotActivityNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToBrandListVC:) name:@"goToBrandList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToProductDetailVC:) name:@"goToProductDetailVC" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToAllActivity:) name:@"goToAllActivity" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToSaleList) name:@"goToSaleList" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToAllBrand) name:@"goToAllBrand" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyAction:) name:@"buyAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needlogin) name:@"needlogin" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NEEDLOGIN) name:@"NEEDLOGIN" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reladData) name:@"NeedReload" object:nil];
    
    
    dispatch_group_async(group, queue, ^{
        [self getBannerList];
    });
    
    dispatch_group_async(group, queue, ^{
        [self getBannersPopups];
    });
    
    dispatch_group_async(group, queue, ^{
        [self getIndexTip];
    });
    dispatch_group_async(group, queue, ^{
        [self getMainCategories];
    });

//    dispatch_group_async(group, queue, ^{
//        [self getLimitedSpecials];
//    });
    dispatch_group_async(group, queue, ^{
        [self getActivities];
    });
    dispatch_group_async(group, queue, ^{
        [self getActivityBlocks];
    });
    dispatch_group_async(group, queue, ^{
        [self getBrands];
    });
//    dispatch_group_async(group, queue, ^{
//        [self getVoucherInfo];
//    });

    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"NeedUpdate"] isEqualToString:@"YES"] && [[[NSUserDefaults standardUserDefaults] valueForKey:@"ShowUpdateAlert"] isEqualToString:@"YES"])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本，是否去更新？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ShowUpdateAlert"];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1447223817?mt=8"; //更换id即可
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"ShowUpdateAlert"];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDate *lastTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"startTime"];
        NSTimeInterval secondsBetweenDates= [[NSDate date] timeIntervalSinceDate:lastTime];
        double temp = secondsBetweenDates;
        if (temp >= 60*60*120) {
            if (@available(iOS 10.3, *)) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"startTime"];
                [SKStoreReviewController requestReview];
            } else {
            }
        }
    });
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.popupsBgView removeFromSuperview];
}

- (void)reladData
{
    [self getBannerList];
    [self getActivities];
    [self getActivityBlocks];
    [self getIndexTip];
    [self getMainCategories];
//    [self getLimitedSpecials];
    [self getBrands];
}

- (void)actionAAA
{
    NSString *appURL = @"https://itunes.apple.com/cn/app/id1447223817?action=write-review";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_tableView.bannerView adjustWhenControllerViewWillAppera];

    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"NeedShowPop"] isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NeedShowPop"];
        [self getBannersPopups];
    }
}

#pragma mark - 获取首页主品类
- (void)getMainCategories
{
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/categories/main" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        ActivityListModel *list = [ActivityListModel yy_modelWithDictionary:result];
        
        [self.tableView updateMainCategories:list.data];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark - 获取限时特价
- (void)getLimitedSpecials
{
    MJWeakSelf;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"4" forKey:@"homeLimit"];
//    [param setObject:@"1017709" forKey:@"customerId"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products/limitedSpecials" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        ProductListModel *list = [ProductListModel yy_modelWithDictionary:result];
        
        if (list.data.count>0)
        {
            [weakSelf createSaleEndTimeCountDownTimer];
            dispatch_resume(weakSelf.countDownTimer);
        }
        
        
        [weakSelf.tableView updateLimitedSpecials:list.data];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)createSaleEndTimeCountDownTimer
{
    //获取队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //将计时器放到队列中
    _countDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置计时器执行时间，间隔，精确度
    dispatch_source_set_timer(_countDownTimer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
    
    //设置执行事件
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_countDownTimer, ^{
        
        [weakSelf.tableView updateTime];
        
    });
    
}

#pragma mark - 获取活动数据
- (void)getActivities
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"2" forKey:@"type"];
    [param setObject:@"10" forKey:@"homeLimit"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
//    [param setObject:@"1017709" forKey:@"customerId"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/activities/products" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        ActivityListModel *list = [ActivityListModel yy_modelWithDictionary:result];
        
        [self.tableView updateActivityList:list.data];
    
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}




#pragma mark - 获取banner数据
- (void)getBannerList
{
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/banners?type=2" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        [self->_tableView updateBannerList:result[@"data"]];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getBannersPopups
{
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/banners/popups" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"status"] stringValue] isEqualToString:@"0"])
        {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.view addSubview:weakSelf.popupsBgView];
            
            weakSelf.popDic = result[@"data"];
            [weakSelf.popImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", result[@"data"][@"src"]]]];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getIndexTip
{
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/banners/indexTip" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            
            NSArray *array = result[@"data"];
            weakSelf.tableView.indexTipArray = array;
            
            [weakSelf getVoucherInfo];
        }
        else
        {
            [weakSelf getVoucherInfo];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        [weakSelf getVoucherInfo];
        
    }];
}


#pragma mark - 获取活动块数据
- (void)getActivityBlocks
{
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/activities/blocks" parameters:nil success:^(NSURLSessionDataTask *task, id result){
        
        ActivityListModel *list = [ActivityListModel yy_modelWithDictionary:result];
        
        [self->_tableView updateActivityBlock:list.data];
        [self.tableView.mj_header endRefreshing];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error){
        
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - 获取优惠券
- (void)getVoucherInfo
{
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/voucher/activityList" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *data = result[@"data"];
            NSDictionary *voucherInfo = data[@"voucherInfo"];
            NSNumber *status = voucherInfo[@"status"];
            NSInteger statu = [status integerValue];
            
            if (statu == 1)
            {
                weakSelf.tableView.voucherData = data;
                weakSelf.tableView.showVoucher = YES;
            }
            
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark - 获取品牌数据
- (void)getBrands
{
    __weak typeof(self) weakSelf = self;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/brands" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        CommonModelList *list = [CommonModelList yy_modelWithDictionary:result];
        
        [weakSelf.tableView updateBrands:list.data];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 跳转线下店铺
- (void)pushToShopList
{
    ShopListViewController *shopListVC = [[ShopListViewController alloc] init];
//
    [self.navigationController pushViewController:shopListVC animated:YES];
//
}

#pragma mark - 跳转分类页面
- (void)gotoList:(NSNotification *)notification
{
    CategoryModel *model = notification.object;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ListViewController *vc = app.tabbar.list.viewControllers[0];
    vc.selecteItem = model.name;
    app.tabbar.selectedIndex = 1;
}

#pragma mark -
- (void)gotoIndexListVC:(NSNotification *)notification
{
    ActivityModel *model = notification.object;
    IndexListViewController *vc = [[IndexListViewController alloc] init];
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 跳转具体品牌
- (void)goToBrandListVC:(NSNotification *)notification
{
    CommonModel *model = notification.object;
    
    BrandListViewController *vc = [[BrandListViewController alloc] init];
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 跳转商品详情页面
- (void)goToProductDetailVC:(NSNotification *)notification
{
    
//    //商品详情需要登录的时候修改
//    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
//    {
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    ProductModel *modell = notification.object;
    vc.productId = modell.productId;
    NSString *model = [notification.userInfo valueForKey:@"model"];
    if ([model isEqualToString:@"CommonModel"])
    {
        vc.isSale = YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)goToAllActivity:(NSNotification *)notification
{
    ActivityModel *model = notification.object;
    
    IndexListViewController *vc = [[IndexListViewController alloc] init];
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)goToSaleList
{
    SaleListViewController *vc = [[SaleListViewController alloc] init];
    
//    vc.isLimitedSpecials = YES;
//    ActivityModel *model = [[ActivityModel alloc] init];
//    model.name = @"限时秒杀";
//    model.subTitle = @"优选好货冰点价";
//    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)buyAction:(NSNotification *)notification
{
    
    ProductModel *model = notification.object;
    
    //商品详情需要登录的时候修改
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:model.productId forKey:@"productId"];
    [param setObject:model.shopId forKey:@"shopId"];
    [param setObject:@"1" forKey:@"quantity"];
    [param setObject:model.giftSale forKey:@"giftSale"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/add" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.label.text = @"添加成功!";
                [hud1 hideAnimated:YES afterDelay:1.2];
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

- (void)needlogin
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    });
   
}

- (void)NEEDLOGIN
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知消息请登录后去我的消息查看" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        });
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}

#pragma mark - 跳转所有品牌
- (void)goToAllBrand
{
    BrandAllViewController *vc = [[BrandAllViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)popupsBgView
{
    if (!_popupsBgView)
    {
        _popupsBgView = [[UIView alloc] initWithFrame:G_SCREEN_BOUNDS];
//        [[[[[UIApplication sharedApplication] delegate] window] rootViewController].view addSubview:_popupsBgView];
//        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:_popupsBgView];
        
        
        UIView *bgView = [[UIView alloc] initWithFrame:G_SCREEN_BOUNDS];
        [_popupsBgView addSubview:bgView];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        
        UIButton *btn = [[UIButton alloc] init];
        [_popupsBgView addSubview:btn];
        
        [btn makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(_popupsBgView);
            make.height.mas_equalTo(300);
        }];
        [btn addTarget:self action:@selector(popupAction) forControlEvents:UIControlEventTouchUpInside];
        
        _popImageView = [[UIImageView alloc] init];
        [_popupsBgView addSubview:_popImageView];
        [_popImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.centerY.mas_equalTo(_popupsBgView);
            make.height.mas_equalTo(300);
        }];
        _popImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [_popupsBgView addSubview:closeBtn];
        [closeBtn makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@30);
            make.bottom.mas_equalTo(_popImageView.mas_top).mas_offset(@-10);
            make.right.mas_equalTo(_popupsBgView.mas_right).mas_offset(@-40);
        }];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closPop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popupsBgView;
}

- (void)closPop
{
//    self.popupsBgView.hidden = YES;
    [self.popupsBgView removeFromSuperview];
}

- (void)popupAction
{
    
    
    
    NSNumber *typeNum = self.popDic[@"showType"];
    NSInteger type = [typeNum integerValue];
    
    if ([self.popDic[@"showData"] isKindOfClass:[NSNull class]] || [self.popDic[@"showData"] isEqualToString:@""])
    {
        return;
    }
    
    if (type == 1)
    {
        ListShopViewController *vc = [[ListShopViewController alloc] init];
        vc.searchString = self.popDic[@"showData"];
        
        if ([self.popDic.allKeys containsObject:@"shopId"])
        {
            if ([self.popDic[@"shopId"] isKindOfClass:[NSNumber class]] || [self.popDic[@"shopId"] isKindOfClass:[NSString class]] )
            {
                NSNumber *shopId = self.popDic[@"shopId"];
                vc.shopId = [NSString stringWithFormat:@"%@", shopId];
            }
        }
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.tabbar.selectedViewController pushViewController:vc animated:YES];
//        self.popupsBgView.hidden = YES;
    }
    else if (type == 2)
    {
        IndexListViewController *vc = [[IndexListViewController alloc] init];
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/activities/detail" parameters:@{@"id":self.popDic[@"showData"]} success:^(NSURLSessionDataTask *task, id result) {
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                ActivityModel *model = [ActivityModel yy_modelWithDictionary:result[@"data"]];
                vc.model = model;
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.tabbar.selectedViewController pushViewController:vc animated:YES];
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else if (type == 3)
    {
        ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
        vc.productId = self.popDic[@"showData"];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.tabbar.selectedViewController pushViewController:vc animated:YES];
    }
    else if (type == 0)
    {
        H5ViewController *vc = [[H5ViewController alloc] init];
        NSString *urlString = self.popDic[@"showData"];
        
        //            NSString *testUrl = @"http://test.aulinkc.com/m";
        NSString *testUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
        {
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"] isKindOfClass:[NSString class]])
            {
                urlString = [NSString stringWithFormat:@"%@/m/user/appRedirect?sessionId=%@&ref=%@",testUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"],[NSString stringWithFormat:@"%@",self.popDic[@"showData"]]];
            }
            else
                return;
        }
        else
        {
//            [SVProgressHUD showErrorWithStatus:@"请先登录"];
//            [SVProgressHUD dismissWithDelay:0.6];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginViewController *vc = [[LoginViewController alloc] init];
                vc.needShowPop = YES;
                [app.tabbar.selectedViewController pushViewController:vc animated:YES];
//            });
            
            
            
            return;
        }
        vc.urlString = urlString;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.tabbar.selectedViewController pushViewController:vc animated:YES];
    }
    [self.popupsBgView removeFromSuperview];
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
