
//
//  MoneyViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/6.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "MoneyViewController.h"
#import "LLSegmentBar.h"
#import "MoneyListModel.h"
#import "MoneyCell.h"

@interface MoneyViewController () <UITableViewDelegate, UITableViewDataSource, LLSegmentBarDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) LLSegmentBar *bar;

@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额明细";
    _page = 1;
    _param = [[NSMutableDictionary alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    [self initUI];
    
    [self getWalletInfo:1];
    
}

- (void)initUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:G_SCREEN_BOUNDS style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.backgroundColor = LineColor;
   
//    _tableView.emptyFrame = NSStringFromCGRect(CGRectMake(G_SCREEN_WIDTH/2-100, 400, 200, 200));
//    _tableView.showEmptyView = YES;
    [_tableView registerClass:[MoneyCell class] forCellReuseIdentifier:@"MoneyCell"];
    [self.view addSubview:_tableView];
    MJWeakSelf;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        weakSelf.isRefresh = YES;
        [self getWalletInfo:1];
    }];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 30)];
    label1.text = @"充值和提现请联系公众号‘NZH为您服务’客服";
    label1.textAlignment = NSTextAlignmentCenter;
//    label1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label1.textColor = TitleColor;
    label1.font = [UIFont systemFontOfSize:12];
    _tableView.tableFooterView = label1;
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        weakSelf.isRefresh = NO;
        [self getWalletInfo:weakSelf.page];
    }];
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
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyCell" forIndexPath:indexPath];
    
    if (_dataArray.count > 0)
    {
        cell.model = _dataArray[indexPath.row];
        cell.showLine = indexPath.row == 0 ? NO : YES;
    }
    
    return cell;
}

#pragma mark - 获取余额
- (void)getWalletInfo:(NSInteger)page
{
    NSString *pagee = [NSString stringWithFormat:@"%li", (long)_page];
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:pagee forKey:@"pageNumber"];
    [_param setObject:@"10" forKey:@"pageSize"];
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/getWalletInfo" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        [loadingHud hideAnimated:YES];
        if (page == 1)
        {
            [_dataArray removeAllObjects];
        }
        
        _money = result[@"data"][@"walletSum"];
        
        MoneyListModel *listModel = [MoneyListModel yy_modelWithDictionary:result[@"data"][@"walletSnapshot"]];
        
        
        NSArray *array = listModel.rows;
        
        if (array.count>0)
        {
            if (weakSelf.isRefresh)
            {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            else
            {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.dataArray addObjectsFromArray:array];
            
            [weakSelf.tableView reloadData];
        }
        else
        {
            if (weakSelf.page == 1)
            {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
                
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            {
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    
    if (toIndex != fromIndex)
    {
        toIndex == 0 ? [_param setObject:@"" forKey:@"type"] : [_param setObject:[NSString stringWithFormat:@"%li", toIndex] forKey:@"type"];
        
        _page = 1;
        [self getWalletInfo:_page];
        
    }
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 220)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 170)];
        view.backgroundColor = MainColor;
        [_headerView addSubview:view];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, G_SCREEN_WIDTH, 20)];
        label1.text = @"账户余额";
        label1.font = [UIFont systemFontOfSize:13];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor whiteColor];
        [_headerView addSubview:label1];
        
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, G_SCREEN_WIDTH, 40)];
        moneyLabel.text = _money;
        moneyLabel.font = [UIFont systemFontOfSize:30];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.textColor = [UIColor whiteColor];
        [_headerView addSubview:moneyLabel];
        
        _bar = [[LLSegmentBar alloc] initWithFrame:CGRectMake(0, 170, G_SCREEN_WIDTH, 50)];
        _bar.items = @[@"全部",@"充值",@"提现",@"订单消费",@"订单退款"];
        _bar.delegate = self;
        _bar.selectIndex = 0;
        _bar.isLeft = YES;
        [_bar updateWithConfig:^(LLSegmentBarConfig *config) {
            config.itemSelectColor(TitleColor).itemNormalColor(TitleColor).itemFont([UIFont systemFontOfSize:13]);
//            config.itemFont([UIFont boldSystemFontOfSize:13]);
            config.itemSFont = [UIFont boldSystemFontOfSize:13];
            config.indicatorC = [UIColor whiteColor];
//            config.in
        }];
        [_headerView addSubview:_bar];
        
    }
    return _headerView;
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
