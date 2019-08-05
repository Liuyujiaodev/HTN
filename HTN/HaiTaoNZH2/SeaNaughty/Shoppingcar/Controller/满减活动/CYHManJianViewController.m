//
//  CYHManJianViewController.m
//  SeaNaughty
//
//  Created by Apple on 2019/6/28.
//  Copyright © 2019年 chilezzz. All rights reserved.
//

#import "CYHManJianViewController.h"

#import "ProductCollectionCell.h"
#import "ProductListModel.h"
#import "RankBtnView.h"
#import "ProductDetailViewController.h"
#import "FilterView.h"
#import "WKTagListView.h"
#import "ShopListModel.h"
#import "CommonModelList.h"
#import "BaseCollectionView.h"

@interface CYHManJianViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, RankBtnViewDelegate, FilterViewDelegate>

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

@implementation CYHManJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"满减活动";
    
    
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _param = [[NSMutableDictionary alloc] init];
    
    [self initUI];
    
    
    
    [self getActivityProductsWithPage:self.page];
    
}



- (void)initUI
{
    self.view.backgroundColor = LineColor;
    
    UIView* manBgView = [[UIView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT, G_SCREEN_WIDTH, 40)];
    manBgView.backgroundColor = RGBCOLOR(255, 253, 243);
    [self.view addSubview:manBgView];
    
    
    UILabel* manTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, G_SCREEN_WIDTH, 20)];
    manTitleLabel.text = [NSString stringWithFormat:@"满减活动:<%@>",self.manShoppingDic[@"prefixName"]];
    manTitleLabel.textColor = [UIColor blackColor];
    manTitleLabel.font = [UIFont systemFontOfSize:12];
    [manBgView addSubview:manTitleLabel];
    
    
    RankBtnView *rank = [[RankBtnView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+40, G_SCREEN_WIDTH, 40)];
    rank.delegate = self;
    rank.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rank];
    
//    _filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT+40, G_SCREEN_WIDTH, 40)];
//    _filterView.delegate = self;
//    [self.view addSubview:_filterView];
    
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

#pragma mark - 获取数据
- (void)getActivityProductsWithPage:(NSInteger)page
{
    
    MJWeakSelf;
    
    
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    
    
    [_param setObject:self.manShoppingDic[@"shopId"] forKey:@"shopId"];
    [_param setObject:self.manShoppingDic[@"productIds"] forKey:@"productIds"];
    [_param setObject:self.manShoppingDic[@"activityProduct"] forKey:@"activityProduct"];
    
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    loadingHud.label.text = @"正在加载";
    [loadingHud showAnimated:YES];
    
    
    NSString *url = @"/webapi/v3/products";
    
    
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
