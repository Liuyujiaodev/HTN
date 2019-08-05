//
//  ConfirmOrderVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "OrderFeeView.h"
#import "ReceiveCell.h"
#import "DeliverCell.h"
#import "OrderCell.h"
#import "OrderBottomCell.h"
#import "RecentReceiverVC.h"
#import "RecentDeliverVC.h"
#import "PayViewController.h"
#import "ProvincesVC.h"
#import "BaseNavigationVC.h"
#import "RedpacketVC.h"
#import "TextAlertView.h"

@interface ConfirmOrderVC () <UITableViewDelegate, UITableViewDataSource, ReceiveCellDelegate, RecentReceiverVCDelegate, DeliverCellDelegate,RecentDeliverVCDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) OrderFeeView *feeView;
@property (nonatomic, assign) float tempHeight;
@property (nonatomic, assign) BOOL mustHaveId;
@property (nonatomic, assign) BOOL hasHeaderView;
@property (nonatomic, strong) NSDictionary *receiveDic;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, assign) BOOL saveReciver;
@property (nonatomic, assign) BOOL saveDeliver;
@property (nonatomic, strong) NSDictionary *deliverDic;
@property (nonatomic, strong) TextAlertView *alertView;
@property (nonatomic, strong) TextAlertView *alertView1;

@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    self.title = @"确认";
    _mustHaveId = NO;
    _saveReciver = NO;
    _saveDeliver = NO;
    
    
    for (CartModel *model in _allModel.detail)
    {
        if ([model.checked isEqualToString:@"1"])
        {
            if ([model.shopId isEqualToString:@"1000000"] || [model.shopId isEqualToString:@"1000001"] || [model.shopId isEqualToString:@"5"])
            {
                _mustHaveId = YES;
            }
        }
        
        if ([model.shopId isEqualToString:@"1"])
        {
            _hasHeaderView = YES;
        }
        
        
        for (ProductModel *product in model.orderItems)
        {
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:model.orderItems];
            
            if ([product.checked isEqualToString:@"0"])
            {
                [array removeObject:product];
            }
            model.orderItems = (NSMutableArray <ProductModel *> *)array;
        }
        
        NSMutableArray *cartArray = [[NSMutableArray alloc] initWithArray:_allModel.detail];
        
        
        if (model.orderItems.count == 0)
        {
            [cartArray removeObject:model];
        }
        
        _allModel.detail = (NSArray <CartModel *> *)cartArray;
        

    }
    
    [self initUI];
    
}

- (void)initUI
{
    _tempHeight = 0;
    if (G_STATUSBAR_HEIGHT > 20)
    {
        _tempHeight = 20;
    }
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-_tempHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = LineColor;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[ReceiveCell class] forCellReuseIdentifier:@"ReceiveCell"];
    [_tableView registerClass:[DeliverCell class] forCellReuseIdentifier:@"DeliverCell"];
    [_tableView registerClass:[OrderCell class] forCellReuseIdentifier:@"OrderCell"];
    [_tableView registerClass:[OrderBottomCell class] forCellReuseIdentifier:@"OrderBottomCell"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 60)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#FFFDF3"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 20, 20, 20)];
    imageView.image = [UIImage imageNamed:@"感叹号"];
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, G_SCREEN_WIDTH-55, 60)];
    label.numberOfLines = 0;
    label.textColor = TitleColor;
    label.font = [UIFont systemFontOfSize:12];
//    label.text = @"新西兰本地邮寄运费不同，麻烦下单联系客服更改邮费后安排发货";
    label.text = @"2019年3月16日起，网站公众号不再提供新西兰本地邮寄业务。 如有任何疑问，请联系公众号客服";
    [headerView addSubview:label];
    if (_hasHeaderView)
    {
        _tableView.tableHeaderView = headerView;
    }

    [self.view addSubview:self.bottomView];
    _feeView.model = _allModel;
    
    
}


