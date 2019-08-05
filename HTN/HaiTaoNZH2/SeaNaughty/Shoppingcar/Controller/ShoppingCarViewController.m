//
//  ShoppingCarViewController.m
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ConfirmOrderVC.h"
#import "CartAllModel.h"
#import "TotalFeeView.h"
#import "CartSectionHeaderView.h"
#import "VoucherCell.h"
#import "CartProductCell.h"
#import "FeeCell.h"
#import "GiftCell.h"
#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "TextAlertView.h"
#import <Masonry.h>
#import "SelectVoucherVC.h"
#import "RedpacketVC.h"

#import "CYHShoppingCarGoodsTableViewCell.h"
#import "ProductModel.h"
#import "CYHShopFullProduModel.h"

@interface ShoppingCarViewController () <UITableViewDelegate, UITableViewDataSource, SelecetVoucherDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) TotalFeeView *feeView;
@property (nonatomic, strong) UIButton *numBtn;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) CartAllModel *model;
@property (nonatomic, assign) CGFloat tempHeight;
@property (nonatomic, strong) NSString *postageName;
@property (nonatomic, strong) UIView *emptyBtn;
@property (nonatomic, strong) TextAlertView *alertView;
@property (nonatomic, strong) TextAlertView *alertView1;
@property (nonatomic, strong) CartAllModel *tempModel;
@property (nonatomic, strong) NSString *shippingCourier;

@property (nonatomic, strong) NSMutableArray* subclaSectionTabArr;


@end

@implementation ShoppingCarViewController

