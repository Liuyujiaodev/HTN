//
//  ListNextViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/13.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ListNextViewController.h"
#import "ProductCollectionCell.h"
#import "CategoryCollectionView.h"
#import "ProductListModel.h"
#import "RankBtnView.h"
#import "ProductDetailViewController.h"


@interface ListNextViewController () <UICollectionViewDelegate, UICollectionViewDataSource, RankBtnViewDelegate, SubCategoryDelegate>

@property (nonatomic, strong) CategoryCollectionView *topView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) NSMutableDictionary *param;

@end

@implementation ListNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _param = [[NSMutableDictionary alloc] init];
    self.title = _model.name;
    [self initUI];
    
    [self getActivityProductsWithPage:self.page];
}

- (void)initUI
{
    self.view.backgroundColor = LineColor;
    
    _topView = [[CategoryCollectionView alloc] initWithFrame:CGRectMake(0, G_STATUSBAR_HEIGHT+44, G_SCREEN_WIDTH, 80)];
    _topView.dataArray = _category.children;
    _topView.selectedModel = _model;
    _topView.subDelegate = self;
    [self.view addSubview:_topView];
    
    
    RankBtnView *rank = [[RankBtnView alloc] initWithFrame:CGRectMake(0, G_STATUSBAR_HEIGHT+130, G_SCREEN_WIDTH, 40)];
    rank.delegate = self;
    rank.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rank];
   
    MJWeakSelf;
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 2;
    _flowLayout.minimumInteritemSpacing = 2;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.itemSize = CGSizeMake(G_SCREEN_WIDTH/2-1, 340);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, G_STATUSBAR_HEIGHT+170, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-G_STATUSBAR_HEIGHT-170) collectionViewLayout:_flowLayout];
    [_collectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    
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
    
    [_footer setTitle:@"小主，没有更多了哦" forState:MJRefreshStateNoMoreData];
    
    _collectionView.mj_footer = _footer;
    
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

- (void)categoryCollectionSelectedModel:(ChildrenModel *)model
{
    _model = model;
    _page = 1;
    [self.collectionView reloadData];
    [self.collectionView scrollsToTop];
    [self getActivityProductsWithPage:1];
}

- (void)rankBtnViewWithParam:(NSDictionary *)dic
{
    
    [_param setValuesForKeysWithDictionary:dic];
    
    [self getActivityProductsWithPage:1];
    
    
}




#pragma mark - 获取数据
- (void)getActivityProductsWithPage:(NSInteger)page
{
    
    MJWeakSelf;
    
    if (!_model.childrenId)
    {
        return;
    }
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    loadingHud.label.text = @"正在加载";
    [loadingHud showAnimated:YES];
    
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    [_param setObject:_model.childrenId forKey:@"subCategoryId"];
    [_param setObject:_model.parentId forKey:@"categoryId"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        [loadingHud hideAnimated:YES];
        if (page == 1)
        {
            [_dataArray removeAllObjects];
            _collectionView.mj_footer = nil;
        }
        
        NSArray *products = result[@"data"][@"products"];
        
        ProductListModel *list = [ProductListModel yy_modelWithDictionary:result[@"data"]];
        
        if (products.count>0)
        {
            weakSelf.collectionView.mj_footer = weakSelf.footer;
            if (weakSelf.isRefresh)
            {
                [weakSelf.collectionView.mj_header endRefreshing];
            }
            else
            {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
            [weakSelf.dataArray addObjectsFromArray:list.products];
        }
        else
        {
            if (weakSelf.page == 1)
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