#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2+_allModel.detail.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section>1)
    {
        CartModel *model = _allModel.detail[section-2];
        return model.orderItems.count+1;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 280;
    }
    else if (indexPath.section == 1)
    {
        return 200;
    }
    else
    {
        CartModel *model = _allModel.detail[indexPath.section-2];
        if (indexPath.row > model.orderItems.count)
        {
            return 107;
        }
        return 120;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 0.001;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return [UIView new];
    }
    else
    {
        CartModel *model = _allModel.detail[section-2];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 50)];
        view.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = TitleColor;
        label.text = model.shopName;
        [view addSubview:label];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [view addSubview:lineView];
        return view;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJWeakSelf;
    if (indexPath.section == 0)
    {
        ReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiveCell" forIndexPath:indexPath];
        cell.mustHaveId = _mustHaveId;
        cell.delegate = self;
        [cell handlerButtonAction:^(NSDictionary *dic) {
            
            if ([dic.allKeys containsObject:@"save"])
            {
                weakSelf.saveReciver = YES;
            }
            else if ([dic.allKeys containsObject:@"unsave"])
            {
                weakSelf.saveReciver = NO;
            }
            else
            {
                weakSelf.receiveDic = [NSDictionary dictionaryWithDictionary:dic];
            }
            
        }];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        DeliverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliverCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell handlerButtonAction:^(NSDictionary *dic) {
            if ([dic.allKeys containsObject:@"save"])
            {
                weakSelf.saveDeliver = YES;
            }
            else if ([dic.allKeys containsObject:@"unsave"])
            {
                weakSelf.saveDeliver = NO;
            }
            else
            {
                weakSelf.deliverDic = [NSDictionary dictionaryWithDictionary:dic];
            }
        }];
        
        return cell;
    }
    else
    {
        CartModel *model = _allModel.detail[indexPath.section-2];
        
        if (indexPath.row < model.orderItems.count)
        {
            OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
            cell.model = model.orderItems[indexPath.row];
            return cell;
        }
        else
        {
            OrderBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderBottomCell" forIndexPath:indexPath];
            cell.model = model;
        
            return cell;
        }
        
    }
    
}


- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-120-_tempHeight, G_SCREEN_WIDTH, 120)];
        [self.view addSubview:_bottomView];
        
        _feeView = [[OrderFeeView alloc] init];
        [_bottomView addSubview:_feeView];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, G_SCREEN_WIDTH/2, 50)];
        backBtn.backgroundColor = [UIColor whiteColor];
        [backBtn setTitle:@"返回购物车" forState:UIControlStateNormal];
        [backBtn setTitleColor:MainColor forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:backBtn];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2,70, G_SCREEN_WIDTH/2, 50)];
        sureBtn.backgroundColor = MainColor;
        [sureBtn setTitle:@"结算" forState:UIControlStateNormal];
        
        for (CartModel *cart in _allModel.detail)
        {
            if ([cart.shopId isEqualToString:@"1"] || [cart.shopId isEqualToString:@"4"])
            {
                [sureBtn setTitle:@"领取红包并下单" forState:UIControlStateNormal];
                sureBtn.backgroundColor = [UIColor redColor];
            }
        }
        
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sureBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:sureBtn];
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 70, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_bottomView addSubview:lineView];
        
    }
    return _bottomView;
}

#pragma mark - 返回购物车
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确认订单
- (void)orderAction
{
    if (self.showAlert)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单中包含的赠品已无货,不再补发,是否确认继续下单？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"返回购物车检查" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定继续下单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self hhh];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self hhh];
    }
    
}