-(NSMutableArray *)subclaSectionTabArr {
    if (!_subclaSectionTabArr) {
        _subclaSectionTabArr = [[NSMutableArray alloc] init];
    }return _subclaSectionTabArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    _dataArray = [[NSMutableArray alloc] init];
    _shippingCourier = @"";
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    
    
    if (self.isSecond)
    {
        _tempHeight = G_STATUSBAR_HEIGHT > 20 ? 20 : 0;
    }
    else
    {
        _tempHeight = G_TABBAR_HEIGHT;
    }

    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = LineColor;
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.emptyImg = [UIImage imageNamed:@"cart-icon"];
//    _tableView.emptyText = [NSString stringWithFormat:@"购物车还是空的~\n去逛逛"];

    _tableView.backgroundColor = LineColor;
//    _tableView.showEmptyView = YES;
    [self.view addSubview:_tableView];

//    _tableView.backgroundView = self.emptyBtn;
    [_tableView registerClass:[VoucherCell class] forCellReuseIdentifier:@"VoucherCell"];
//    [_tableView registerClass:[CartProductCell class] forCellReuseIdentifier:@"CartProductCell"];
    [_tableView registerClass:[FeeCell class] forCellReuseIdentifier:@"FeeCell"];
    [_tableView registerClass:[GiftCell class] forCellReuseIdentifier:@"GiftCell"];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 40)];
    headerView.text = @"    新西兰直邮仓满49纽币包邮";
    headerView.font = [UIFont systemFontOfSize:12];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#FFFDF3"];
    _tableView.tableHeaderView = headerView;

    
    
    [self.view addSubview:self.emptyBtn];

    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartModel *model = _dataArray[indexPath.section];
    if (indexPath.row == 0) {
        
        return 35;
        
    } else if (indexPath.row == 1) {
        
        __block CGFloat cellHeight;
        [model.shopFullProducts enumerateObjectsUsingBlock:^(CYHShopFullProduModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGFloat height;
            if (obj.shopFullID) {
                NSString* textString;
                if ([obj.status boolValue]) {
                    //已减
                    if ([obj.type isEqualToString:@"1"]) {
                        textString = [NSString stringWithFormat:@"已享<%@>已减%@%@,再购%@件,减%@",obj.prefixName,model.firstCurrencyName,obj.firstFullOffDiscountAmount,obj.distance,obj.nextFullOffDiscountAmount];
                    } else {
                        textString = [NSString stringWithFormat:@"已享<%@>已减%@%@,再购%@%@,减%@",obj.prefixName,model.firstCurrencyName,obj.firstFullOffDiscountAmount,model.firstCurrencyName,obj.distance,obj.nextFullOffDiscountAmount];
                    }
                } else {
                    //再购
                    if ([obj.type isEqualToString:@"1"]) {
                        textString = [NSString stringWithFormat:@"再购%@件,享<%@>",obj.distance,obj.prefixName];
                    } else {
                        textString = [NSString stringWithFormat:@"再购%@%@享<%@>",model.firstCurrencyName,obj.distance,obj.prefixName];
                    }
                }
                
                CGSize textSize = kGetTextSize(textString, G_SCREEN_WIDTH - 170, MAXFLOAT, 12);
                
                height = obj.orderItems.count*120 + textSize.height + 20;
                
            } else {
                
                height = obj.orderItems.count*120 + 1;
            }
            cellHeight += height;
            
        }];
        
        //        return 120 * model.orderItems.count;
        return cellHeight;
        
    } else if (indexPath.row == 2) {
        if (model.giftProducts.count>0)
        {
            return 210;
        }
        return 0.001;
    } else {
        if ([model.shopId isEqualToString:@"1"]) {
            return 94+20*3;
        } else
            return 50+20*3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CartSectionHeaderView *view = [[CartSectionHeaderView alloc] init];
    view.superSelf = self;
    [view handlerButtonAction:^(CartModel *modelBlock) {

        [self updateShop:modelBlock];
    }];
    
    view.model = _dataArray[section];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartModel *model = _dataArray[indexPath.section];
    MJWeakSelf;
    
    if (indexPath.row == 0)
    {   //选择优惠劵
        VoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoucherCell" forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
    else if (indexPath.row == 1)
    {   //购买的物品
//        CartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartProductCell" forIndexPath:indexPath];
//        cell.model = model.orderItems[indexPath.row-1];
//
//        cell.superVC = self;
//        [cell handlerButtonAction:^(ProductModel *modelBlock) {
//            NSLog(@"%@", modelBlock);
//            [self updateProductCheck:modelBlock];
//        }];
//        return cell;
        
        CYHShoppingCarGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row]];
        if (cell==nil) {
            cell = [[CYHShoppingCarGoodsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.superVC = self;
            
        }
        cell.sectionArr = model.shopFullProducts;
        cell.danWeiString = model.firstCurrencyName;
        
        return cell;
        
        
    }
    else if (indexPath.row == 2)
    {   //换购专区
        GiftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiftCell" forIndexPath:indexPath];

        if (model.giftProducts.count == 0)
        {
            cell.hidden = YES;
        }
        else
        {
            cell.hidden = NO;
            cell.model = model;
        }
        
        return cell;
       
        
    }
    else
    {   //快递选择
        FeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeeCell" forIndexPath:indexPath];
        cell.model = model;
        
        if ([model.shopId isEqualToString:@"1"])
        {
            cell.showBtn = YES;
        }
        else
        {
            cell.showBtn = NO;
        }
        cell.couriers = self.model.couriers;
        [cell feeCellHandleAction:^(CartModel *model) {
            weakSelf.postageName = model.postageName;
            [weakSelf getCartDetail];
        }];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartModel *model = _dataArray[indexPath.section];
    if (indexPath.row == 0)
    {
#pragma mark 跳转优惠券
        NSArray *tempArray = [[NSMutableArray alloc] initWithArray:_tempModel.detail];
        CartModel *model = tempArray[indexPath.section];
        
        CartModel *vvv = _dataArray[indexPath.section];
        
        SelectVoucherVC *vc = [[SelectVoucherVC alloc] init];
        vc.shopId = model.shopId;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        
        for (int i=0; i<vvv.voucher.count; i++)
        {
            VoucherModel *voucher = vvv.voucher[i];
            [array addObject:voucher.voucherId];
            NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
            [dicc setObject:voucher.shopId forKey:@"shopId"];
            if (voucher.voucherId)
            {
                [dicc setObject:voucher.voucherId forKey:@"voucherId"];
            }
            
            [dicc setObject:voucher.shopName forKey:@"shopName"];
            [array1 addObject:dicc];
        }
        
        if ([model.freePostage isKindOfClass:[NSDictionary class]])
        {
            VoucherModel *vmodel = [[VoucherModel alloc] init];
            vmodel.shopName = @[model.shopName];
            if ([model.freePostage[@"firstAmount"] isKindOfClass:[NSString class]])
            {
                vmodel.firstAmount = model.freePostage[@"firstAmount"];
            }
            else
            {
                vmodel.firstAmount = [model.freePostage[@"firstAmount"] stringValue];
            }
            vmodel.firstCurrencyName = model.firstCurrencyName;
            vmodel.firstMinProductAmount = model.freePostage[@"firstThreshold"];
            vmodel.isPFree = YES;
            if ([vvv.discountType isEqualToString:@"2"])
            {
                vmodel.hasSelect = YES;
            }
            else
            {
                vmodel.hasSelect = NO;
            }
            
            NSString *shop = vmodel.shopName.count > 0 ? [vmodel.shopName componentsJoinedByString:@","] : @"";
            
            vmodel.useCondition = [NSString stringWithFormat:@"适用范围：%@", shop];
            vmodel.descriptionString = [NSString stringWithFormat:@"其他说明：【运费优惠】"];
            vmodel.count = @"1";
            vmodel.height = 160;
            vc.feeModel = vmodel;
        }
        
//        if ([model.discountType isEqualToString:@"2"]) //包邮
//        {
//            VoucherModel *vmodel = [[VoucherModel alloc] init];
//            vmodel.shopName = @[model.shopName];
//            vmodel.firstAmount = model.freePostage[@"firstAmount"];
//            vmodel.firstCurrencyName = model.firstCurrencyName;
//            vmodel.firstMinProductAmount = model.freePostage[@"firstThreshold"];
//            vmodel.isPFree = YES;
//            if ([vvv.discountType isEqualToString:@"2"])
//            {
//                vmodel.hasSelect = YES;
//            }
//            else
//            {
//                vmodel.hasSelect = NO;
//            }
//
//            vmodel.count = @"1";
//            vc.feeModel = vmodel;
//        }
        
        vc.selectedVouchers = array1;
        vc.voucherId = array;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//选择优惠卷后的回调
- (void)postVoucher:(NSMutableDictionary *)param
{

    MJWeakSelf;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/update-discount" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:weakSelf.model.detail];
//            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray];
            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray andShopFreeProductsDic:weakSelf.model.shopFreeProducts];
            
            if (weakSelf.dataArray.count > 0)
            {
                weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-weakSelf.tempHeight);
                weakSelf.bottomView.hidden = NO;
                weakSelf.feeView.model = weakSelf.model;
                [weakSelf.numBtn setTitle:[NSString stringWithFormat:@"结算(%@)", weakSelf.model.checkedCount] forState:UIControlStateNormal];
                weakSelf.allBtn.selected = YES;
                weakSelf.emptyBtn.hidden = YES;
            }
            else
            {
                weakSelf.bottomView.hidden = YES;
                weakSelf.emptyBtn.hidden = NO;
            }
            
            if ([weakSelf.model.shopFreeProducts isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = weakSelf.model.shopFreeProducts;
                
                if (dic.allKeys.count > 0)
                {
                    for (CartModel *cart in weakSelf.model.detail)
                    {
                        if ([dic.allKeys containsObject:cart.shopId])
                        {
                            NSArray *array = [dic valueForKey:cart.shopId];
                            
                            if (array.count > 0)
                            {
                                NSDictionary *pp = @{@"data":array};
                                ProductModel *product = [ProductModel yy_modelWithDictionary:pp];
                                product.discountType = cart.discountType;
                                for (ProductModel *ppp in product.data)
                                {
                                    ppp.discountType = cart.discountType;
                                    if ([ppp.stockStatus isEqualToString:@"0"] || [ppp.status isEqualToString:@"2"])
                                    {
                                        ppp.isAdd = YES;
                                        [cart.orderItems addObject:ppp];
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            for (CartModel *cart in weakSelf.model.detail)
            {
                for (ProductModel *p in cart.orderItems)
                {
                    p.discountType = cart.discountType;
                }
            }
            
            
            [weakSelf.tableView reloadData];
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
            
        }];
//    });
    
    
}

//列表数据展示
- (void)getCartDetail
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    if (_postageName.length > 0)
    {
        NSString *temp = @"1";
        if ([_postageName isEqualToString:@"程光"])
        {
            temp = @"2";
        }
        else if ([_postageName isEqualToString:@"易达通"])
        {
            temp = @"1000011";
        }
        _shippingCourier = temp;
        [param setObject:temp forKey:@"shippingCourier"];
    }
    
    
    MJWeakSelf;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/cart" parameters:param success:^(NSURLSessionDataTask *task, id result) {

        [hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            
            NSLog(@"-----==== %@",result);
            
            weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.tempModel = [CartAllModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:weakSelf.model.detail];
            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray andShopFreeProductsDic:weakSelf.model.shopFreeProducts];
            
            
            if ([weakSelf.model.shopFreeProducts isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = weakSelf.model.shopFreeProducts;
                
                if (dic.allKeys.count > 0)
                {
                    for (CartModel *cart in weakSelf.model.detail)
                    {
                        if ([dic.allKeys containsObject:cart.shopId])
                        {
                            NSArray *array = [dic valueForKey:cart.shopId];
                            
                            if (array.count > 0)
                            {
                                NSDictionary *pp = @{@"data":array};
                                ProductModel *product = [ProductModel yy_modelWithDictionary:pp];
                                product.discountType = cart.discountType;
                                for (ProductModel *ppp in product.data)
                                {
                                    ppp.discountType = cart.discountType;
                                    if ([ppp.stockStatus isEqualToString:@"0"] || [ppp.status isEqualToString:@"2"])
                                    {
                                        ppp.isAdd = YES;
                                        [cart.orderItems addObject:ppp];
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
                
            }
            
            for (CartModel *cart in weakSelf.model.detail)
            {
                for (ProductModel *p in cart.orderItems)
                {
                    p.discountType = cart.discountType;
                }
            }
            
            
            if (weakSelf.dataArray.count > 0)
            {
                weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-weakSelf.tempHeight);
                weakSelf.bottomView.hidden = NO;
                weakSelf.feeView.model = weakSelf.model;
                [weakSelf.numBtn setTitle:[NSString stringWithFormat:@"结算(%@)", weakSelf.model.checkedCount] forState:UIControlStateNormal];
                weakSelf.allBtn.selected = YES;
                weakSelf.emptyBtn.hidden = YES;
                
                if ([weakSelf.model.checkedAll isEqualToString:@"0"])
                {
                    weakSelf.allBtn.selected = NO;
                }
                
                
            }
            else
            {
                weakSelf.bottomView.hidden = YES;
                weakSelf.emptyBtn.hidden = NO;
            }
            
            
            
            
            [weakSelf.tableView reloadData];
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-120-_tempHeight, G_SCREEN_WIDTH, 120)];
        _bottomView.hidden = YES;
        [self.view addSubview:_bottomView];
        
        _feeView = [[TotalFeeView alloc] init];
        [_bottomView addSubview:_feeView];
        
        _allBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 70, G_SCREEN_WIDTH/2, 50)];
        _allBtn.backgroundColor = [UIColor whiteColor];
        [_allBtn setTitle:@"    全选" forState:UIControlStateNormal];
        _allBtn.selected = YES;
        _allBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        _allBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        [_allBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_allBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_allBtn setTitleColor:TextColor forState:UIControlStateNormal];
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_allBtn addTarget:self action:@selector(allSelectAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_allBtn];
        
        _numBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2,70, G_SCREEN_WIDTH/2, 50)];
        _numBtn.backgroundColor = MainColor;
        [_numBtn setTitle:@"结算" forState:UIControlStateNormal];
        [_numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _numBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_numBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_numBtn];
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 70, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_bottomView addSubview:lineView];
        
    }
    return _bottomView;
}


#pragma mark - 全选
- (void)allSelectAction
{
    _allBtn.selected = !_allBtn.selected;
    
    
    
    MJWeakSelf;
    
    NSString *str = _allBtn.selected ? @"true" : @"false";
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:str forKey:@"checked"];
   
    
    if (_allBtn.selected)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud showAnimated:YES];
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/select-all" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            [hud hideAnimated:YES];
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
                
                weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:weakSelf.model.detail];
//                weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray];
                weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray andShopFreeProductsDic:weakSelf.model.shopFreeProducts];
                
                if (weakSelf.dataArray.count > 0)
                {
                    weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-weakSelf.tempHeight);
                    weakSelf.bottomView.hidden = NO;
                    weakSelf.feeView.model = weakSelf.model;
                    [weakSelf.numBtn setTitle:[NSString stringWithFormat:@"结算(%@)", weakSelf.model.checkedCount] forState:UIControlStateNormal];
                    weakSelf.allBtn.selected = [weakSelf.model.checkedAll intValue];
                    
                }
                
                for (CartModel *cart in weakSelf.model.detail)
                {
                    for (ProductModel *p in cart.orderItems)
                    {
                        p.discountType = cart.discountType;
                    }
                }
                
                
                [weakSelf.tableView reloadData];
            }
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else
    {
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
            [param setObject:@"false" forKey:@"checked"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud showAnimated:YES];
            [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/select-all" parameters:param success:^(NSURLSessionDataTask *task, id result) {
                
                [hud hideAnimated:YES];
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
//                    weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
                    
                    weakSelf.model.checkedAll = @"0";
                    [weakSelf.numBtn setTitle:@"结算(0)" forState:UIControlStateNormal];
                    //        _numBtn.enabled = NO;
                    weakSelf.feeView.zero = YES;
                    
                    for (CartModel *model in _model.detail)
                    {
                        model.checked = @"0";
                        for (ProductModel *product in model.orderItems)
                        {
                            product.checked = @"0";
                            product.discountType = model.discountType;
                        }
                        
                    }
                    
                   
                    
                    [weakSelf.tableView reloadData];
                }
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        
       
        

    }
    
}

