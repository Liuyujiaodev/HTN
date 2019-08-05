//
//  BrandAllViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/6.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BrandAllViewController.h"
#import "CommonModelList.h"
#import "BrandListViewController.h"
@interface BrandAllViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@end

@implementation BrandAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    MJWeakSelf;
    self.view.backgroundColor = LineColor;
    [self getBrandsWithPage:_page];
    self.title = @"品牌";
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(10, 0, G_SCREEN_WIDTH-20, G_SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        weakSelf.page = 1;
        [weakSelf getBrandsWithPage:weakSelf.page];
    }];
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isRefresh = NO;
        weakSelf.page++;
        [weakSelf getBrandsWithPage:weakSelf.page];
    }];
    
    [_footer setTitle:@"小主，没有更多了哦~" forState:MJRefreshStateNoMoreData];
    _tableView.mj_footer = _footer;
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
    NSString *identifierString = [NSString stringWithFormat:@"cell%li%li",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH-20, 5)];
        lineView.backgroundColor = LineColor;
        [cell.contentView addSubview:lineView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 20, G_SCREEN_WIDTH-50, 20)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = TextColor;
        nameLabel.tag = 1000+indexPath.row;
        [cell.contentView addSubview:nameLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 60, G_SCREEN_WIDTH-20-24, 120)];
        imageView.tag = 100+indexPath.row;
        [cell.contentView addSubview:imageView];
        
    }
    
    if (_dataArray.count>0)
    {
        CommonModel *model = _dataArray[indexPath.row];
        UILabel *nameLabel = [cell.contentView viewWithTag:1000+indexPath.row];
        UIImageView *imageView = [cell.contentView viewWithTag:100+indexPath.row];
        
        nameLabel.text = model.name;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.backImg]];
    }
    
    return cell;
}

#pragma mark - 获取品牌数据
- (void)getBrandsWithPage:(int)page
{
    _page = page;
    if (page==1)
    {
        [_dataArray removeAllObjects];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%i",_page] forKey:@"pageNumber"];
    [param setObject:@"10" forKey:@"pageSize"];
    
    __weak typeof(self) weakSelf = self;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/brand/list" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        CommonModelList *list = [CommonModelList yy_modelWithDictionary:result[@"data"]];
        NSArray *array = list.rows;
        
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
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                [weakSelf.tableView reloadData];
            }
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
//        [weakSelf.dataArray addObjectsFromArray:list.rows];
//        [weakSelf.tableView reloadData];
       
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonModel *model = _dataArray[indexPath.row];
    BrandListViewController *vc = [[BrandListViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
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
