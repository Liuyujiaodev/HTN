//
//  ListShopViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/12.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ListShopViewController.h"
#import "ProductCollectionCell.h"
#import "ProductListModel.h"
#import "RankBtnView.h"
#import "ProductDetailViewController.h"
#import "FilterView.h"
#import "WKTagListView.h"
#import "ShopListModel.h"
#import "CommonModelList.h"
#import "BaseCollectionView.h"


@interface ListShopViewController () <UICollectionViewDelegate, UICollectionViewDataSource, RankBtnViewDelegate, FilterViewDelegate>

@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) NSArray *brandArray;
@property (nonatomic, strong) WKTagListView *listView1;
@property (nonatomic, strong) WKTagListView *listView2;
@property (nonatomic, strong) WKTagListView *listView3;
@property (nonatomic, strong) FilterView *filterView;

@end

@implementation ListShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBackBtn = YES;
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _param = [[NSMutableDictionary alloc] init];
    
    [self initUI];
    
    if (_searchString.length > 0)
    {
        [_param setObject:_searchString forKey:@"keyword"];
        self.searchText = _searchString;
        
    }
    
    if (_shopId.length > 0)
    {
        [_param setObject:_shopId forKey:@"shopId"];
    }
    
    if (self.shopArray)
    {
        [_param setObject:self.shopArray forKey:@"shopId"];
    }
    
    [self getActivityProductsWithPage:self.page];
    
    
    
}



- (void)initUI
{
    self.view.backgroundColor = LineColor;
    
    RankBtnView *rank = [[RankBtnView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT, G_SCREEN_WIDTH, 40)];
    rank.delegate = self;
    rank.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rank];
    
    _filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+40, G_SCREEN_WIDTH, 40)];
    _filterView.delegate = self;
    [self.view addSubview:_filterView];
    
    MJWeakSelf;
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 2;
    _flowLayout.minimumInteritemSpacing = 2;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.itemSize = CGSizeMake(G_SCREEN_WIDTH/2-1, 340);
    
    _collectionView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+88, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-G_NAV_HEIGHT-88) collectionViewLayout:_flowLayout];
    [_collectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
    //    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionView.hidden = YES;
    _collectionView.emptyText = @"您要的相关产品还未上架，去找找其他的吧";
    _collectionView.showEmptyView = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = LineColor;
    
    [self.view addSubview:_collectionView];
    
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = NO;
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
    //商品详情需要登录的时候修改
//    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
//    {
//        LoginViewController *vc = [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
    ProductModel *model = _dataArray[indexPath.item];
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
//    NewProductDetailVC *vc = [[NewProductDetailVC alloc] init];
    vc.productId = model.productId;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)rankBtnViewWithParam:(NSDictionary *)dic
{
    
    [_param setValuesForKeysWithDictionary:dic];
    
    [self getActivityProductsWithPage:1];
    
}

- (void)selectedIndex:(int)index show:(BOOL)isShow
{
    if (isShow)
    {
        if (index == 0)
        {
            self.view1.hidden = NO;
            self.view2.hidden = YES;
            self.view3.hidden = YES;
        }
        else if (index == 1)
        {
            self.view2.hidden = NO;
            self.view1.hidden = YES;
            self.view3.hidden = YES;
        }
        else if (index == 2)
        {
            self.view3.hidden = NO;
            self.view2.hidden = YES;
            self.view1.hidden = YES;
        }
        self.btnView.hidden = NO;
    }
    else
    {
        self.view1.hidden = YES;
        self.view2.hidden = YES;
        self.view3.hidden = YES;
        self.btnView.hidden = YES;
    }
    
}




#pragma mark - 获取数据
- (void)getActivityProductsWithPage:(NSInteger)page
{
    
    MJWeakSelf;
    
    
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    
   
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    loadingHud.label.text = @"正在加载";
    [loadingHud showAnimated:YES];

    
    NSString *url = @"/webapi/v3/products";
    if ([_param.allKeys containsObject:@"keyword"] || [_param.allKeys containsObject:@"brandId"] || [_param.allKeys containsObject:@"mainCategoryId"] || [_param.allKeys containsObject:@"shopId"])
    {
        url = @"/webapi/v3/search/products";
    }
    
    
    [AppService requestHTTPMethod:@"get" URL:url parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        
        [loadingHud hideAnimated:YES];
        _collectionView.hidden = NO;
        NSArray *products = result[@"data"][@"products"];
        if (page == 1)
        {
            weakSelf.collectionView.mj_footer = nil;
            [_dataArray removeAllObjects];
        }
        
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
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            
            if (weakSelf.isRefresh)
            {
                [weakSelf.collectionView.mj_header endRefreshing];
            }
        }
        
        [weakSelf.collectionView reloadData];
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
}

- (UIView *)view1
{
    if (!_view1)
    {
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+80, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
        _listView1 = [[WKTagListView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 240)];
        _listView1.canSelectMulti = YES;
        NSMutableArray *data = [[NSMutableArray alloc] init];
        for (CommonModel *model in self.brandArray)
        {
            [data addObject:model.name];
        }
        _listView1.tags = data;
       
        _listView1.backgroundColor = [UIColor whiteColor];
        [_view1 addSubview:_listView1];
        MJWeakSelf;
        [_listView1 setCompletionBlockWithSelected:^(NSInteger index) {
            for (CommonModel *model in weakSelf.brandArray)
            {
                if ([data[index] isEqualToString:model.name])
                {
                    
                }
            }
            
        }];
        [self.view addSubview:_view1];
    }
    return _view1;
}