#pragma mark - 结算
- (void)orderAction
{
    
    if ([_numBtn.titleLabel.text isEqualToString:@"结算(0)"])
    {
        return;
    }
    
    ConfirmOrderVC *vc = [[ConfirmOrderVC alloc] init];
    vc.allModel = _model;
    vc.shippingCourier = _shippingCourier;
    for (CartModel *mo in _model.detail)
    {
        for (ProductModel *mm in mo.orderItems)
        {
            if (mm.isAdd)
            {
                vc.showAlert = YES;
            }
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

//物品数量选择输入框变化的通知
- (void)updateNum:(NSNotification *)notification
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    ProductModel *model = notification.object;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:model.quantity forKey:@"quantity"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:model.productId forKey:@"productId"];
    [param setObject:model.shopId forKey:@"shopId"];
    
    
    MJWeakSelf;
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/update-qty" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            [weakSelf getCartDetail];
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

//是否勾选选择全部物品的按钮
- (void)updateShop:(CartModel *)model
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    MJWeakSelf;
    
    NSString *str = [model.checked isEqualToString:@"1"] ? @"true" : @"false";
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:str forKey:@"checked"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:model.shopId forKey:@"shopId"];
    if (_postageName.length > 0)
    {
        NSString *temp = @"1";
        if ([_postageName isEqualToString:@"程光"])
        {
            temp = @"2";
        }
        else if ([_postageName isEqualToString:@"易达通"])
        {
            temp = @"1000011";
        }
        _shippingCourier = temp;
        [param setObject:temp forKey:@"shippingCourier"];
    }
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/update-shop" parameters:param success:^(NSURLSessionDataTask *task, id result) {
       
        [hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:weakSelf.model.detail];
//            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray];
            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray andShopFreeProductsDic:weakSelf.model.shopFreeProducts];
            
            if (weakSelf.dataArray.count > 0)
            {
                weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-weakSelf.tempHeight);
                weakSelf.bottomView.hidden = NO;
                weakSelf.feeView.model = weakSelf.model;
                [weakSelf.numBtn setTitle:[NSString stringWithFormat:@"结算(%@)", weakSelf.model.checkedCount] forState:UIControlStateNormal];
                weakSelf.allBtn.selected = [weakSelf.model.checkedAll intValue];
                
            }
            
            
            if ([weakSelf.model.shopFreeProducts isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = weakSelf.model.shopFreeProducts;
                
                if (dic.allKeys.count > 0)
                {
                    for (CartModel *cart in weakSelf.model.detail)
                    {
                        if ([dic.allKeys containsObject:cart.shopId])
                        {
                            NSArray *array = [dic valueForKey:cart.shopId];
                            
                            if (array.count > 0)
                            {
                                NSDictionary *pp = @{@"data":array};
                                ProductModel *product = [ProductModel yy_modelWithDictionary:pp];
                                product.discountType = cart.discountType;
                                for (ProductModel *ppp in product.data)
                                {
                                    ppp.discountType = cart.discountType;
                                    if ([ppp.stockStatus isEqualToString:@"0"] || [ppp.status isEqualToString:@"2"])
                                    {
                                        ppp.isAdd = YES;
                                        [cart.orderItems addObject:ppp];
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                
                
            }
            
            for (CartModel *cart in weakSelf.model.detail)
            {
                for (ProductModel *p in cart.orderItems)
                {
                    p.discountType = cart.discountType;
                }
            }
            
            [weakSelf.tableView reloadData];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}

#pragma mark - 购物车单个产品勾选操作
- (void)updateProductCheck:(ProductModel *)model
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    MJWeakSelf;
    
    NSString *str = [model.checked isEqualToString:@"1"] ? @"true" : @"false";
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:str forKey:@"checked"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:model.productId forKey:@"productId"];
    [param setObject:model.shopId forKey:@"shopId"];
    if (_postageName.length > 0)
    {
        NSString *temp = @"1";
        if ([_postageName isEqualToString:@"程光"])
        {
            temp = @"2";
        }
        else if ([_postageName isEqualToString:@"易达通"])
        {
            temp = @"1000011";
        }
        _shippingCourier = temp;
        [param setObject:temp forKey:@"shippingCourier"];
    }
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/update-product" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:weakSelf.model.detail];
//            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray];
            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray andShopFreeProductsDic:weakSelf.model.shopFreeProducts];
            
            if (weakSelf.dataArray.count > 0)
            {
                weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-weakSelf.tempHeight);
                weakSelf.bottomView.hidden = NO;
                weakSelf.feeView.model = weakSelf.model;
                [weakSelf.numBtn setTitle:[NSString stringWithFormat:@"结算(%@)", weakSelf.model.checkedCount] forState:UIControlStateNormal];
                weakSelf.allBtn.selected = [weakSelf.model.checkedAll intValue];

                
                if ([weakSelf.model.shopFreeProducts isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dic = weakSelf.model.shopFreeProducts;
                    
                    if (dic.allKeys.count > 0)
                    {
                        for (CartModel *cart in weakSelf.model.detail)
                        {
                            if ([dic.allKeys containsObject:cart.shopId])
                            {
                                NSArray *array = [dic valueForKey:cart.shopId];
                                
                                if (array.count > 0)
                                {
                                    NSDictionary *pp = @{@"data":array};
                                    ProductModel *product = [ProductModel yy_modelWithDictionary:pp];
                                    product.discountType = cart.discountType;
                                    for (ProductModel *ppp in product.data)
                                    {
                                        ppp.discountType = cart.discountType;
                                        if ([ppp.stockStatus isEqualToString:@"0"] || [ppp.status isEqualToString:@"2"])
                                        {
                                            ppp.isAdd = YES;
                                            [cart.orderItems addObject:ppp];
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
                
                for (CartModel *cart in weakSelf.model.detail)
                {
                    for (ProductModel *p in cart.orderItems)
                    {
                        p.discountType = cart.discountType;
                    }
                }
                
            }
            
            
            [weakSelf.tableView reloadData];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (UIView *)emptyBtn
{
    if (!_emptyBtn)
    {
        _emptyBtn = [[UIView alloc] initWithFrame:G_SCREEN_BOUNDS];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [_emptyBtn addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"cart-icon"];
        
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@122);
            make.height.mas_equalTo(@80);
            make.centerX.mas_equalTo(_emptyBtn);
            make.centerY.mas_equalTo(_emptyBtn).mas_offset(-10);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.text = @"购物车还是空的~\n去逛逛";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = TextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [_emptyBtn addSubview:label];
        
        [label makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.mas_equalTo(_emptyBtn);
            make.top.mas_equalTo(imageView.mas_bottom).offset(2);
        }];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:G_SCREEN_BOUNDS];
        [_emptyBtn addSubview:btn];
        //    _tableView.emptyImg = [UIImage imageNamed:@"cart-icon"];
        //    _tableView.emptyText = [NSString stringWithFormat:@"购物车还是空的~\n去逛逛"];
        
        [btn addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _emptyBtn;
}

- (void)goHome
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tabbar.selectedIndex = 0;
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

- (void)viewWillAppear:(BOOL)animated
{
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"carReload"] isEqualToString:@"NO"])
    {
        [self getCartDetail];
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCartDetail) name:@"RELOADPRODUCT" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNum:) name:@"updatenum" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAllAlert:) name:@"AllTextAlert" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"TextAlert" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFrees:) name:@"deleteFrees" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(radioSelectNoti:) name:@"radioSelect" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.alertView.hidden = YES;
    self.alertView1.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"carReload"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)radioSelectNoti:(NSNotification *)notification
{
    ProductModel *model = notification.object;
    
    [self updateProductCheck:model];
    
}

- (void)deleteFrees:(NSNotification *)notification
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    ProductModel *model = notification.object;
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:model.shopId forKey:@"shopId"];
    if (self.shippingCourier.length > 0)
    {
        [param setObject:self.shippingCourier forKey:@"shippingCourier"];
    }
    
    [param setObject:@[@{@"shopId":model.shopId, @"frees":@[model.productId]}] forKey:@"delFrees"];
    [param setObject:@[@{@"shopId":model.shopId, @"discountType":model.discountType}] forKey:@"discountType"];
    MJWeakSelf;
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/delete-delFrees" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [hud hideAnimated:YES];
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [SVProgressHUD dismissWithDelay:1.0];
            
            weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.tempModel = [CartAllModel yy_modelWithDictionary:result[@"data"]];
            
            weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:weakSelf.model.detail];
//            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray];
            weakSelf.dataArray = [weakSelf manJainSelectAdd:weakSelf.dataArray andShopFreeProductsDic:weakSelf.model.shopFreeProducts];
            
            if ([weakSelf.model.shopFreeProducts isKindOfClass:[NSDictionary class]])
            {
                
                NSDictionary *dic = weakSelf.model.shopFreeProducts;
                
                if (dic.allKeys.count > 0)
                {
                    for (CartModel *cart in weakSelf.model.detail)
                    {
                        if ([dic.allKeys containsObject:cart.shopId])
                        {
                            NSArray *array = [dic valueForKey:cart.shopId];
                            
                            if (array.count > 0)
                            {
                                NSDictionary *pp = @{@"data":array};
                                ProductModel *product = [ProductModel yy_modelWithDictionary:pp];
                                product.discountType = cart.discountType;
                                for (ProductModel *ppp in product.data)
                                {
                                    ppp.discountType = cart.discountType;
                                    if ([ppp.stockStatus isEqualToString:@"0"] || [ppp.status isEqualToString:@"2"])
                                    {
                                        ppp.isAdd = YES;
                                        [cart.orderItems addObject:ppp];
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            for (CartModel *cart in weakSelf.model.detail)
            {
                for (ProductModel *p in cart.orderItems)
                {
                    p.discountType = cart.discountType;
                }
            }
            
            if (weakSelf.dataArray.count > 0)
            {
                weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-weakSelf.tempHeight);
                weakSelf.bottomView.hidden = NO;
                weakSelf.feeView.model = weakSelf.model;
                [weakSelf.numBtn setTitle:[NSString stringWithFormat:@"结算(%@)", weakSelf.model.checkedCount] forState:UIControlStateNormal];
                weakSelf.allBtn.selected = YES;
                weakSelf.emptyBtn.hidden = YES;
                
                if ([weakSelf.model.checkedAll isEqualToString:@"0"])
                {
                    weakSelf.allBtn.selected = NO;
                }
                
                
            }
            else
            {
                weakSelf.bottomView.hidden = YES;
                weakSelf.emptyBtn.hidden = NO;
            }
            
            
            
            
            [weakSelf.tableView reloadData];
            
            
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(NSMutableArray *)manJainSelectAdd:(NSMutableArray *)dataArr andShopFreeProductsDic:(NSDictionary *)shopFreeDic {
    
    NSMutableArray* sectiByProArr = [NSMutableArray new];//保存赠品
    
    [dataArr enumerateObjectsUsingBlock:^(CartModel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj.shopFullOffs enumerateObjectsUsingBlock:^(CYHShopFullProduModel*  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            
            __block BOOL isOn = NO;
            [obj.orderItems enumerateObjectsUsingBlock:^(ProductModel*  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                
                if ([obj2.fullOffId isEqualToString:obj1.shopFullID] && obj2.byProductId == nil) {
                    [obj1.orderItems addObject:obj2];
                    isOn = YES;
                }
                
            }];
            if (isOn) {
                [obj.shopFullProducts addObject:obj1];
            }
            
        }];
        
    }];
    
    
    [dataArr enumerateObjectsUsingBlock:^(CartModel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray* bybyProductArr = [NSMutableArray new];
        
        CYHShopFullProduModel *shopFullModel = [[CYHShopFullProduModel alloc] init];
        
        [obj.orderItems enumerateObjectsUsingBlock:^(ProductModel*  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            
            if (!obj1.fullOffId && obj1.byProductId == nil) {
                
                [shopFullModel.orderItems addObject:obj1];
                
            }
            
            if (obj1.byProductId) {
                [bybyProductArr addObject:obj1];
            }
           
        }];
        
        [obj.shopFullProducts addObject:shopFullModel];
        
        [sectiByProArr addObject:bybyProductArr];
    }];
    
//    NSLog(@"%@",sectiByProArr);
//

//    [sectiByProArr enumerateObjectsUsingBlock:^(NSArray*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        CartModel *model = dataArr[idx];
//
//        [obj enumerateObjectsUsingBlock:^(ProductModel*  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
//
//            [model.shopFullProducts enumerateObjectsUsingBlock:^(CYHShopFullProduModel *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
//
//                NSInteger count = obj2.orderItems.count;
//
//                for (int i = 0; i < count ; i++) {
//
//                    ProductModel* model = obj2.orderItems[i];
//
//                    if ([model.productId isEqualToString:obj1.byProductId]) {
//
//                        [obj2.orderItems insertObject:obj1 atIndex:i+1];
//
//                    }
//
//                }
//
//            }];
//
//        }];
//
//    }];
    
    
    if (shopFreeDic.allKeys.count > 0)
    {
        for (CartModel *cart in dataArr)
        {
            if ([shopFreeDic.allKeys containsObject:cart.shopId])
            {
                
                NSMutableArray* proModelArr = [NSMutableArray new];
                NSArray *array = [shopFreeDic valueForKey:cart.shopId];
                
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ProductModel* model = [ProductModel yy_modelWithDictionary:obj];
                    [proModelArr addObject:model];
                }];
                
                
                for (ProductModel *ppp in proModelArr)
                {
                    ppp.discountType = cart.discountType;
                    if ([ppp.stockStatus isEqualToString:@"0"] || [ppp.status isEqualToString:@"2"]) {
                        ppp.isAdd = YES;
                    }
                    
                    [cart.shopFullProducts enumerateObjectsUsingBlock:^(CYHShopFullProduModel *  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                        
                        NSInteger count = obj2.orderItems.count;
                        
                        for (int i = 0; i < count ; i++) {
                            
                            ProductModel* model = obj2.orderItems[i];
                            model.discountType = cart.discountType;
                            
                            if ([ppp.byProductId isEqualToString:model.productId]) {
                                
                                [obj2.orderItems insertObject:ppp atIndex:i+1];
                                
                            }
                            
                        }
                        
                    }];
                }
            }
        }
    }
    
    
    return dataArr;
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
