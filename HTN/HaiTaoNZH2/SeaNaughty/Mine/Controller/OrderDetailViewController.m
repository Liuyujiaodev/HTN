//
//  OrderDetailViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/15.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderModel.h"
#import "FirstSectionCell.h"
#import "SecondSectionCell.h"
#import "ThirdOrderCell.h"
#import "FourthFeeCell.h"
#import "FifthCell.h"
#import "WuliuViewController.h"
#import "ShopListModel.h"
#import "AlertView.h"
#import "PayViewController.h"
#import "ShoppingCarViewController.h"
#import "ProductDetailViewController.h"
#import "ChatListVC.h"

@interface OrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, assign) NSInteger sectionNum;
@property (nonatomic, strong) NSMutableArray *feeArray;
@property (nonatomic, strong) AlertView *alertView;


@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    _sectionNum = 5;
    _feeArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToWuliu:) name:@"POSTAGECLICK" object:nil];
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self getOrderDetail];
}

- (void)initUI
{
    CGFloat temp = G_STATUSBAR_HEIGHT > 20 ? 20 : 0;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-temp) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[FirstSectionCell class] forCellReuseIdentifier:@"FirstSectionCell"];
    [_tableView registerClass:[SecondSectionCell class] forCellReuseIdentifier:@"SecondSectionCell"];
    [_tableView registerClass:[ThirdOrderCell class] forCellReuseIdentifier:@"ThirdOrderCell"];
    [_tableView registerClass:[FourthFeeCell class] forCellReuseIdentifier:@"FourthFeeCell"];
    [_tableView registerClass:[FifthCell class] forCellReuseIdentifier:@"FifthCell"];
    
    [self.view addSubview:_tableView];
    
    if (self.fromPush)
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
        [leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backBtnClickk) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
}

