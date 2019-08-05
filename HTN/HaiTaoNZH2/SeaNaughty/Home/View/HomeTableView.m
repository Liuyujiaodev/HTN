//
//  HomeTableView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "HomeTableView.h"

#import "CategoriesCell.h"
#import "HomeHeaderView.h"
#import "HotActivityCell.h"
#import "BrandsCell.h"
#import "ActivityModel.h"
#import "SaleCell.h"
#import "CommonModel.h"
#import "ProductCollectionView.h"
#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "IndexListViewController.h"
#import "ListShopViewController.h"
#import "H5ViewController.h"
#import <UIButton+WebCache.h>
#import "VoucherBtn.h"
#import "GYChangeTextView.h"

typedef enum : NSUInteger {
    CategoriesSection,
    HotActivitySection,
    BrandsSection,
} HomeSection;

@interface HomeTableView () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate, GYChangeTextViewDelegate>


@property (nonatomic, strong) NSArray *bannerList;
@property (nonatomic, strong) NSArray *categoryList;
@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, strong) NSArray *activityBlock;
@property (nonatomic, strong) NSArray *brandList;
@property (nonatomic, strong) NSMutableArray *specialList;
//倒计时任务
@property (nonatomic, strong) dispatch_source_t countDownTimer;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIView *voucherView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *vouchers;
@property (nonatomic, strong) GYChangeTextView *changeTextView;
@property (nonatomic, assign) BOOL hasIndexTitle;
@end


@implementation HomeTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        self.tableHeaderView = self.headerView;
        
        _specialList = [[NSMutableArray alloc] initWithCapacity:0];
        _activityList = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self registerClass:[CategoriesCell class] forCellReuseIdentifier:@"CategoriesCell"];
        [self registerClass:[HotActivityCell class] forCellReuseIdentifier:@"HotActivityCell"];
        [self registerClass:[SaleCell class] forCellReuseIdentifier:@"SaleCell"];
        [self registerClass:[HomeHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeHeaderView"];
        [self registerClass:[BrandsCell class] forCellReuseIdentifier:@"BrandsCell"];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 50)];
        label1.text = @"copyright@nzhg.co.nz All Rights Reserved by NZH Group";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.numberOfLines = 0;
        label1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        label1.textColor = TitleColor;
        label1.font = [UIFont systemFontOfSize:12];
        
        self.tableFooterView = label1;
    }
    return self;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_WIDTH/1.8+30)];
        _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_WIDTH/1.8) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner_default"]];
        _bannerView.autoScrollTimeInterval = 6.0f;
        _bannerView.delegate = self;
        _bannerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:_bannerView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, G_SCREEN_WIDTH/1.8, G_SCREEN_WIDTH, 30)];
        label.text = @"新西兰直邮仓满49纽币包邮";
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = MainColor;
        label.textAlignment = NSTextAlignmentCenter;
        
        _changeTextView = [[GYChangeTextView alloc] initWithFrame:CGRectMake(0,  G_SCREEN_WIDTH/1.8, G_SCREEN_WIDTH, 30)];
        _changeTextView.delegate = self;
//        _changeTextView.co
        _changeTextView.backgroundColor = [UIColor whiteColor];
//        [_changeTextView animationWithTexts:@[@"alhjdkskajhdska", @"ajdkhajkhdkas"]];
        
        [_headerView addSubview:_changeTextView];
    }
    return _headerView;
}

- (void)setIndexTipArray:(NSArray *)indexTipArray
{
    _indexTipArray = indexTipArray;
    NSMutableArray *tipArray = [[NSMutableArray alloc] init];
    if (_indexTipArray.count > 0)
    {
        _hasIndexTitle = YES;
        for (int i=0; i<indexTipArray.count; i++)
        {
            NSDictionary *dic = indexTipArray[i];
            [tipArray addObject:[NSString stringWithFormat:@"%@", dic[@"showData"]]];
        }
        [_changeTextView animationWithTexts:tipArray];
        
        if (tipArray.count == 1)
        {
            [_changeTextView stopAnimation];
        }
    }
    else
    {
        self.headerView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_WIDTH/1.8);
        _changeTextView.hidden = YES;
        _hasIndexTitle = NO;
    }
}