- (void)hhh
{
    MJWeakSelf;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    NSArray *array = [_area componentsSeparatedByString:@" "];
    
    NSString *name = [_receiveDic valueForKey:@"receiveName"];
    
    NSString *phone = [_receiveDic valueForKey:@"receivePhone"];
    
    NSString *address = [_receiveDic valueForKey:@"receiveAddress"];
    
    NSString *idCard = [_receiveDic valueForKey:@"receiveIdCard"];
    
   
    
    //    [param setObject:@"" forKey:@"freePostageId"];
    
    NSMutableArray *ordersArray = [[NSMutableArray alloc] init];
    NSMutableArray *idArray = [[NSMutableArray alloc] init];
    
    if (name.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人姓名"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    if (phone.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人号码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (address.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人地址"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (idCard.length == 0 && _mustHaveId)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人身份证号"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (![self judgePhoneStringValid:phone])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    
    if (_mustHaveId)
    {
        if (![self judgeIdentityStringValid:idCard])
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号"];
            [SVProgressHUD dismissWithDelay:1.2];
            return;
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    [param setDictionary:_receiveDic];
    NSString *province = array[0] ? array[0] : @"";
    NSString *city = array[1] ? array[1] : @"";
    NSString *area = array[2] ? array[2] : @"";
    [param setObject:province forKey:@"receiveProvince"];
    [param setObject:city forKey:@"receiveCity"];
    [param setObject:area forKey:@"receiveArea"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    if (_saveReciver == YES)
    {
        [param setObject:@"1" forKey:@"needSaveReceive"];
    }
    
    if (_saveDeliver == YES)
    {
        [param setValuesForKeysWithDictionary:_deliverDic];
        
        [param setObject:@"1" forKey:@"needSaveSend"];
    }
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
    __block NSMutableArray* redResultArray = [NSMutableArray array];
    
    dispatch_group_async(group,queue, ^{
        for (int i=0; i<_allModel.detail.count; i++)
        {
            
            CartModel *temp = weakSelf.allModel.detail[i];
            [param setObject:temp.shopId forKey:@"shopId"];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (VoucherModel *voucher in temp.voucher)
            {
                if (voucher.voucherId)
                {
                    [array addObject:voucher.voucherId];
                }
            }
            NSMutableArray *orderItems = [[NSMutableArray alloc] init];
            
            for (int j = 0; j<temp.orderItems.count; j++)
            {
                ProductModel *modell = temp.orderItems[j];
                if (!modell.isAdd)
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:modell.giftSale forKey:@"giftSale"];
                    [dic setObject:modell.productId forKey:@"id"];
                    [dic setObject:modell.sku forKey:@"sku"];
                    [dic setObject:modell.type forKey:@"type"];
                    [dic setObject:modell.currencyId forKey:@"currencyId"];
                    [dic setObject:modell.quantity forKey:@"quantity"];
                    
                    if (modell.buyFree)
                    {
                        [dic setObject:modell.buyFree forKey:@"buyFree"];
                    }
                    
                    
                    [orderItems addObject:dic];
                }
                
            }
            
            [param setObject:orderItems forKey:@"orderItems"];
            [param setObject:array forKey:@"voucherId"];
            
            if ([temp.freePostage isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = temp.freePostage;
                if ([dic.allKeys containsObject:@"id"])
                {
                    [param setObject:dic[@"id"] forKey:@"freePostageId"];
                }
            }
            
            if ([temp.shopId isEqualToString:@"1"] && weakSelf.shippingCourier)
            {
                [param setObject:weakSelf.shippingCourier forKey:@"shippingCourier"];
            }
            
            if (temp.memo)
            {
                 [param setObject:temp.memo forKey:@"memo"];
            }
            
           
            [param setObject:@"app" forKey:@"deviceType"];
            [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/create" parameters:param success:^(NSURLSessionDataTask *task, id result) {
                
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
                    NSDictionary *orderDic = result[@"data"];
                    NSNumber *amount = orderDic[@"total_amount"];
                    NSString *totalAmount = [NSString stringWithFormat:@"%@", amount];
                    
                    if ([orderDic.allKeys containsObject:@"luckyMoney"])
                    {
                        if (![orderDic[@"luckyMoney"] isKindOfClass:[NSNull class]]|| [totalAmount floatValue] == 0)
                        {
                            [redResultArray addObject:result[@"data"]];
                        }
                    }
                    
                    [ordersArray addObject:orderDic[@"order_number"]];
                    [idArray addObject:[orderDic[@"id"] stringValue]];
                    dispatch_semaphore_signal(semaphore);
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:result[@"message"]];
                    [SVProgressHUD dismissWithDelay:2.2];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                
                
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"==============%@", error);
                dispatch_semaphore_signal(semaphore);
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
        }
    });
    
    
    NSDictionary *dic = _allModel.common;
    
    NSString *total = [NSString stringWithFormat:@"%@ %@/%@ %@", _allModel.firstCurrencyName, [dic valueForKey:@"firstTotalAmount"],_allModel.secondCurrencyName,[dic valueForKey:@"secondTotalAmount"]];
    
    dispatch_group_notify(group, queue, ^{
        //所有请求返回数据后执行

        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            PayViewController *vc = [[PayViewController alloc] init];
            vc.ordersArray = ordersArray;
            vc.totalFee = total;
            vc.idArray = idArray;
            vc.isFromShop = YES;
            if (redResultArray.count == 1) {
                //只包含新西兰仓或者快快仓红包
                NSDictionary* resultDic = [redResultArray objectAtIndex:0];
                [self pushToRedVC:resultDic nextDic:nil idArray:idArray];
            } else if (redResultArray.count == 2) {
                //取出 快快仓和新西兰仓的优惠信息
                NSDictionary* xinXiLanDic = [[[redResultArray objectAtIndex:0] stringWithKey:@"shop_id"] isEqualToString:@"1"] ? [redResultArray objectAtIndex:0] : [redResultArray objectAtIndex:1];
                NSDictionary* kuaiKuaiDic = [[[redResultArray objectAtIndex:0] stringWithKey:@"shop_id"] isEqualToString:@"4"] ? [redResultArray objectAtIndex:0] : [redResultArray objectAtIndex:1];
                [self pushToRedVC:xinXiLanDic nextDic:kuaiKuaiDic idArray:idArray];
            } else {
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            /*
            NSNumber *amount = resultDic[@"total_amount"];
            NSString *totalAmount = [NSString stringWithFormat:@"%@", amount];
            
            if (resultDic.allKeys.count > 0)
            {
                if (![resultDic[@"luckyMoney"] isKindOfClass:[NSNull class]]|| [totalAmount floatValue] == 0)
                {
                    RedpacketVC *redVC = [[RedpacketVC alloc] init];
                    redVC.orderID = resultDic[@"id"];
                    NSNumber *luck = resultDic[@"luckyMoney"];
                    NSString *luckyMoney = [NSString stringWithFormat:@"%@", luck];
                    CGFloat price = [luckyMoney floatValue];
                    if (luckyMoney.length > 7)
                    {
                        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                        NSDecimalNumber *ouncesDecimal;
                        NSDecimalNumber *roundedOunces;
                        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
                        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
                        luckyMoney = [NSString stringWithFormat:@"%@",roundedOunces];
                    }
                    redVC.luckyMoney = luckyMoney;
                    redVC.totalAmount = totalAmount;
                    redVC.ordersArray = idArray;
                    redVC.orderNum = resultDic[@"order_number"];
                    [self.navigationController pushViewController:redVC animated:YES];
                }
                else
                    [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                 [self.navigationController pushViewController:vc animated:YES];
            }
                */
        });
        
        
     
        
    });
}