- (void)backBtnClickk
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionNum;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
    {
        return _model.products.count;
    }
    else if (section == 4)
    {
        return _feeArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        NSString *string = [NSString stringWithFormat:@"%@ %@ %@ %@", _model.receiveProvince, _model.receiveCity, _model.receiveArea, _model.receiveAddress];
        
        
        CGFloat height = [string boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height+3;
        
        if (_model.sendPhone.length>0 || _model.sendName.length > 0 || _model.sendAddress.length > 0)
        {
            return height+130;
        }
        
        return height+64;
    }
    else if (indexPath.section == 2)
    {
        if (_model.customerComment && _model.customerComment.length > 0)
        {
            return 33;
        }
        else
            return 0.001;
    }
    else if (indexPath.section == 3)
    {
        return 86;
    }
    else if (indexPath.section == 4 || indexPath.section == 5)
    {
        return 40;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3 )
    {
        return 44;
    }
    else
        return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 44)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43, G_SCREEN_WIDTH-30, 1)];
        lineView.backgroundColor = LineColor;
        [view addSubview:lineView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 14, 14)];
        imageView.image = [UIImage imageNamed:@"店铺"];
        [view addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, G_SCREEN_WIDTH-80, 44)];
        nameLabel.text = _model.shopName;
        nameLabel.textColor = TextColor;
        nameLabel.font = [UIFont systemFontOfSize:13];
        [view addSubview:nameLabel];
        
        CGFloat width = [_model.shopName boundingRectWithSize:CGSizeMake(500, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width+60;
        
//        NSArray *array = @[@"1", @"4", @"5", @"1000000", @"1000001"];
        NSArray *array = @[@"新西兰直邮仓", @"中国快快仓", @"全球精选仓", @"澳洲直邮仓", @"新西兰直邮RMP奶粉仓"];
        if ([array containsObject:_model.shopName])
        {
            UIButton *reBuyBtn = [[UIButton alloc] initWithFrame:CGRectMake(width, 0, 80, 44)];
            [reBuyBtn setTitle:@" 再来一单" forState:UIControlStateNormal];
            [reBuyBtn setTitleColor:TextColor forState:UIControlStateNormal];
            [reBuyBtn setImage:[UIImage imageNamed:@"订单"] forState:UIControlStateNormal];
            reBuyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [reBuyBtn addTarget:self action:@selector(reBuy) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:reBuyBtn];
        }
        
        
        
        UIButton *kefuBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-95, 0, 80, 44)];
        [kefuBtn setTitle:@" 联系客服" forState:UIControlStateNormal];
        [kefuBtn setTitleColor:TextColor forState:UIControlStateNormal];
        [kefuBtn setImage:[UIImage imageNamed:@"客服"] forState:UIControlStateNormal];
        kefuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [kefuBtn addTarget:self action:@selector(kefu) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:kefuBtn];
        
        return view;
    }
    else
        return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 8)];
    view.backgroundColor = LineColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstSectionCell" forIndexPath:indexPath];
        if (_model)
        {
            cell.model = _model;
            cell.miandan = _miandan;
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        SecondSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondSectionCell" forIndexPath:indexPath];
        if (_model)
        {
            cell.model = _model;
        }
        return cell;
    }
    else if (indexPath.section == 2)
    {
        NSString *identifierString = [NSString stringWithFormat:@"cellkkkk"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 33)];
            label.tag = 10000;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = TextColor;
            [cell.contentView addSubview:label];
        }
        
        if (_model.customerComment && _model.customerComment.length > 0)
        {
            UILabel *label = [cell.contentView viewWithTag:10000];
            label.text = [NSString stringWithFormat:@"备注:%@", _model.customerComment];
        }
        
        return cell;
    }
    else if (indexPath.section == 3)
    {
        ThirdOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdOrderCell" forIndexPath:indexPath];
        if (_model.products.count > 0)
        {
            ProductModel *model = _model.products[indexPath.row];
            cell.model = model;
        }
        return cell;
        
    }
    else if (indexPath.section == 4)
    {
        FourthFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FourthFeeCell" forIndexPath:indexPath];
        if (_feeArray.count > 0)
        {
            NSDictionary *dic = _feeArray[indexPath.row];
            
            cell.feeDictionary = dic;
            
        }
        return cell;
    }
    else if (indexPath.section == 5)
    {
        FourthFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FourthFeeCell" forIndexPath:indexPath];
        
        NSString *payType = @"微信支付";
        if ([_model.paymentMethod isEqualToString:@"2"])
        {
            payType = @"余额支付";
        }
        else if ([_model.paymentMethod isEqualToString:@"3"])
        {
            payType = @"线下支付";
        }
        else if ([_model.paymentMethod isEqualToString:@"4"])
        {
            payType = @"余额+微信";
        }
        else if ([_model.paymentMethod isEqualToString:@"5"])
        {
            payType = @"余额+线下";
        }
        else if ([_model.paymentMethod isEqualToString:@"6"])
        {
            payType = @"支付宝支付";
        }
        else if ([_model.paymentMethod isEqualToString:@"7"])
        {
            payType = @"余额+支付宝";
        }
        
        cell.feeDictionary = @{@"name":@"支付方式:", @"fee":payType};
        return cell;
    }
    else if (indexPath.section == 6)
    {
        FifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FifthCell" forIndexPath:indexPath];
        cell.model = _model;
        return cell;
    }
    NSString *identifierString = [NSString stringWithFormat:@"cell%li%li",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2)
    {
        ProductModel *model = _model.products[indexPath.row];
        ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
        vc.productId = model.productId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}