- (void)gyChangeTextView:(GYChangeTextView *)textView didTapedAtIndex:(NSInteger)index
{
    
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _activityList.count+4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return _specialList.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 8;
    }
    
    if (_specialList.count == 0&&section==2)
    {
        return 0.001;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section>=1)
    {
        return 0.01;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 64+G_SCREEN_WIDTH/5*2;
    }
    else if (indexPath.section == 1)
    {
        return 375;
    }
    else if (indexPath.section == 2)
    {
        return 200;
    }
    else if (indexPath.section == _activityList.count+3)
    {
        NSInteger num = 5;
        NSInteger count = _brandList.count;
        if (count <= 25)
        {
            int temp = count%5 > 0 ? 1 : 0;
            num = count/5 +temp;
        }
        return G_SCREEN_WIDTH/5*55/82*num;
    }
    else
    {
        if (_activityList.count>0)
        {
            ActivityModel *model = _activityList[indexPath.section-3];
            if ([model.products count]<3 && [model.products count]>0)
            {
                return 340;
            }
            else if ([model.products count]>4)
            {
                return 1024;
            }
            else if ([model.products count] == 0)
            {
                return 0.001;
            }
            else
                return 682;
        }
    }
    return 682;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HomeHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HomeHeaderView"];
    if (section == 0)
    {
        return [UIView new];
    }
    else if (section ==  1)
    {
        headerView.model = nil;
        [headerView updateTitle:@"热门活动" imageName:@"icon-deng" needHiddenRight:YES];
    }
    else if (section == 2)
    {
        headerView.model = nil;
        [headerView updateTitle:@"限时特价" imageName:@"icon-deng" needHiddenRight:NO];
        
        if (_specialList.count == 0)
        {
            return [UIView new];
        }
        
    }
    else if (section == _activityList.count+3)
    {
        headerView.model = nil;
        [headerView updateTitle:@"品牌大全" imageName:@"icon-deng" needHiddenRight:NO];
    }
    else
    {
        ActivityModel *model = _activityList[section-3];
        headerView.model = model;
        [headerView updateTitle:model.name imageName:@"icon-deng" needHiddenRight:NO];
    }
    if (section>=2)
    {
        headerView.bgColor = LineColor;
    }
    else
    {
        headerView.bgColor = [UIColor whiteColor];
    }
    return headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 10)];
    view.backgroundColor = LineColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        CategoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoriesCell" forIndexPath:indexPath];
        cell.categoriesArray = _categoryList;
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        HotActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotActivityCell" forIndexPath:indexPath];
        
        cell.dataArray = _activityBlock;
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        SaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleCell" forIndexPath:indexPath];
        if (_specialList.count>0)
        {
            ProductModel *model = _specialList[indexPath.row];
            cell.data = model;
        }
        return cell;
    }
    else if (indexPath.section == _activityList.count+3)
    {
        BrandsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandsCell" forIndexPath:indexPath];
        
        if (_brandList)
        {
            cell.brandArray = _brandList;
        }
        
        return cell;
    }
    else
    {
        NSString *identifierString = [NSString stringWithFormat:@"cell%li%li",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ProductCollectionView *productView = [[ProductCollectionView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 340)];
            productView.tag = 15+indexPath.section;
            [cell.contentView addSubview:productView];
        }
        
        if (_activityList.count>0)
        {
            ActivityModel *model = _activityList[indexPath.section-3];
            
            ProductCollectionView *productView = [cell.contentView viewWithTag:15+indexPath.section];
            CGFloat height;
            if ([model.products count] == 0)
            {
                height = 0.001;
            }
            else if ([model.products count]<3)
            {
                height = 340;
            }
            else if ([model.products count]>4)
            {
                height = 1024;
            }
            else
                height = 682;
            productView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, height);
            
            productView.dataArray = model.products;
        }
        
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2)
    {
        ProductModel *model = _specialList[indexPath.row];
        NSNotification *notification = [NSNotification notificationWithName:@"goToProductDetailVC" object:model userInfo:@{@"model":@"CommonModel"}];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    
}


