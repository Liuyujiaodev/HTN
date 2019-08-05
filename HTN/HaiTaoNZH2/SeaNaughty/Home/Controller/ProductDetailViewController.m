//
//  ProductDetailViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/6.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProductDetailViewController.h"
#import <WebKit/WebKit.h>
#import "TagView.h"
#import "ProductDetailCell.h"
#import "ProductLogoCell.h"
#import "LLSegmentBar.h"
#import "UIWebView+Finish.h"
#import "CenterBtn.h"
#import "AppDelegate.h"

#import "SppModel.h"
#import "SkuCollectionView.h"
#import "SkuCountCell.h"
#import "TagViewCell.h"
#import "ActivityMsgListVC.h"
#import "PushListVC.h"

@interface ProductDetailViewController () <WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource,LLSegmentBarDelegate,SkuCountDelegate,SkuFilterResultDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ProductModel *model;
@property (nonatomic, strong) ProductModel *firstModel;
//倒计时任务
@property (nonatomic, strong) dispatch_source_t countDownTimer;

@property (nonatomic, assign) NSTimeInterval countDown;
@property (nonatomic, strong) UITextField *numTextField;
@property (nonatomic, assign) int countNum;

@property (nonatomic, strong) LLSegmentBar *segment;
@property (nonatomic, strong) NSMutableArray *urlArray;

@property (nonatomic, strong) WKWebView *webView1;
@property (nonatomic, strong) WKWebView *webView2;
@property (nonatomic, strong) WKWebView *webView3;
@property (nonatomic, strong) WKWebView *webView4;

@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, assign) CGFloat webViewHeight;
@property (nonatomic, strong) UIView *buyView;
@property (nonatomic, strong) CenterBtn *favoriteBtn;

@property (nonatomic, strong) UIImageView *redImageView;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) SkuCollectionView *skuView;
@property (nonatomic, assign) CGFloat skuHeight;
@property (nonatomic, strong) UIView *numBtnView;
@property (nonatomic, strong) NSMutableArray *sourceArray;
@property (nonatomic, strong) NSMutableArray *skuData;
@property (nonatomic, strong) NSArray *selectArray;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIButton *buyBtn;

@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _urlArray = [[NSMutableArray alloc] init];
    
    _segment = [LLSegmentBar segmentBarWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 30)];
    _segment.items = @[@"产品详情",@"产品参数",@"使用指南",@"品牌介绍"];
    _segment.delegate = self;
    _segment.selectIndex = 0;
    [_segment updateWithConfig:^(LLSegmentBarConfig *config) {
        config.indicatorColor(MainColor);
        config.itemSelectColor(MainColor);
        config.itemNormalColor(TextColor);
        config.indicatorW = 5;
    }];
    _segment.backgroundColor = [UIColor whiteColor];
    
    
    _isFirst = YES;
    _heightArray = [[NSMutableArray alloc] initWithArray:@[@"200", @"100", @"100", @"100"]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -G_STATUSBAR_HEIGHT, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-G_TABBAR_HEIGHT+G_STATUSBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = LineColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionHeaderHeight =0;
    _tableView.estimatedSectionFooterHeight =0;
    _tableView.estimatedRowHeight = 100;
    [_tableView registerClass:[ProductLogoCell class] forCellReuseIdentifier:@"ProductLogoCell"];
    [_tableView registerClass:[TagViewCell class] forCellReuseIdentifier:@"TagViewCell"];
    [_tableView registerClass:[ProductDetailCell class] forCellReuseIdentifier:@"ProductDetailCell"];
    [_tableView registerClass:[SkuCountCell class] forCellReuseIdentifier:@"SkuCountCell"];
    [self.view addSubview:_tableView];
    [self.view addSubview:self.buyView];
    
    [self getProductDetail];
    _skuHeight = 0;
    _countNum = 1;
    _selectIndex = 0;
    _sourceArray = [[NSMutableArray alloc] init];
    _skuData = [[NSMutableArray alloc] init];
    
    
    
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, G_STATUSBAR_HEIGHT+20, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = 20;
    backBtn.backgroundColor = LineColor;
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [self getCartNum];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud showAnimated:YES];
    
    
    //
}





