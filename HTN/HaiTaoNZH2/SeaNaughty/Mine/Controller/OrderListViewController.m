//
//  OrderListViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListModel.h"
#import "LLSegmentBar.h"
#import "OrderListCell.h"
#import "OrderDetailViewController.h"
#import "PayViewController.h"
#import "AlertView.h"
#import "YBImageBrowser.h"
#import "ChatListVC.h"
#import "ShoppingCarViewController.h"
#import "AppDelegate.h"

@interface OrderListViewController () <UITableViewDelegate, UITableViewDataSource, LLSegmentBarDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) LLSegmentBar *segment;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UITextField *searchText;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) NSArray *statusArray;
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, strong) AlertView *alertView;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单列表";
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _heightArray = [[NSMutableArray alloc] init];
    _param = [[NSMutableDictionary alloc] init];
    _orderArray = [[NSMutableArray alloc] init];
    _statusArray = @[@"all", @"pay", @"confirm", @"4,7", @"5,9,10", @"8"];
   
    
    if (_selectIndex == 0 || _selectIndex == 1)
    {
        self.headerView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, 132);
        _bottomView.hidden = NO;
        [_tableView reloadData];
    }
    else
    {
        self.headerView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, 88);
        _bottomView.hidden = YES;
        [_tableView reloadData];
    }
    
    [_param setObject:_statusArray[_selectIndex] forKey:@"status"];
    
    [self initUI];
    [self getOrdersWithPage:_page];
}

- (void)backBtnClick
{
    if (self.fromPay)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        app.tabbar.selectedIndex = 0;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    for (UIViewController *vc in self.navigationController.viewControllers)
//    {
//        if ([vc isKindOfClass:[ShoppingCarViewController class]])
//        {
//            [self.navigationController popToViewController:vc animated:YES];
//        }
//
//    }
}

- (void)initUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[OrderListCell class] forCellReuseIdentifier:@"OrderListCell"];
    MJWeakSelf;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        weakSelf.page = 1;
        [weakSelf getOrdersWithPage:weakSelf.page];
    }];
    
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isRefresh = NO;
        weakSelf.page++;
        [weakSelf getOrdersWithPage:weakSelf.page];
    }];
    
    [self.view addSubview:_tableView];
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_selectIndex == 0 || _selectIndex == 1)
    {
        return 132;
    }
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_heightArray.count>indexPath.row)
    {
        return [_heightArray[indexPath.row] floatValue];
    }
    else
    {
        OrderModel *model = _dataArray[indexPath.row];
        
        CGFloat temp = 0;
        
        NSString *name = [NSString stringWithFormat:@"收件人：%@        电话：%@", model.receiveName, model.receivePhone];
        
        CGFloat height1 = [name boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+5;
        
        NSString *address = [NSString stringWithFormat:@"地址：%@ %@ %@ %@", model.receiveProvince, model.receiveCity, model.receiveArea, model.receiveAddress];
        
        CGFloat height2 = [address boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+5;
        
        temp = height1+height2+130;
        
        if (model.receiveIdCard.length > 0)
        {
            temp = temp+20;
        }
        
        if (model.shippingNumber.length > 0)
        {
            NSArray *array = [model.shippingNumber componentsSeparatedByString:@","];
            temp = temp+20+20*array.count;
        }
        
        if (model.firstShippingFeeAmount.length > 0)
        {
            temp = temp+17;
        }
        
        if (model.customerComment && model.customerComment.length > 0)
        {
            temp = temp + 17;
        }
        
       
        
        [self.heightArray addObject:[NSNumber numberWithDouble:temp]];
        
        return temp;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJWeakSelf;
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
    cell.fatherVC = self;
    if (_dataArray.count > 0)
    {
        cell.model = _dataArray[indexPath.row];
    }
    
    [cell handlerButtonAction:^(OrderModel *blockModel) {
        
        if (blockModel.btnName.length > 0)
        {
            if ([blockModel.btnName isEqualToString:@"去付款"])
            {
                if (![weakSelf.orderArray containsObject:blockModel.orderId] && blockModel.orderSelected)
                {
                    [weakSelf.orderArray addObject:blockModel.orderId];
                }
                else if (!blockModel.orderSelected && [weakSelf.orderArray containsObject:blockModel.orderId])
                {
                    [weakSelf.orderArray removeObject:blockModel.orderId];
                }
            }
            
            [self cellBtnActionWithModel:blockModel name:blockModel.btnName];
            blockModel.btnName = @"";
            
            
        }
        else
        {
            if (![weakSelf.orderArray containsObject:blockModel.orderId] && blockModel.orderSelected)
            {
                [weakSelf.orderArray addObject:blockModel.orderId];
            }
            else if (!blockModel.orderSelected && [weakSelf.orderArray containsObject:blockModel.orderId])
            {
                [weakSelf.orderArray removeObject:blockModel.orderId];
            }
        }
        
        
        
    }];
    
    return cell;
}


//- (void)viewWillDisappear:(BOOL)animated
//{
//    [_orderArray removeAllObjects];
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = _dataArray[indexPath.row];
    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
    vc.orderId = model.orderId;
    
    if ([model.totalAmount floatValue] == 0)
    {
        vc.miandan = YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    
    if (toIndex != fromIndex)
    {
        _selectIndex = toIndex;
        if (toIndex == 0 || toIndex == 1)
        {
            self.headerView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, 132);
            _bottomView.hidden = NO;
            [_tableView reloadData];
        }
        else
        {
            self.headerView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, 88);
            _bottomView.hidden = YES;
            [_tableView reloadData];
        }
        [_param setObject:_statusArray[toIndex] forKey:@"status"];
         [_heightArray removeAllObjects];
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        [self getOrdersWithPage:1];
    }
}

