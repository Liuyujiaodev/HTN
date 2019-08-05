//
//  MyCouponViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "MyCouponViewController.h"
#import "VoucherListModel.h"
#import <YYLabel.h>
#import <Masonry.h>
#import "VoucherDetailCell.h"

@interface MyCouponViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    _dataArray = [[NSMutableArray alloc] init];
    [self getvVouchers];
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView = [[UITableView alloc] initWithFrame:G_SCREEN_BOUNDS style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[VoucherDetailCell class] forCellReuseIdentifier:@"VoucherDetailCell"];
    [self.view addSubview:_tableView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0)
    {
        VoucherModel *model = _dataArray[indexPath.section];

        return model.height;
    }
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VoucherDetailCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.section];
    
    return cell;
}

#pragma mark - 获取优惠券
- (void)getvVouchers
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/customers/vouchers" parameters:param success:^(NSURLSessionDataTask *task, id result) {
       
        [loadingHud hideAnimated:YES];
        VoucherListModel *list = [VoucherListModel yy_modelWithDictionary:result];
        NSDictionary *tempDic = [[NSMutableDictionary alloc] init];
        for (VoucherModel *model in list.data)
        {
            model.count = @"1";
//            model.height
            
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
            
//            CGFloat height11 = model.height;
//
//            NSLog(@"%f", height11);
            
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
                if ([obj isEqual:model]) {//数组中已经存在该对象
                    *stop = YES;
                    isExist = YES;
                }
            }];
            if (!isExist)
            {//如果不存在就添加进去
                [tempArray addObject:model];
            }
        }
//
//
        for (VoucherModel *model in tempArray)
        {
            model.count = [tempDic valueForKey:model.voucherBookId];
        }
//
        weakSelf.dataArray = [NSMutableArray arrayWithArray:tempArray];
        
        [weakSelf.tableView reloadData];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