#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            if (_model.endTime)
            {
                return G_SCREEN_WIDTH+40;
            }
            return G_SCREEN_WIDTH;
        }
        else if (indexPath.row == 1)
        {
            return 50;
        }
        else
        {
            if (_model.name)
            {
                CGFloat height1 = [_model.name boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+2;
                
                CGFloat height2 = [_model.oneWord boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+2;
                
                return height1+height2+160;
            }
            
            return 240;
        }
        
    }
    else if (indexPath.section == 1)
    {
        return 66+_skuHeight;
    }
    else
    {
        return _webViewHeight;
    }
    return 800;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 30)];
        
        for (UIView *subView in tempView.subviews)
        {
            [subView removeFromSuperview];
        }
        tempView.userInteractionEnabled = YES;
        [tempView addSubview:_segment];
        
        return tempView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 30;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0)
    {
        if (indexPath.row == 0)
        {
            ProductLogoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductLogoCell" forIndexPath:indexPath];
            cell.isSale = _isSale;
            
            if (_model)
            {
                cell.model = _model;
            }
            else if (_firstModel)
            {
                cell.model = _firstModel;
            }
            return cell;
        }
        else if (indexPath.row == 1)
        {
            TagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagViewCell" forIndexPath:indexPath];
            
            if (self.tagArray)
            {
                if (_sourceArray && _sourceArray.count > 0)
                {
                    if ([_tagArray containsObject:@"特价"])
                    {
                        [_tagArray removeObject:@"特价"];
                    }
                }
                cell.tagArray = self.tagArray;
            }
            //
            return cell;
        }
        else
        {
            ProductDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductDetailCell" forIndexPath:indexPath];
            
            if (_model)
            {
                cell.model = _model;
            }
            else if (_firstModel)
            {
                cell.model = _firstModel;
            }
            
            if (_sourceArray.count > 0)
            {
                cell.hiddenOriginPrice = YES;
            }
            else
            {
                cell.hiddenOriginPrice = NO;
            }
            
            return cell;
        }
        
    }
    else if (indexPath.section == 1)
    {
        SkuCountCell *skuCountCell = [tableView dequeueReusableCellWithIdentifier:@"SkuCountCell" forIndexPath:indexPath];
        if (_sourceArray.count > 0 && _skuData.count>0 ) {
            skuCountCell.sourceArray = _sourceArray;
            skuCountCell.skuData = _skuData;
        }
        
        skuCountCell.itemWidth = _itemWidth;
        skuCountCell.skuHeight = _skuHeight;
        skuCountCell.countNum = _countNum;
        skuCountCell.selectArray = _selectArray;
        
        skuCountCell.delegate = self;
        
        return skuCountCell;
    }
    else
    {
        NSString *cellidentifierString = [NSString stringWithFormat:@"cellllllll%li%li",(long)indexPath.section,(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifierString];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifierString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            UIScrollView *webScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 100)];
            webScrollview.showsVerticalScrollIndicator = NO;
            webScrollview.showsHorizontalScrollIndicator = NO;
            webScrollview.tag = 22222;
            webScrollview.scrollEnabled = NO;
            webScrollview.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:webScrollview];
            
        }
        
        UIScrollView *webScrollview = (UIScrollView *)[cell.contentView viewWithTag:22222];
        webScrollview.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, _webViewHeight);
        webScrollview.contentSize = CGSizeMake(G_SCREEN_WIDTH, _webViewHeight);
        
        [webScrollview addSubview:self.webView1];
        
        return cell;
        
    }
}

- (void)postProductSku:(NSDictionary *)sku selectArray:(NSArray *)selectArray
{
    
    NSLog(@"%@", sku);
    
    if (sku.allKeys.count >= 2)
    {
        _selectArray = selectArray;
        [self getProductWithSku:sku[@"sku"]];
        
//        [UIView performWithoutAnimation:^{
//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
////            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
////            [_tableView reloadData];
//        }];
        
    }
    else
    {
        _selectArray = selectArray;
        
        _model = nil;
        
//        [UIView performWithoutAnimation:^{
//            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
////            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
////            [_tableView reloadData];
//        }];
    }
}

- (void)postProductCount:(int)count
{
    _countNum = count;
}


- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //    UIScrollView *webScrollview = (UIScrollView *)[cell.contentView viewWithTag:22222];
    
    if (toIndex != fromIndex)
    {
        self.webView1.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, 50);
        [self.webView1 loadHTMLString:_urlArray[toIndex] baseURL:nil];
        
        _selectIndex = toIndex;
    }
}

