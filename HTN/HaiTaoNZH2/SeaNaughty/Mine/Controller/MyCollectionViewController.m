//
//  MyCollectionViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/2.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "RankCollectionHeaderView.h"
#import "ProductCollectionCell.h"
#import "ProductDetailViewController.h"
#import "StorehouseView.h"
#import "ProductListModel.h"

@interface MyCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource,StorehouseViewDelege>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UITextField *searchText;
@property (nonatomic, strong) UIView *emptyView;


@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _param = [[NSMutableDictionary alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    self.view.backgroundColor = LineColor;
    MJWeakSelf;
    
    self.title = @"我的收藏夹";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT, G_SCREEN_WIDTH, 118)];
    view.backgroundColor = [UIColor whiteColor];
    _searchText = [[UITextField alloc] initWithFrame:CGRectMake(15, 4, G_SCREEN_WIDTH-60, 40)];
    _searchText.placeholder = @"请输入产品名字";
    _searchText.textColor = TextColor;
    _searchText.font = [UIFont systemFontOfSize:14];
    [view addSubview:_searchText];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-35, 14, 20, 20)];
    [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:searchBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, G_SCREEN_WIDTH, 2)];
    lineView.backgroundColor = LineColor;
    [view addSubview:lineView];
    
    StorehouseView *storeView = [[StorehouseView alloc] initWithFrame:CGRectMake(0, 48, G_SCREEN_WIDTH, 70)];
    storeView.delegat = self;
    storeView.firstName = @"全部产品";
    [view addSubview:storeView];
    
    [self.view addSubview:view];
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 2;
    _flowLayout.minimumInteritemSpacing = 2;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.itemSize = CGSizeMake(G_SCREEN_WIDTH/2-1, 340);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+125, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-70-52-G_NAV_HEIGHT) collectionViewLayout:_flowLayout];
    [_collectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
//    [_collectionView registerClass:[RankCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = LineColor;
    
    [self.view addSubview:_collectionView];
    
    
    
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.isRefresh = YES;
        weakSelf.page = 1;
        [weakSelf getActivityProductsWithPage:weakSelf.page];
        
    }];
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isRefresh = NO;
        weakSelf.page++;
        [weakSelf getActivityProductsWithPage:weakSelf.page];
    }];
    
//    _collectionView.mj_footer = _footer;
    
    
    [self getActivityProductsWithPage:_page];
    
    [self.view addSubview:self.emptyView];
    
}


- (void)storehouseViewSelected:(ShopModel *)model
{
    [_param setObject:model.shopId forKey:@"shopId"];
    
    [self getActivityProductsWithPage:1];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        RankCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = LineColor;
        
        return view;
        
    }
    else
        return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.data = _dataArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *model = _dataArray[indexPath.item];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    vc.productId = model.productId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchAction
{
    [_param setObject:_searchText.text forKey:@"productName"];
    
    [self getActivityProductsWithPage:1];
    
}



#pragma mark - 获取数据
- (void)getActivityProductsWithPage:(NSInteger)page
{
    
    
    MJWeakSelf;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/favorites" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        if (page == 1)
        {
            _collectionView.mj_footer = nil;
            [_dataArray removeAllObjects];
        }
        
        NSArray *products = result[@"data"][@"rows"];
        
        ProductListModel *list = [ProductListModel yy_modelWithDictionary:result[@"data"]];
        
        
        if (products.count>0)
        {
            weakSelf.emptyView.hidden = YES;
            
            if (weakSelf.isRefresh)
            {
                [weakSelf.collectionView.mj_header endRefreshing];
                weakSelf.collectionView.mj_footer = weakSelf.footer;
            }
            else
            {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
            [weakSelf.dataArray addObjectsFromArray:list.rows];
            
            [weakSelf.collectionView reloadData];
        }
        else
        {
            if (weakSelf.page == 1)
            {
                weakSelf.emptyView.hidden = NO;
                [weakSelf.collectionView reloadData];
                [weakSelf.collectionView.mj_header endRefreshing];
            }
            else
            {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [hud hideAnimated:YES];
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
}


- (UIView *)emptyView
{
    if (!_emptyView)
    {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-60, 220+G_NAV_HEIGHT, 120, 120)];
        [self.view addSubview:_emptyView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 60, 60)];
        imageView.image = [UIImage imageNamed:@"empty"];
        [_emptyView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 120, 20)];
        label.text = @"还没有任何收藏哦~";
        label.textColor = LightGrayColor;
        label.font = [UIFont systemFontOfSize:12];
        [_emptyView addSubview:label];
        _emptyView.hidden = YES;
    }
    return _emptyView;
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