- (void)getOrdersWithPage:(NSInteger)page
{
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    
    MJWeakSelf;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/orders" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        
        if (page == 1)
        {
            [_dataArray removeAllObjects];
            [_heightArray removeAllObjects];
        }
        
        OrderListModel *listModel = [OrderListModel yy_modelWithDictionary:result[@"data"]];
        
        
        if (listModel.rows.count > 0)
        {
            if (weakSelf.isRefresh)
            {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            else
            {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.dataArray addObjectsFromArray:listModel.rows];
            
        }
        else
        {
            if (weakSelf.page == 1)
            {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            else
            {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [hud hideAnimated:YES];
        
        [weakSelf.tableView reloadData];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - 按钮ACTION
- (void)cellBtnActionWithModel:(OrderModel *)model name:(NSString *)name
{
    MJWeakSelf;
    if ([name isEqualToString:@"联系客服"])
    {
        ChatListVC *vc = [[ChatListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([name isEqualToString:@"去付款"])
    {
        self.orderArray = [[NSMutableArray alloc] initWithArray:@[model.orderId]];
        [self payAction];
    }
    else if ([name isEqualToString:@"删除"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除的订单无法查看和申请售后" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"继续删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
            [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
            [param setObject:@[model.orderId] forKey:@"orderIds"];
            [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/del" parameters:param success:^(NSURLSessionDataTask *task, id result) {
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.detailsLabel.text = @"删除成功";
                        [hud hideAnimated:YES afterDelay:1.2];
                        [self getOrdersWithPage:weakSelf.page];
                    });
                }
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([name isEqualToString:@"面单照片"])
    {
        NSMutableArray *browserDataArr = [NSMutableArray array];
       
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = [NSURL URLWithString:model.shipImgUrl];
        [browserDataArr addObject:data];
        
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = browserDataArr;
        browser.currentIndex = 0;
        [browser show];
        
    }
    else if ([name isEqualToString:@"实拍照片"])
    {
        NSMutableArray *browserDataArr = [NSMutableArray array];
        
        YBImageBrowseCellData *data = [YBImageBrowseCellData new];
        data.url = [NSURL URLWithString:model.shipPhotoUrl];
        [browserDataArr addObject:data];
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = browserDataArr;
        browser.currentIndex = 0;
        [browser show];
        
    }
}

#pragma mark - 搜索
- (void)searchAction
{
    [_param setObject:_searchText.text forKey:@"keyword"];
    
    _page = 1;
    [self getOrdersWithPage:1];
}

#pragma mark - 全选
- (void)allBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
   
    [self.orderArray removeAllObjects];
    for (OrderModel *model in self.dataArray)
    {
        model.orderSelected = btn.selected;
        if (model.status == 3 && model.orderSelected == YES)
        {
            if (![model.isPay isEqualToString:@"1"])
            {
                [self.orderArray addObject:model.orderId];
            }
        }
        
    }
    [_tableView reloadData];
    NSLog(@"%@", self.orderArray);
    
}


#pragma mark - 合并付款
- (void)payAction
{
    
    if (self.orderArray.count == 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = @"请选择订单进行支付，可以选择多个";
        [hud showAnimated:YES];
        
        [hud hideAnimated:YES afterDelay:1.2];
        return;
    }
    
    PayViewController *vc = [[PayViewController alloc] init];
    vc.idArray = self.orderArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 142)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        _segment = [LLSegmentBar segmentBarWithFrame:CGRectMake(5, 0, G_SCREEN_WIDTH-5, 44)];
        _segment.items = @[@"全部订单",@"待付款",@"待确认",@"待发货",@"已发货",@"已收货"];
        [_segment updateWithConfig:^(LLSegmentBarConfig *config) {
            config.indicatorColor(MainColor).itemSelectColor(MainColor).itemFont([UIFont systemFontOfSize:13]).itemNormalColor(TextColor);
            config.itemSFont = [UIFont systemFontOfSize:13];
            config.indicatorW = 5;
            config.indicatorHeight(1);
        }];
        _segment.delegate = self;
        _segment.selectIndex = _selectIndex;
        [_headerView addSubview:_segment];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, G_SCREEN_WIDTH, 1)];
        lineView1.backgroundColor = LineColor;
        [_headerView addSubview:lineView1];
        
        _searchText = [[UITextField alloc] initWithFrame:CGRectMake(10, 44, G_SCREEN_WIDTH-20, 44)];
        _searchText.placeholder = @"订单号 / 快递单号 / 姓名 / 电话 / 地址 / 产品名称";
        _searchText.font = [UIFont systemFontOfSize:12];
        [_headerView addSubview:_searchText];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-50, 59, 14, 14)];
        [btn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:btn];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, G_SCREEN_WIDTH, 44)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:_bottomView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_bottomView addSubview:lineView];
        
        UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 14, 16, 16)];
        [allBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [allBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [allBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:allBtn];
        
        UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-75, 7, 70, 30)];
        [payBtn setTitle:@"合并支付" forState:UIControlStateNormal];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [payBtn setTitleColor:TextColor forState:UIControlStateNormal];
        [payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:payBtn];
    }
    return _headerView;
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
