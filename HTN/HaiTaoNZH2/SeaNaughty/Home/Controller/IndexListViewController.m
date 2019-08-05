//
//  IndexListViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "IndexListViewController.h"
#import "RankBtnView.h"
#import "ProductListModel.h"
#import "ProductCollectionCell.h"
#import "StorehouseView.h"
#import "RankCollectionHeaderView.h"
#import "ProductDetailViewController.h"


@interface IndexListViewController () <UICollectionViewDelegate, UICollectionViewDataSource,RankBtnViewDelegate,StorehouseViewDelege, HeaderViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) NSMutableDictionary *param;

@end

@implementation IndexListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _param = [[NSMutableDictionary alloc] init];
    self.leftBackBtn = YES;
    
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];

    MJWeakSelf;
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 2;
    _flowLayout.minimumInteritemSpacing = 2;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.itemSize = CGSizeMake(G_SCREEN_WIDTH/2-1, 340);
    _flowLayout.headerReferenceSize = CGSizeMake(G_SCREEN_WIDTH, 170+70+50);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:G_SCREEN_BOUNDS collectionViewLayout:_flowLayout];
    [_collectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
    [_collectionView registerClass:[RankCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
   
    
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
    
    [_footer setTitle:@"小主，没有更多了哦~" forState:MJRefreshStateNoMoreData];
    
    _collectionView.mj_footer = _footer;
    
    
    [self getActivityProductsWithPage:_page];
  
}

- (void)rankBtnViewWithParam:(NSDictionary *)dic
{
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        if (_model)
        {
            RankCollectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
            view.delegate = self;
            view.model = _model;
            view.backgroundColor = LineColor;
            
            return view;
        }
        return nil;
        
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
    if (_dataArray.count > 0)
    {
        return _dataArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    ProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (_dataArray.count > 0)
    {
        cell.data = _dataArray[indexPath.item];
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    //商品详情需要登录的时候修改
//    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
//    {
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    ProductModel *model = _dataArray[indexPath.item];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    vc.productId = model.productId;
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)postParam:(NSDictionary *)dic
{
    
    [_param setValuesForKeysWithDictionary:dic];
    _page = 1;
    [self getActivityProductsWithPage:_page];
    
}

- (void)selectShop:(NSString *)shopId
{
    [_param setValue:shopId forKey:@"shopId"];
    _page = 1;
    [self getActivityProductsWithPage:_page];
}






#pragma mark - 获取数据
- (void)getActivityProductsWithPage:(NSInteger)page
{
    MJWeakSelf;
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    loadingHud.label.text = @"正在加载";
    [loadingHud showAnimated:YES];
    
    if (_model.activityID)
    {
        [_param setObject:_model.activityID forKey:@"activityId"];
    }
    
    if (_model.rule)
    {
        [_param setObject:_model.rule forKey:@"activityRule"];
    }
    
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        
        [loadingHud hideAnimated:YES];
        
        if (page == 1)
        {
            [_dataArray removeAllObjects];
        }
        
        NSArray *products = result[@"data"][@"products"];
        
        ProductListModel *list = [ProductListModel yy_modelWithDictionary:result[@"data"]];
        
        
        if (products.count>0)
        {
            if (weakSelf.isRefresh)
            {
                [weakSelf.collectionView.mj_header endRefreshing];
            }
            else
            {
                weakSelf.collectionView.mj_footer = weakSelf.footer;
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
            [weakSelf.dataArray addObjectsFromArray:list.products];
           
        }
        else
        {
            if (weakSelf.isRefresh)
            {
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            else
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
       
        
        [weakSelf.collectionView reloadData];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




@end