#pragma mark - 获取商品详情
- (void)getProductDetail
{
    MJWeakSelf;
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_productId forKey:@"id"];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    }
    
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products/detail" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [_hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            weakSelf.model = [ProductModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.firstModel = [ProductModel yy_modelWithDictionary:result[@"data"]];
            
            if (weakSelf.countDownTimer) {
                dispatch_source_cancel(weakSelf.countDownTimer);
            }
            
            if (weakSelf.model.endTime)
            {
                [weakSelf createSaleEndTimeCountDownTimer];
                weakSelf.countDown = weakSelf.model.endTime;
                dispatch_resume(weakSelf.countDownTimer);
            }
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:weakSelf.model.tags];
            
            
            if (weakSelf.model.zeroShippingFeeQty.length>0)
            {
                NSString *str;
                if ([weakSelf.model.shopId isEqualToString:@"4"])
                {
                    str = [NSString stringWithFormat:@"%@件包邮闪电发货",weakSelf.model.zeroShippingFeeQty];
                }
                else
                {
                    str = [NSString stringWithFormat:@"%@件包邮",weakSelf.model.zeroShippingFeeQty];
                }
                if(![weakSelf.model.zeroShippingFeeQty isEqualToString:@"0"]){
                    [array addObject:str];
                }
                
            }
            
            if (weakSelf.model.limitedQty.length>0)
            {
                NSString *str = [NSString stringWithFormat:@"限购%@件", weakSelf.model.limitedQty];
                [array addObject:str];
            }
            
            if ([weakSelf.model.giftSale isEqualToString:@"1"])
            {
                NSString *str = [NSString stringWithFormat:@"换购"];
                [array addObject:str];
            }
            
            NSDictionary *freePostage = weakSelf.model.freePostage;
            
            if (freePostage.allKeys.count > 0)
            {
                NSString *freePos = [NSString stringWithFormat:@"满%@%@/%@ %@包邮",freePostage[@"firstCurrencyName"],freePostage[@"firstThreshold"],freePostage[@"secondCurrencyName"],freePostage[@"secondThreshold"]];
                [array addObject:freePos];
            }
            
            weakSelf.tagArray = [[NSMutableArray alloc] initWithArray:array];
            
            
            if (weakSelf.model.properties && weakSelf.model.properties.count>0)
            {
                
                NSArray *sppArray = result[@"data"][@"spp"];
                
                for (int i=0; i<sppArray.count; i++)
                {
                    NSDictionary *dic = sppArray[i];
                    NSMutableDictionary *skuDic = [[NSMutableDictionary alloc] init];
                    NSNumber *productId = [dic valueForKey:@"productId"];
                    [skuDic setObject:[NSString stringWithFormat:@"%@",productId] forKey:@"sku"];
                    NSNumber *stock = [dic valueForKey:@"stock"];
                    [skuDic setObject:[NSString stringWithFormat:@"%@", stock] forKey:@"stock"];
                    NSMutableArray *contitionArray = [[NSMutableArray alloc] init];
                    for (int j=0; j<weakSelf.model.properties.count; j++)
                    {
                        NSString *keyString = weakSelf.model.properties[j];
                        [contitionArray addObject:[dic valueForKey:keyString]];
                    }
                    [skuDic setObject:contitionArray forKey:@"contition"];
                    [_skuData addObject:skuDic];
                }
                CGFloat tempHeight = 0;
                
                for (int i=0; i<weakSelf.model.properties.count; i++)
                {
                    NSString *keyString = weakSelf.model.properties[i];
                    NSMutableDictionary *sourceDic = [[NSMutableDictionary alloc] init];
                    [sourceDic setObject:keyString forKey:@"name"];
                    
                    NSMutableArray *skuArray = [[NSMutableArray alloc] init];
                    for (int j=0; j<sppArray.count; j++)
                    {
                        NSDictionary *dic = sppArray[j];
                        NSString *skuString = [dic valueForKey:keyString];
                        if (![skuArray containsObject:skuString]) {
                            [skuArray addObject:skuString];
                        }
                    }
                    
                    NSString *maxString = skuArray[0];
                    for (int n=0; n<skuArray.count; n++)
                    {
                        NSString *nstr = skuArray[n];
                        if (nstr.length > maxString.length)
                        {
                            maxString = nstr;
                        }
                        
                    }
                    
                    int count = 4;
                    _itemWidth = 80;
                    if (maxString.length >= 8)
                    {
                        _itemWidth = maxString.length*11;
                        count = (G_SCREEN_WIDTH-30)/_itemWidth;
                    }
                    
                    tempHeight = (1+skuArray.count/count+(skuArray.count%count > 0 ? 1 : 0))*33+tempHeight;
                    
                    [sourceDic setObject:skuArray forKey:@"value"];
                    
                    [_sourceArray addObject:sourceDic];
                }
                
                _skuHeight = tempHeight+10;
                
                
            }
            
            
            
            if (weakSelf.model.favoriteId.length>0)
            {
                [weakSelf.favoriteBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
                [weakSelf.favoriteBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
                weakSelf.favoriteBtn.selected = YES;
            }
            else
            {
                [weakSelf.favoriteBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                [weakSelf.favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
                weakSelf.favoriteBtn.selected = NO;
            }
            
            NSString *header = @"";
            
            NSString *urlString1 = [NSString stringWithFormat:@"%@%@",header,weakSelf.model.news];
            NSString *urlString2 = [NSString stringWithFormat:@"%@%@",header,weakSelf.model.params];
            NSString *urlString3 = [NSString stringWithFormat:@"%@%@",header,weakSelf.model.guide];
            NSString *urlString4 = @"";
            if ([weakSelf.model.brandInfo isKindOfClass:[NSDictionary class]])
            {
                NSString *temp = weakSelf.model.brandInfo[@"intro"] ? weakSelf.model.brandInfo[@"intro"] : @"";
                
                NSString *brandInfo = weakSelf.model.brandInfo[@"detail"];
                
                
                urlString4 = [NSString stringWithFormat:@"%@%@%@",header,temp,brandInfo];
            }
            
            if ([weakSelf.model.stock isKindOfClass:[NSString class]] && [weakSelf.model.stock isEqualToString:@"售罄"])
            {
                [_buyBtn setTitle:@"已售罄" forState:UIControlStateNormal];
                _buyBtn.backgroundColor = RGBCOLOR(204, 204, 204);
                _buyBtn.enabled = NO;
            }
            else
            {
                _buyBtn.backgroundColor = MainColor;
                [_buyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
                _buyBtn.enabled = YES;
            }
            
            //            weakSelf.urlArray = @[weakSelf.model.news,weakSelf.model.params,weakSelf.model.guide,weakSelf.model.guide];
            
            [weakSelf.urlArray addObjectsFromArray:@[urlString1, urlString2, urlString3, urlString4]];
            
            [weakSelf.webView1 loadHTMLString:urlString1 baseURL:nil];
            //            [weakSelf.webView2 loadHTMLString:urlString2 baseURL:nil];
            //            [weakSelf.webView3 loadHTMLString:urlString3 baseURL:nil];
            //            [weakSelf.webView4 loadHTMLString:urlString4 baseURL:nil];
            
            [weakSelf.tableView reloadData];
            
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.detailsLabel.text = result[@"message"];
                [hud removeFromSuperViewOnHide];
                hud.mode = MBProgressHUDModeText;
                [hud hideAnimated:YES afterDelay:1.2];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


- (void)getProductWithSku:(NSString*)sku
{
    MJWeakSelf;
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:sku forKey:@"id"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products/detail" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        [loadingHud hideAnimated:YES];
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            weakSelf.model = [ProductModel yy_modelWithDictionary:result[@"data"]];
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:weakSelf.model.tags];
            
            
            if (weakSelf.model.zeroShippingFeeQty.length>0)
            {
                NSString *str;
                if ([weakSelf.model.shopId isEqualToString:@"4"])
                {
                    str = [NSString stringWithFormat:@"%@件包邮闪电发货",weakSelf.model.zeroShippingFeeQty];
                }
                else
                {
                    str = [NSString stringWithFormat:@"%@件包邮",weakSelf.model.zeroShippingFeeQty];
                }
                if(![weakSelf.model.zeroShippingFeeQty isEqualToString:@"0"]){
                    [array addObject:str];
                }
                
            }
            
            if (weakSelf.model.limitedQty.length>0)
            {
                NSString *str = [NSString stringWithFormat:@"限购%@件", weakSelf.model.limitedQty];
                [array addObject:str];
            }
            
            if ([weakSelf.model.giftSale isEqualToString:@"1"])
            {
                NSString *str = [NSString stringWithFormat:@"换购"];
                [array addObject:str];
            }
            
            NSDictionary *freePostage = weakSelf.model.freePostage;
            
            if (freePostage.allKeys.count > 0)
            {
                NSString *freePos = [NSString stringWithFormat:@"满%@%@/%@ %@包邮",freePostage[@"firstCurrencyName"],freePostage[@"firstThreshold"],freePostage[@"secondCurrencyName"],freePostage[@"secondThreshold"]];
                [array addObject:freePos];
            }
            
            weakSelf.tagArray = array;
            
            if ([weakSelf.model.stock isKindOfClass:[NSString class]] && [weakSelf.model.stock isEqualToString:@"售罄"])
            {
                [_buyBtn setTitle:@"已售罄" forState:UIControlStateNormal];
                _buyBtn.backgroundColor = RGBCOLOR(204, 204, 204);
                _buyBtn.enabled = NO;
            }
            else
            {
                _buyBtn.backgroundColor = MainColor;
                [_buyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
                _buyBtn.enabled = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView performWithoutAnimation:^{
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                    [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
                }];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.detailsLabel.text = result[@"message"];
                [hud removeFromSuperViewOnHide];
                hud.mode = MBProgressHUDModeText;
                [hud hideAnimated:YES afterDelay:1.2];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
        
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
    dispatch_source_set_timer(_countDownTimer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 1.0*NSEC_PER_SEC);
    
    //设置执行事件
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_countDownTimer, ^{
        [weakSelf updateSaleEndTimeString];
    });
    
}

- (void)updateSaleEndTimeString
{
    
    MJWeakSelf;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ProductLogoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.saleEndTimeSecond = weakSelf.countDown;
        
        
    });
    
}


- (void)decreaseBtnAction
{
    
    if (_countNum > 0)
    {
        _countNum --;
        _numTextField.text = [NSString stringWithFormat:@"%i", _countNum];
    }
}

- (void)increaseBtnAction
{
    _countNum ++;
    _numTextField.text = [NSString stringWithFormat:@"%i", _countNum];
    
}


- (WKWebView *)webView1
{
    if (!_webView1)
    {
        //        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        
        wkWebConfig.userContentController = wkUController;
        
        _webView1 = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 200) configuration:wkWebConfig];
        _webView1.navigationDelegate = self;
        _webView1.scrollView.scrollEnabled = NO;
        _webView1.backgroundColor = [UIColor whiteColor];
        _webView1.tag = 100;
    }
    return _webView1;
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
    
        NSString *heightStr = [NSString stringWithFormat:@"%@",any];
        
        _webViewHeight = [heightStr floatValue]+10;
        
        self.webView1.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, _webViewHeight);
        
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (webView.tag == 100)
    {
        [_hud hideAnimated:YES];
        
    }
    webView.scrollView.scrollEnabled = NO;
    int tag = (int)webView.tag - 100;
    if ([webView isFinishLoading] && !webView.isLoading)
    {
        CGFloat height1 = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
        
        [_heightArray replaceObjectAtIndex:tag withObject:[NSString stringWithFormat:@"%f", height1]];
        
        _webViewHeight = [_heightArray[0] floatValue];
        [UIView performWithoutAnimation:^{
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:2];
            [_tableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        webView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, height1);
    }
}


- (UIView *)buyView
{
    if (!_buyView)
    {
        _buyView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-G_TABBAR_HEIGHT, G_SCREEN_WIDTH, 49)];
        _buyView.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_buyView addSubview:lineView];
        
        NSArray *array = @[@"首页",@"收藏",@"购物车"];
        CGFloat magrin = (G_SCREEN_WIDTH*0.6-48*3)/6;
        
        for (int i=0; i<3; i++)
        {
            CenterBtn *btn = [[CenterBtn alloc] initWithFrame:CGRectMake(magrin*(2*i+1)+48*i, 1, 48, 48)];
            
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [_buyView addSubview:btn];
            
            if (i == 1)
            {
                _favoriteBtn = btn;
            }
            else if (i == 2)
            {
                _redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 15, 15)];
                _redImageView.image = [UIImage imageNamed:@"椭圆"];
                [btn addSubview:_redImageView];
                
                _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 15, 15)];
                
                _numLabel.textAlignment = NSTextAlignmentCenter;
                _numLabel.font = [UIFont systemFontOfSize:10];
                _numLabel.textColor = [UIColor whiteColor];
                [btn addSubview:_numLabel];
            }
            
        }
        
        _buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH*0.6, 1, G_SCREEN_WIDTH*0.4, 48)];
        _buyBtn.backgroundColor = MainColor;
        [_buyBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        [_buyView addSubview:_buyBtn];
        
    }
    return _buyView;
}