- (void)setVoucherData:(NSDictionary *)voucherData
{
    _voucherData = voucherData;
    NSDictionary *voucherInfo = _voucherData[@"voucherInfo"];
    NSNumber *activityId = _voucherData[@"activity"][@"id"];
    NSNumber *endTime = _voucherData[@"activity"][@"endTime"];
    NSArray *array = _voucherData[@"vouchers"];
    _vouchers = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array)
    {
        NSNumber *num = dic[@"voucherBookId"];
        [_vouchers addObject:[NSString stringWithFormat:@"%@", num]];
    }
    
    NSMutableArray *voucherArray = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    if ([voucherInfo[@"voucher1"] isKindOfClass:[NSNumber class]])
    {
        [voucherArray addObject:voucherInfo[@"voucher1Img"]];
        [idArray addObject:[NSString stringWithFormat:@"%@", voucherInfo[@"voucher1"]]];
    }
    else
    {
        [voucherArray addObject:@""];
        [idArray addObject:@""];
    }
    if ([voucherInfo[@"voucher2"] isKindOfClass:[NSNumber class]])
    {
        [voucherArray addObject:voucherInfo[@"voucher2Img"]];
        [idArray addObject:[NSString stringWithFormat:@"%@", voucherInfo[@"voucher2"]]];
    }
    else
    {
        [voucherArray addObject:@""];
        [idArray addObject:@""];
    }
    if ([voucherInfo[@"voucher3"] isKindOfClass:[NSNumber class]])
    {
        [voucherArray addObject:voucherInfo[@"voucher3Img"]];
        [idArray addObject:[NSString stringWithFormat:@"%@", voucherInfo[@"voucher3"]]];
    }
    else
    {
        [voucherArray addObject:@""];
        [idArray addObject:@""];
    }
    if ([voucherInfo[@"voucher4"] isKindOfClass:[NSNumber class]])
    {
        [voucherArray addObject:voucherInfo[@"voucher4Img"]];
        [idArray addObject:[NSString stringWithFormat:@"%@", voucherInfo[@"voucher4"]]];
    }
    else
    {
        [voucherArray addObject:@""];
        [idArray addObject:@""];
    }
    if ([voucherInfo[@"voucher5"] isKindOfClass:[NSNumber class]])
    {
        [voucherArray addObject:voucherInfo[@"voucher5Img"]];
        [idArray addObject:[NSString stringWithFormat:@"%@", voucherInfo[@"voucher5"]]];
    }
    else
    {
        [voucherArray addObject:@""];
        [idArray addObject:@""];
    }
    
    NSString *bgImg = voucherInfo[@"bgimg"];
    CGFloat tempWidth = 1/1200.0*G_SCREEN_WIDTH;
    CGFloat indexTitleHeight = 38;
    if (!_hasIndexTitle)
    {
        indexTitleHeight = 8;
    }
    
    _voucherView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_WIDTH/1.8+indexTitleHeight, G_SCREEN_WIDTH, 680.0*tempWidth)];
    for (UIView *view in _voucherView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 680.0*tempWidth)];
    [_voucherView addSubview:imageView];
    [imageView sd_setImageWithURL:[NSURL URLWithString:bgImg] completed:nil];
    for (int i=0; i<voucherArray.count; i++)
    {
//        CGFloat width = (G_SCREEN_WIDTH-80*tempWidth*2)/5;
        CGFloat width = 93*tempWidth*2;
        VoucherBtn *btn = [[VoucherBtn alloc] initWithFrame:CGRectMake(80*tempWidth+width*i, 213*tempWidth, width, width/2)];
        [_voucherView addSubview:btn];
        NSString *idString = idArray[i];
        if (idString.length > 0)
        {
            btn.showData = idArray[i];
            btn.endTime = [NSString stringWithFormat:@"%@",endTime];
            btn.activityId = [NSString stringWithFormat:@"%@",activityId];
            
            [btn addTarget:self action:@selector(voucherAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn sd_setImageWithURL:[NSURL URLWithString:voucherArray[i]] forState:UIControlStateNormal];
        }
    }
    
    if ([voucherInfo[@"activity1"] isKindOfClass:[NSString class]])
    {
        VoucherBtn *btn = [[VoucherBtn alloc] initWithFrame:CGRectMake(350*tempWidth, 590*tempWidth, 200*tempWidth, 21)];
        [btn setImage:[UIImage imageNamed:@"点击进入"] forState:UIControlStateNormal];
        btn.showData = voucherInfo[@"activity1"];
        [btn addTarget:self action:@selector(activityAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voucherView addSubview:btn];
    }
    
    if ([voucherInfo[@"activity2"] isKindOfClass:[NSString class]])
    {
        VoucherBtn *btn1 = [[VoucherBtn alloc] initWithFrame:CGRectMake(820*tempWidth, 448*tempWidth, 206*tempWidth, 18)];
        [btn1 setImage:[UIImage imageNamed:@"点击抢购"] forState:UIControlStateNormal];
        btn1.showData = voucherInfo[@"activity2"];
        [btn1 addTarget:self action:@selector(activityAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voucherView addSubview:btn1];
    }
    
    [self.headerView addSubview:_voucherView];
    self.headerView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_WIDTH/1.8+indexTitleHeight+680*tempWidth);
    
    self.headerView = self.headerView;
    [self reloadData];
}

- (void)voucherAction:(VoucherBtn *)btn
{
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
//        [SVProgressHUD showErrorWithStatus:@"登录后才能领券哦~"];
//        [SVProgressHUD dismissWithDelay:0.6];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:[LoginViewController new] animated:YES];
//        });
       
        
        return;
    }
    
    
    if ([_vouchers containsObject:btn.showData])
    {
        
        NSDate *date = [NSDate date];
        long long timeInterval = [date timeIntervalSince1970];
        
        if ([btn.endTime longLongValue] < timeInterval)
        {
            [SVProgressHUD showErrorWithStatus:@"活动结束了"];
            [SVProgressHUD dismissWithDelay:1.1];
            return;
        }
        
        NSDictionary *param = @{@"voucherBookId": btn.showData, @"customerId":[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"], @"activityId":btn.activityId};
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/receiveVoucher" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                [SVProgressHUD showSuccessWithStatus:@"恭喜您！领取成功"];
                [SVProgressHUD dismissWithDelay:1.0];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                [SVProgressHUD dismissWithDelay:1.0];
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"无该优惠券"];
        [SVProgressHUD dismissWithDelay:1.1];
        return;
    }
    
}

- (void)activityAction:(VoucherBtn *)btn
{
    
    H5ViewController *vc = [[H5ViewController alloc] init];
    NSString *urlString = btn.showData;
    NSString *testUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"] isKindOfClass:[NSString class]])
        {
            urlString = [NSString stringWithFormat:@"%@/m/user/appRedirect?sessionId=%@&ref=%@",testUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"],[NSString stringWithFormat:@"%@",urlString]];
        }
        else
            return;
    }
    else
    {
//        [SVProgressHUD showErrorWithStatus:@"请先登录"];
//        [SVProgressHUD dismissWithDelay:0.6];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:[LoginViewController new] animated:YES];
//        });
        return;
    }
    
    vc.urlString = urlString;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabbar.selectedViewController pushViewController:vc animated:YES];
}