- (void)goToWuliu:(NSNotification *)notification
{
    WuliuViewController *vc = [[WuliuViewController alloc] init];
    vc.courierCode = _model.courierCode;
    vc.shippingNumber = notification.object;
    vc.courierName = _model.courierName;
    vc.website = _model.website;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取订单信息
- (void)getOrderDetail
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:_orderId forKey:@"orderId"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    MJWeakSelf;
    _sectionNum = 5;
    [_feeArray removeAllObjects];
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/orders/detail" parameters:param success:^(NSURLSessionDataTask *task, id result) {
     
        [loadingHud hideAnimated:YES];
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            weakSelf.model = [OrderModel yy_modelWithDictionary:result[@"data"]];
            NSString *goodsFee = @"0";
            if (weakSelf.model.firstGoodsAmount)
            {
                goodsFee = [NSString stringWithFormat:@"%@ %@/%@ %@", weakSelf.model.firstCurrencyName, [self moneyWithString:weakSelf.model.firstGoodsAmount], weakSelf.model.secondCurrencyName, [self moneyWithString:weakSelf.model.secondGoodsAmount]];
            }
            
            [weakSelf.feeArray addObject:@{@"name":@"商品合计",@"fee":goodsFee}];
            
            if (weakSelf.model.firstShippingFeeAmount)
            {
                [weakSelf.feeArray addObject:@{@"name":@"运费",@"fee":[NSString stringWithFormat:@"%@ %@/%@ %@", weakSelf.model.firstCurrencyName, [self moneyWithString:weakSelf.model.firstShippingFeeAmount], weakSelf.model.secondCurrencyName, [self moneyWithString:weakSelf.model.secondShippingFeeAmount]]}];
            }
            
            if (weakSelf.model.firstDiscountAmount)
            {
                
                
                [weakSelf.feeArray addObject:@{@"name":@"优惠",@"fee":[NSString stringWithFormat:@"%@ %@/%@ %@", weakSelf.model.firstCurrencyName, [self moneyWithString:weakSelf.model.firstDiscountAmount], weakSelf.model.secondCurrencyName, [self moneyWithString:weakSelf.model.secondDiscountAmount]]}];
            }
            
           
            
            
            NSString *tempName = @"待付";
            if (weakSelf.model.payTime.length > 0)
            {
                tempName = @"实付";
                weakSelf.sectionNum ++;
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.bottomView.hidden = NO;
                    CGFloat temp = G_STATUSBAR_HEIGHT > 20 ? 20 : 0;
                    weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-50-temp);
                });
            }
            
            if (weakSelf.model.status == 5)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CGFloat temp = G_STATUSBAR_HEIGHT > 20 ? 20 : 0;
                    weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-50-temp);
                    weakSelf.bottomView.hidden = NO;
                    weakSelf.btn1.hidden = YES;
                    weakSelf.btn2.hidden = YES;
                    weakSelf.btn3.hidden = NO;
                });
                
            }
            
            if (weakSelf.model.shippingNumber.length > 0)
            {
                weakSelf.sectionNum++;
            }
            
            if (_miandan)
            {
                [weakSelf.feeArray addObject:@{@"name":tempName,@"fee":@"免单"}];
//                 weakSelf.bottomView.hidden = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.bottomView.hidden = YES;
                    CGFloat temp = G_STATUSBAR_HEIGHT > 20 ? 20 : 0;
                    weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-temp);
                });
            }
            else
            {
                [weakSelf.feeArray addObject:@{@"name":tempName,@"fee":[NSString stringWithFormat:@"%@ %@/%@ %@", weakSelf.model.firstCurrencyName, [self moneyWithString:weakSelf.model.firstAmount], weakSelf.model.secondCurrencyName, [self moneyWithString:weakSelf.model.secondAmount]]}];
            }
            
         
            
            if (weakSelf.model.status == 6 || weakSelf.model.status == 4 || weakSelf.model.status == 8)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                [weakSelf.bottomView removeFromSuperview];
                    weakSelf.bottomView.hidden = YES;
                    
                });
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            [SVProgressHUD dismissWithDelay:0.5];
        }
        
        
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark - 取消订单
- (void)cancleOrder
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"取消订单后，此订单的商品需要重新购买，确定要继续吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
        [param setObject:self.model.orderNumber forKey:@"orderNumber"];
        
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/cancel" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"取消成功";
                    [hud hideAnimated:YES afterDelay:1.2];
                    
                    [self getOrderDetail];
                });
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }];
    
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - 确认收货
- (void)receiveConfirme
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请收到货后再点击”确定“,否则可能钱财两空哦~" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
        [param setObject:self.model.orderNumber forKey:@"orderNumber"];
        
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/receive-confirmed" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"确认收货成功";
                    [hud hideAnimated:YES afterDelay:1.2];
                    
                    [self getOrderDetail];
                    
                });
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark - 去付款
- (void)payAction
{
    PayViewController *vc = [[PayViewController alloc] init];
    
    vc.idArray = @[self.orderId];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 再来一单
- (void)reBuy
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:SHOPLIST];
//    MJWeakSelf;
    __block NSString *shopId = @"";
    ShopListModel *listModel = [ShopListModel yy_modelWithDictionary:dic];
    NSArray *shopArray = listModel.data;
    [shopArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ShopModel *model = obj;
        if ([model.name isEqualToString:_model.shopName])
        {
            shopId = model.shopId;
        }
    }];
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//    BOOL tempSuccess;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[NSUserDefaults standardUserDefaults] valueForKey:@"SHOPLIST"];
    
    
    dispatch_group_async(group, queue, ^{
        
        for (int i=0; i<_model.products.count; i++)
        {
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
            ProductModel *product = _model.products[i];
            
            [param setObject:product.productId forKey:@"productId"];
            [param setObject:shopId forKey:@"shopId"];
            [param setObject:product.orderedQty forKey:@"quantity"];
            [param setObject:@"0" forKey:@"giftSale"];
            
            [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/add" parameters:param success:^(NSURLSessionDataTask *task, id result) {
                
                
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
                    [tempArray addObject:@"1"];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                        hud1.mode = MBProgressHUDModeText;
//                        hud1.label.text = @"添加成功!";
//                        [hud1 hideAnimated:YES afterDelay:1.2];
                    });
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    [SVProgressHUD dismissWithDelay:1.2];
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    dispatch_semaphore_signal(semaphore);
                });
                
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                [tempArray addObject:@"0"];
                dispatch_semaphore_signal(semaphore);
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    });
    
    
    
     dispatch_group_notify(group, queue, ^{

         dispatch_async(dispatch_get_main_queue(), ^{
             [hud hideAnimated:YES];
             ShoppingCarViewController *vc = [[ShoppingCarViewController alloc] init];
             vc.isSecond = YES;
             [self.navigationController pushViewController:vc animated:YES];
         });
     });
}

