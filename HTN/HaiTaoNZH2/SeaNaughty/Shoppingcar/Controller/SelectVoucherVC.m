//
//  SelectVoucherVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/26.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "SelectVoucherVC.h"
#import "VoucherDetailCell.h"
#import <Masonry.h>

@interface SelectVoucherVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SelectVoucherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择优惠券";
    [self getVoucher];
    _dataArray = [[NSMutableArray alloc] init];
    [self initUI];
    
    [self.view addSubview:self.btnView];
    
    
}

- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-48) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[VoucherDetailCell class] forCellReuseIdentifier:@"VoucherDetailCell"];
    [self.view addSubview:_tableView];
//    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.width.mas_equalTo(self.view);
//
//    }]
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0)
    {
        VoucherModel *model = _dataArray[indexPath.section];
        return model.height;
    }
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoucherDetailCell" forIndexPath:indexPath];
    
//    cell.model = _dataArray[indexPath.section];
    
    VoucherModel *model = _dataArray[indexPath.section];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherModel *model = _dataArray[indexPath.section];
    
    if ([model.isValid isEqualToString:@"0"])
    {
        return;
    }
    
    if (![model isEqual:_feeModel] )
    {

        NSDictionary *dic = model.superimposed;
        NSArray *aray = dic[@"data"];
        if ([aray containsObject:@0]) //不可以叠加
        {
            for (VoucherModel *temp in _dataArray)
            {
                if (![temp isEqual:model])
                {
                    NSDictionary *dic = temp.superimposed;
                    NSArray *aray = dic[@"data"];
                    if (![aray containsObject:@1])
                    {
                        temp.hasSelect = NO;
                    }
                }
                
            }

        }

    }
    else
    {
        
        for (VoucherModel *temp in _dataArray)
        {
            if (![temp isEqual:model])
            {
                NSDictionary *dic = temp.superimposed;
                NSArray *aray = dic[@"data"];
                if ([aray containsObject:@0]) //不可以叠加
                {
                    temp.hasSelect = NO;
                }

            }
        }
    }
    
     model.hasSelect = !model.hasSelect;
    
    [_tableView reloadData];
}


- (void)getVoucher
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:self.selectedVouchers forKey:@"selectedVouchers"];
    [param setObject:self.voucherId forKey:@"voucherId"];
    [param setObject:self.shopId forKey:@"shopId"];
    MJWeakSelf;
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/vouchers" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            VoucherModel *list = [VoucherModel yy_modelWithDictionary:result];
           
            
            NSDictionary *tempDic = [[NSMutableDictionary alloc] init];
            for (VoucherModel *model in list.data)
            {
                model.count = @"1";
                
                NSString *shop = model.shopName.count > 0 ? [model.shopName componentsJoinedByString:@","] : @"";
                NSString *brand = model.brandName.count > 0 ? [model.brandName componentsJoinedByString:@","] : @"";
                NSString *product = model.productName.count > 0 ? [model.productName componentsJoinedByString:@","] : @"";
                
                if (brand.length > 0 || product.length >0)
                {
                    if (shop.length > 0)
                    {
                        shop = [shop stringByAppendingString:@","];
                    }
                }
                
                if (product.length > 0 && brand.length > 0)
                {
                    brand = [brand stringByAppendingString:@","];
                }
                
                NSString *useCondition = [NSString stringWithFormat:@"适用范围:仅限%@ %@ %@使用",shop,brand,product];
                
                model.descriptionString = [NSString stringWithFormat:@"其他说明:%@", model.descriptionString];
                model.useCondition = useCondition;
                
                CGFloat height = [model.useCondition boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-60, 32) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+4;
                
                CGFloat height1 = [model.descriptionString boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-60, 32) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+4;
                
                model.height = height+height1+120;
                
                
                [tempDic setValue:@"1" forKey:model.voucherBookId];
            }
            
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            
            
            NSArray *array = tempDic.allKeys;
            
            for (NSString *voucherBookId in array)
            {
                NSInteger count = 0;
                for (VoucherModel *model in list.data)
                {
                    if ([model.voucherBookId isEqualToString:voucherBookId])
                    {
                        count++;
                    }
                    [tempDic setValue:[NSString stringWithFormat:@"%li", (long)count] forKey:voucherBookId];
                }
            }
            
            for (VoucherModel *model in list.data)
            {
                __block BOOL isExist = NO;
                [tempArray enumerateObjectsUsingBlock:^(VoucherModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isEqualToModel:model]) {//数组中已经存在该对象
                        *stop = YES;
                        isExist = YES;
                    }
                }];
                if (!isExist)
                {//如果不存在就添加进去
                    [tempArray addObject:model];
                }
            }
            
            for (VoucherModel *model in tempArray)
            {
                model.count = [tempDic valueForKey:model.voucherBookId];
            }
            
            if (weakSelf.feeModel)
            {
                [_dataArray addObject:weakSelf.feeModel];
            }
            
            for (VoucherModel *model in list.data)
            {
                
                if (model.selected)
                {
                    for (VoucherModel *ttt in tempArray)
                    {
                        if ([ttt.voucherBookId isEqualToString:model.voucherBookId])
                        {
                            ttt.hasSelect = YES;
                        }
                    }
                }
            }
            
            [_dataArray addObjectsFromArray:tempArray];
            
            [weakSelf.tableView reloadData];
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
//        "customerId":1017709,
//        "company":"NZH",
//        "discountType":[{ "shopId": 1, "discountType": 1 }],
//        "selectedVouchers":[{ "shopId": "1", "voucherId": ["1723144"], "shopName": "新西兰直邮仓" }]
//    discountType 1优惠券 2包邮 voucherId:[] 为空时，是不使用优惠券。 discountType=2，再传voucherId["xxx"]是包邮➕可叠加优惠券 普通券和包邮活动是二选一，选了普通优惠券就不能包邮， discountType=1，voucherId不传时，就是什么都不使用
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
//    [param setObject:@[@{@"shopId":@"1", @"discountType":@"1"}] forKey:@"discountType"];
//    [param setObject:@[@{@"shopId":@"1",@"voucherId":@[],@"shopName":@"新西兰直邮仓"}] forKey:@"selectedVouchers"];
//
//    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/update-discount" parameters:param success:^(NSURLSessionDataTask *task, id result) {
//
//        NSLog(@"%@", result);
//
//
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//
//        NSLog(@"%@", error);
//
//    }];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    NSString *type = @"1";
    
    if (_feeModel && _feeModel.hasSelect)
    {
        type = @"2";
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
    for (int i=0; i<_dataArray.count; i++)
    {
        VoucherModel *voucher = _dataArray[i];
        
        if (!_feeModel || ![voucher isEqual:_feeModel] )
        {
            if (voucher.hasSelect)
            {
                [array addObject:voucher.voucherId];
            }
            [dicc setObject:array forKey:@"voucherId"];
            [dicc setObject:voucher.shopId forKey:@"shopId"];
            
            [dicc setObject:voucher.shopName forKey:@"shopName"];
        }
    }
    
    [param setObject:@[@{@"shopId":self.shopId, @"discountType":type}] forKey:@"discountType"];
    
    [param setObject:@[dicc] forKey:@"selectedVouchers"];
    
    NSLog(@"%@ ----- %@", type , dicc[@"voucherId"]);
    
    if (_delegate && [_delegate respondsToSelector:@selector(postVoucher:)])
    {
        [_delegate postVoucher:param];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"carReload"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}

@end