- (void)updateBannerList:(NSArray *)bannerList
{
    _bannerList = bannerList;
    NSMutableArray *imageURL = [NSMutableArray arrayWithCapacity:_bannerList.count];
    for (NSDictionary *dic in _bannerList)
    {
        [imageURL addObject:dic[@"src"]];
    }
    _bannerView.imageURLStringsGroup = imageURL;
}

- (void)updateMainCategories:(NSArray *)categoryList
{
    _categoryList = categoryList;
    
    [self reloadData];
}

- (void)updateLimitedSpecials:(NSArray *)limitedSpecials
{
    _specialList = [NSMutableArray arrayWithArray:limitedSpecials];
    _specialList = [[NSMutableArray alloc] init];
   
    [self reloadData];
}

- (void)updateActivityList:(NSArray *)activityList
{
    _activityList = [NSMutableArray arrayWithArray:activityList];
    
    [self reloadData];
}



- (void)updateTime
{
    MJWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0; i<weakSelf.specialList.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:2];
            CommonModel *model = weakSelf.specialList[i];
            SaleCell *cell = [weakSelf cellForRowAtIndexPath:indexPath];
            cell.saleEndTimeSecond = model.endTime;
        }
    });
}

- (void)updateActivityBlock:(NSArray *)activityBlocks
{
    _activityBlock = activityBlocks;

    [self reloadData];
}