- (UIView *)view2
{
    if (!_view2)
    {
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+80, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
        _listView2 = [[WKTagListView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 240)];
        _listView2.backgroundColor = [UIColor whiteColor];
        _listView2.canSelectMulti = NO;
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        for (CategoryModel *model in self.categoryList.data)
        {
            [data addObject:model.name];
        }
        
        _listView2.tags = data;
        _listView2.tagBackGroundColor = LineColor;
        _listView2.backgroundColor = [UIColor whiteColor];
        [_view2 addSubview:_listView2];
        MJWeakSelf;
        [_listView2 setCompletionBlockWithSelected:^(NSInteger index) {
            
            for (CategoryModel *model in weakSelf.categoryList.data)
            {
                if ([model.name isEqualToString:data[index]])
                {
                    if (model.categoryID)
                    {
                        [weakSelf.param setObject:model.categoryID forKey:@"mainCategoryId"];
                    }
                    else if (model.mainCategoryId)
                    {
                        [weakSelf.param setObject:model.mainCategoryId forKey:@"mainCategoryId"];
                    }
                    
                }
            }
        }];
        [self.view addSubview:_view2];
    }
    return _view2;
}

- (UIView *)view3
{
    if (!_view3)
    {
        _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+80, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
        _listView3 = [[WKTagListView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 240)];
        _listView3.canSelectMulti = NO;
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:SHOPLIST];
        ShopListModel *listModel = [ShopListModel yy_modelWithDictionary:dic];
        
        NSMutableArray *data = [[NSMutableArray alloc] init];
        for (ShopModel *model in listModel.data)
        {
            [data addObject:model.name];
        }
        
        _listView3.tags = data;
        _listView3.tagBackGroundColor = LineColor;
        _listView3.backgroundColor = [UIColor whiteColor];
        [_view3 addSubview:_listView3];
        MJWeakSelf;
        [_listView3 setCompletionBlockWithSelected:^(NSInteger index) {
            
            for (ShopModel *model in listModel.data)
            {
                if ([model.name isEqualToString:data[index]])
                {
                    [weakSelf.param setObject:model.shopId forKey:@"shopId"];
                }
            }
            
        }];
        [self.view addSubview:_view3];
    }
    return _view3;
}



- (UIView *)btnView
{
    if (!_btnView)
    {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+320, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_btnView addSubview:lineView];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, G_SCREEN_WIDTH/2, 32)];
        [cancleBtn setTitle:@"重置" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:MainColor forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [_btnView addSubview:cancleBtn];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2, 1, G_SCREEN_WIDTH/2, 32)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        sureBtn.backgroundColor = MainColor;
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:sureBtn];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 33, G_SCREEN_WIDTH, 1500)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.4;
        [_btnView addSubview:bgView];
        
        [self.view addSubview:_btnView];
        
    }
    return _btnView;
}

#pragma mark - 取消
- (void)cancleAction
{
    self.listView1.allBecomeNormal = YES;
    self.listView2.allBecomeNormal = YES;
    self.listView3.allBecomeNormal = YES;
    [_param removeObjectForKey:@"brandId"];
    [_param removeObjectForKey:@"mainCategoryId"];
    [_param removeObjectForKey:@"shopId"];
//    self.filterView.hideAll = YES;
}

#pragma mark - 确定
- (void)sureAction
{
    self.view1.hidden = YES;
    self.view2.hidden = YES;
    self.view3.hidden = YES;
    self.btnView.hidden = YES;
    self.filterView.hideAll = YES;
    _page = 1;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    if (_listView1.selectedTags.count > 0)
    {
        for (NSString *str in _listView1.selectedTags)
        {
            for (CommonModel *model in self.brandArray)
            {
                if ([str isEqualToString:model.name])
                {
                    [temp addObject:model.commonID];
                }
            }
        }
        NSString *brandId = [temp componentsJoinedByString:@","];
        [_param setObject:brandId forKey:@"brandId"];
    }
    else
    {
        [_param removeObjectForKey:@"brandId"];
    }
    
    [self getActivityProductsWithPage:1];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (self.searchString.length > 0)
    {
        [param setObject:self.searchString forKey:@"keyword"];
        
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/search/brands" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            CommonModelList *list = [CommonModelList yy_modelWithDictionary:result];
            self.brandArray = list.data;
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
        }];
        
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/search/categories" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            CategoryListModel *list = [CategoryListModel yy_modelWithDictionary:result];
            
            self.categoryList = list;
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else
    {
        [param setObject:@"1" forKey:@"pageNumber"];
        [param setObject:@"1000" forKey:@"pageSize"];
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/brand/list" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            CommonModelList *list = [CommonModelList yy_modelWithDictionary:result[@"data"]];
            self.brandArray = list.rows;
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
        }];
        
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/categories/pc" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
            CategoryListModel *list = [CategoryListModel yy_modelWithDictionary:result];
            
            self.categoryList = list;
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