- (void)pushToRedVC:(NSDictionary*)resultDic nextDic:(NSDictionary*)nextDic idArray:(NSArray*)idArray {
    NSNumber *amount = resultDic[@"total_amount"];
    NSString *totalAmount = [NSString stringWithFormat:@"%@", amount];
    RedpacketVC *redVC = [[RedpacketVC alloc] init];
    redVC.nextDic = nextDic;
    redVC.orderID = resultDic[@"id"];
    NSNumber *luck = resultDic[@"luckyMoney"];
    NSString *luckyMoney = [NSString stringWithFormat:@"%@", luck];
    CGFloat price = [luckyMoney floatValue];
    if (luckyMoney.length > 7)
    {
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        luckyMoney = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    redVC.luckyMoney = luckyMoney;
    redVC.totalAmount = totalAmount;
    redVC.ordersArray = idArray;
    redVC.orderNum = resultDic[@"order_number"];
    [self.navigationController pushViewController:redVC animated:YES];
}
#pragma mark - 收货人列表
- (void)receiveCellDidSelected
{
    RecentReceiverVC *vc = [[RecentReceiverVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 发货货人列表
- (void)deliverCellDidSelected
{
    RecentDeliverVC *vc = [[RecentDeliverVC alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)postDeliverModel:(CommonModel *)model
{
    DeliverCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.nameText.text = model.sendName ? model.sendName : @"";
    cell.phoneText.text = model.sendPhone ? model.sendPhone : @"";
    cell.addressText.text = model.sendAddress ? model.sendAddress : @"";
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (model.sendName.length>0)
    {
        [dic setObject:model.sendName forKey:@"sendName"];
    }
    
    if (model.sendPhone.length > 0)
    {
        [dic setObject:model.sendPhone forKey:@"sendPhone"];
    }
    
    if (model.sendAddress.length > 0)
    {
        [dic setObject:model.sendAddress forKey:@"sendAddress"];
    }
    
    _deliverDic = dic;
    
}

- (void)presentAddressVC
{
    ProvincesVC *vc = [[ProvincesVC alloc] init];
    BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)postReceriverModel:(CommonModel *)model
{
    ReceiveCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    cell.nameText.text = model.receiveName;
    cell.addressText.text = model.receiveAddress;
    cell.phoneText.text = model.receivePhone;
    _area = model.receiveProvince ?  [NSString stringWithFormat:@"%@ %@ %@", model.receiveProvince, model.receiveCity, model.receiveArea] : @"";
    cell.idCardText.text = model.receiveIdCard ? model.receiveIdCard : @"";
    cell.proviceText.text = _area;
    
//    _receiveDic = @{}
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (model.receiveName.length>0)
    {
        [dic setObject:model.receiveName forKey:@"receiveName"];
    }
    
    if (model.receivePhone.length > 0)
    {
        [dic setObject:model.receivePhone forKey:@"receivePhone"];
    }
    
    if (model.receiveAddress.length > 0)
    {
        [dic setObject:model.receiveAddress forKey:@"receiveAddress"];
    }
    
    if (model.receiveIdCard.length > 0)
    {
        [dic setObject:model.receiveIdCard forKey:@"receiveIdCard"];
    }
    
    if (model.receiveProvince.length > 0)
    {
        [dic setObject:model.receiveProvince forKey:@"receiveProvince"];
    }
    
    if (model.receiveCity.length > 0)
    {
        [dic setObject:model.receiveCity forKey:@"receiveCity"];
    }
    
    if (model.receiveArea.length > 0)
    {
        [dic setObject:model.receiveArea forKey:@"receiveArea"];;
    }
    _receiveDic = dic;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *area = [[NSUserDefaults standardUserDefaults] valueForKey:@"AREA"];
    ReceiveCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (area.length>0)
    {
        _area = area;
        cell.proviceText.text = area;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAllAlert:) name:@"AllTextAlert" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"TextAlert" object:nil];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"AREA"];
}


- (void)showAllAlert:(NSNotification *)notification
{
    CartAllModel *model = notification.object;
    self.alertView1.hidden = NO;
    self.alertView1.allModel = model;
}

- (TextAlertView *)alertView1
{
    if (!_alertView1)
    {
        _alertView1 = [[TextAlertView alloc] initWithFrame:G_SCREEN_BOUNDS];
        [self.view addSubview:_alertView1];
    }
    return _alertView1;
}

- (void)showAlert:(NSNotification *)notification
{
    CartModel *model = notification.object;
    self.alertView.hidden = NO;
    self.alertView.model = model;
    
}

- (TextAlertView *)alertView
{
    if (!_alertView)
    {
        _alertView = [[TextAlertView alloc] initWithFrame:G_SCREEN_BOUNDS];
        [self.view addSubview:_alertView];
    }
    return _alertView;
}
 

- (void)viewWillDisappear:(BOOL)animated
{
    self.alertView.hidden = YES;
    self.alertView1.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)judgePhoneStringValid:(NSString *)phoneString
{
    NSString *regex = @"^((1[3456789][0-9]))\\d{8}$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [identityStringPredicate evaluateWithObject:phoneString];
}

- (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