- (void)updateBrands:(NSArray *)brandsList
{
    _brandList = brandsList;
     [self reloadData];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *bannerDic = _bannerList[index];
    if ([bannerDic[@"showData"] isKindOfClass:[NSNull class]] || [bannerDic[@"showData"] isEqualToString:@""])
    {
        return;
    }
    
    if ([bannerDic.allKeys containsObject:@"showType"])
    {
        NSNumber *typeNum = bannerDic[@"showType"];
        NSInteger type = [typeNum integerValue];
        if (type == 1)
        {
            ListShopViewController *vc = [[ListShopViewController alloc] init];
            vc.searchString = bannerDic[@"showData"];
            
            if ([bannerDic.allKeys containsObject:@"shopId"])
            {
                if ([bannerDic[@"shopId"] isKindOfClass:[NSNumber class]] || [bannerDic[@"shopId"] isKindOfClass:[NSString class]] )
                {
                    NSNumber *shopId = bannerDic[@"shopId"];
                    vc.shopId = [NSString stringWithFormat:@"%@", shopId];
                }
            }
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:vc animated:YES];
        }
        else if (type == 2)
        {
            IndexListViewController *vc = [[IndexListViewController alloc] init];
            [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/activities/detail" parameters:@{@"id":bannerDic[@"showData"]} success:^(NSURLSessionDataTask *task, id result) {
                
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
            vc.productId = bannerDic[@"showData"];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:vc animated:YES];
        }
        else if (type == 0)
        {
            H5ViewController *vc = [[H5ViewController alloc] init];
            NSString *urlString = bannerDic[@"showData"];
            
//            NSString *testUrl = @"http://test.aulinkc.com/m";
            NSString *testUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
            {
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"] isKindOfClass:[NSString class]])
                {
                    urlString = [NSString stringWithFormat:@"%@/m/user/appRedirect?sessionId=%@&ref=%@",testUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"],[NSString stringWithFormat:@"%@",bannerDic[@"showData"]]];
                }
                else
                    return;
            }
            else
            {
//                [SVProgressHUD showErrorWithStatus:@"请先登录"];
//                [SVProgressHUD dismissWithDelay:0.6];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app.tabbar.selectedViewController pushViewController:[LoginViewController new] animated:YES];
//                });
                return;
            }
            
            vc.urlString = urlString;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:vc animated:YES];
        }
    }
}


@end