#pragma mark - 客服
- (void)kefu
{
//    [self.view bringSubviewToFront:self.alertView];
//    self.alertView.hidden = NO;
    ChatListVC *vc = [[ChatListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除订单
- (void)delOrder
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除的订单无法查看和申请售后" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"继续删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
        [param setObject:@[self.orderId] forKey:@"orderIds"];
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/del" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.label.text = @"删除成功";
                    [hud hideAnimated:YES afterDelay:1.2];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        CGFloat temp = G_STATUSBAR_HEIGHT > 20 ? 20 : 0;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-50-temp, G_SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
        [self.view addSubview:_bottomView];
        
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-160, 13, 80, 24)];
        [_btn1 setTitle:@"取消订单" forState:UIControlStateNormal];
        [_btn1 setTitleColor:LightGrayColor forState:UIControlStateNormal];
        _btn1.layer.cornerRadius = 3;
        _btn1.layer.borderWidth = 1;
        _btn1.layer.borderColor = LightGrayColor.CGColor;
        _btn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn1 addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_btn1];
        
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-65, 13, 50, 24)];
        [_btn2 setTitle:@"付款" forState:UIControlStateNormal];
        [_btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn2.backgroundColor = MainColor;
        _btn2.layer.cornerRadius = 3;
        _btn2.layer.borderWidth = 1;
        _btn2.layer.borderColor = MainColor.CGColor;
        _btn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn2 addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_btn2];
        
        _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-105, 13, 80, 24)];
        [_btn3 setTitle:@"确认收货" forState:UIControlStateNormal];
        [_btn3 setTitleColor:LightGrayColor forState:UIControlStateNormal];
        _btn3.layer.cornerRadius = 3;
        _btn3.layer.borderWidth = 1;
        _btn3.layer.borderColor = LightGrayColor.CGColor;
        _btn3.hidden = YES;
        [_btn3 addTarget:self action:@selector(receiveConfirme) forControlEvents:UIControlEventTouchUpInside];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:13];
        [_bottomView addSubview:_btn3];
    }
    return _bottomView;
}

- (AlertView *)alertView
{
    if (!_alertView)
    {
        _alertView = [[AlertView alloc] initWithFrame:G_SCREEN_BOUNDS];
        [self.view addSubview:_alertView];
    }
    return _alertView;
}


- (NSString *)moneyWithString:(NSString *)str
{
    CGFloat price = [str floatValue];
    if (str.length > 8)
    {
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        str = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    return str;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
