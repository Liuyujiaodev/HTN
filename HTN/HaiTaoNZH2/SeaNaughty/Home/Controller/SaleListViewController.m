//
//  SaleListViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/7.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "SaleListViewController.h"
#import "RankBtnView.h"
#import "StorehouseView.h"
#import "SaleCell.h"
#import "ProductListModel.h"
#import "ProductDetailViewController.h"


@interface SaleListViewController () <UITableViewDelegate,UITableViewDataSource,RankBtnViewDelegate,StorehouseViewDelege>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableDictionary *param;
@end

@implementation SaleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _param = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBackBtn = YES;
    
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    
//    MJWeakSelf;
    
    _tableView = [[BaseTableView alloc] initWithFrame:G_SCREEN_BOUNDS style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    [_tableView registerClass:[SaleCell class] forCellReuseIdentifier:@"SaleCell"];
    [self.view addSubview:_tableView];
    
    [self getActivityProductsWithPage:1];
    
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SaleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SaleCell" forIndexPath:indexPath];
    ProductModel *model = _dataArray[indexPath.row];
    
    cell.data = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //商品详情需要登录的时候修改
//    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
//    {
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    
    ProductModel *model = _dataArray[indexPath.row];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    vc.productId = model.productId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 获取数据
- (void)getActivityProductsWithPage:(NSInteger)page
{
    MJWeakSelf;
    
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products/limitedSpecials" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
    
        
        ProductListModel *list = [ProductListModel yy_modelWithDictionary:result];
        
        [weakSelf.dataArray addObjectsFromArray:list.data];
        [weakSelf.tableView reloadData];
        
//        if (products.count>0)
//        {
//            if (products.count < 4)
//            {
//                weakSelf.tableView.mj_footer = nil;
//            }
//
//            if (weakSelf.isRefresh)
//            {
//                [weakSelf.tableView.mj_header endRefreshing];
//                weakSelf.tableView.mj_footer = weakSelf.footer;
//            }
//            else
//            {
//                [weakSelf.tableView.mj_footer endRefreshing];
//            }
//            [weakSelf.dataArray addObjectsFromArray:list.products];
//
//            [weakSelf.tableView reloadData];
//        }
//        else
//        {
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
        
        
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
}



- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 250)];
        
        _headerView.backgroundColor = LineColor;
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 170)];
        bgImageView.image = [UIImage imageNamed:@"shpoBg"];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:bgImageView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-100, 48, 200, 74)];
        bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        bgView.layer.borderWidth = 1.8;
        bgView.backgroundColor = RGBACOLOR(255, 255, 255, 0.3);
        
        [_headerView addSubview:bgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 200, 20)];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"限时秒杀";
        [bgView addSubview:titleLabel];
        
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 200, 20)];
        subLabel.font = [UIFont systemFontOfSize:13];
        subLabel.textColor = [UIColor whiteColor];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.text = @"优选好货冰点价";
        [bgView addSubview:subLabel];
        
        StorehouseView *store = [[StorehouseView alloc] initWithFrame:CGRectMake(0, 170, G_SCREEN_WIDTH, 70)];
        store.delegat = self;
        [_headerView addSubview:store];
        
      
    }
    return _headerView;
}



- (void)storehouseViewSelected:(ShopModel *)model
{
    NSLog(@"%@", model.name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