- (void)btnClicked:(UIButton *)btn
{
    MJWeakSelf;
    
    int temp = (int)btn.tag;
    
    if (temp == 1000)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            app.tabbar.selectedIndex = 0;
        });
        
        
    }
    else if (temp == 1001)
    {
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
        {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
        
        _favoriteBtn.selected = !_favoriteBtn.selected;
        
        if (!_favoriteBtn.selected)
        {
            [param setObject:_model.favoriteId forKey:@"id"];
            
            [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/favorites/remove" parameters:param success:^(NSURLSessionDataTask *task, id result) {
                
                
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
                    [weakSelf.favoriteBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                    //                    weakSelf.favoriteBtn.selected = NO;
                    [weakSelf.favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
                }
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
        else
        {
            [param setObject:_productId forKey:@"productId"];
            
            [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/favorites/add" parameters:param success:^(NSURLSessionDataTask *task, id result) {
                
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
                    NSNumber *favorite = result[@"data"][@"id"];
                    _model.favoriteId = [NSString stringWithFormat:@"%@",favorite];
                    [weakSelf.favoriteBtn setImage:[UIImage imageNamed:@"收藏1"] forState:UIControlStateNormal];
                    [weakSelf.favoriteBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
                }
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
        
        
        
    }
    else if (temp == 1002)
    {
        //        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //        app.tabbar.selectedIndex = 2;
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        ShoppingCarViewController *vc = [[ShoppingCarViewController alloc] init];
        //        self.hidesBottomBarWhenPushed = NO;
        vc.isSecond = YES;
        [self.navigationController pushViewController:vc  animated:YES];
        
        
    }
    
    
}

#pragma mark - 加入购物车
- (void)buyAction
{
    
//    //商品详情需要登录的时候修改
//    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
//    {
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    
    if (!_model)
    {
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:_model.productId forKey:@"productId"];
    [param setObject:_model.shopId forKey:@"shopId"];
    [param setObject:[NSString stringWithFormat:@"%i",_countNum] forKey:@"quantity"];
    [param setObject:_model.giftSale forKey:@"giftSale"];
    
    MJWeakSelf;
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/add" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [hud hideAnimated:YES];
        
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud1.mode = MBProgressHUDModeText;
            hud1.label.text = @"添加成功!";
            [hud1 hideAnimated:YES afterDelay:1.2];
            [weakSelf getCartNum];
        }
        else
        {
            MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud1.mode = MBProgressHUDModeText;
            hud1.detailsLabel.text = result[@"message"];
            [hud1 hideAnimated:YES afterDelay:1.2];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (UIView *)numBtnView
{
    if (!_numBtnView)
    {
        _numBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 11, G_SCREEN_WIDTH, 44)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 50, 26)];
        label.text = @"数量";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = LightGrayColor;
        [_numBtnView addSubview:label];
        
        UIButton *decreaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 6, 35, 32)];
        [decreaseBtn setTitle:@" - " forState:UIControlStateNormal];
        [decreaseBtn setTitleColor:TextColor forState:UIControlStateNormal];
        decreaseBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        decreaseBtn.layer.borderColor = LightGrayColor.CGColor;
        decreaseBtn.layer.borderWidth = 1;
        [decreaseBtn addTarget:self action:@selector(decreaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_numBtnView addSubview:decreaseBtn];
        
        UIButton *increaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(173, 6, 35, 32)];
        [increaseBtn setTitle:@" + " forState:UIControlStateNormal];
        [increaseBtn setTitleColor:TextColor forState:UIControlStateNormal];
        increaseBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        increaseBtn.layer.borderColor = LightGrayColor.CGColor;
        increaseBtn.layer.borderWidth = 1;
        [increaseBtn addTarget:self action:@selector(increaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_numBtnView addSubview:increaseBtn];
        
        _numTextField = [[UITextField alloc] initWithFrame:CGRectMake(116, 6, 56, 32)];
        _numTextField.layer.borderColor = LightGrayColor.CGColor;
        _numTextField.layer.borderWidth = 1;
        _numTextField.text = @"1";
        _numTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numTextField.textAlignment = NSTextAlignmentCenter;
        _numTextField.textColor = TitleColor;
        [_numBtnView addSubview:_numTextField];
    }
    return _numBtnView;
}

#pragma mark - 获取购物车数量
- (void)getCartNum
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    MJWeakSelf;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/cart/count" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            weakSelf.numLabel.text = [result[@"data"][@"count"] stringValue];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)backClick
{
    
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
//    if (self.isFromMessage)
//    {
//         self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
