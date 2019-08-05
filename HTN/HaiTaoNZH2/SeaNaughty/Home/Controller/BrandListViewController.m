//
//  BrandListViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/6.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BrandListViewController.h"
#import "ProductCollectionCell.h"
#import "ProductListModel.h"
#import "RankBtnView.h"
#import "ProductDetailViewController.h"


@interface BrandListViewController () <UICollectionViewDelegate, UICollectionViewDataSource,RankBtnViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, strong) RankBtnView *rankView;

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌中心";
    
    
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _param = [[NSMutableDictionary alloc] init];
    
    [_param setObject:_model.commonID forKey:@"brandId"];
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [_param setObject:@"30" forKey:@"pageSize"];
    MJWeakSelf;
    
    NSString *intro = _model.intro;
    
    _headerHeight = [intro boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+2;
    
    if (intro.length == 0)
    {
        _headerHeight = 0;
    }
    _rankView = [[RankBtnView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 40)];
    _rankView.delegate = self;
    _rankView.backgroundColor = [UIColor whiteColor];
    
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 2;
    _flowLayout.minimumInteritemSpacing = 2;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.itemSize = CGSizeMake(G_SCREEN_WIDTH/2-1, 340);
//    _flowLayout.headerReferenceSize = CGSizeMake(G_SCREEN_WIDTH, 40);
//    _flowLayout.footerReferenceSize = CGSizeMake(G_SCREEN_WIDTH, 210+_headerHeight);
    _flowLayout.sectionHeadersPinToVisibleBounds = YES;
//    _flowLayout.
    
    _collectionView = [[UICollectionView alloc] initWithFrame:G_SCREEN_BOUNDS collectionViewLayout:_flowLayout];
    [_collectionView registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
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
    
    [self getActivityProductsWithPage:_page];
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==0)
    {
        return CGSizeZero;
    }
    return CGSizeMake(G_SCREEN_WIDTH, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGSizeMake(G_SCREEN_WIDTH, 210+_headerHeight);
    }
    return CGSizeZero;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        
        for (UIView *views in view.subviews)
        {
            [views removeFromSuperview];
        }
        
        view.backgroundColor = LineColor;
        
        
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 200+_headerHeight)];
        topView.image = [UIImage imageNamed:@"brankbg"];
        topView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:topView];
        
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 78, 78)];
        [logoView sd_setImageWithURL:[NSURL URLWithString:_model.logo]];
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        logoView.layer.borderColor = LineColor.CGColor;
        logoView.layer.borderWidth = 0.9f;
        logoView.backgroundColor = [UIColor whiteColor];
        [topView addSubview:logoView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 120, G_SCREEN_WIDTH-120, 40)];
        nameLabel.text = _model.name;
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.textColor = TitleColor;
        [topView addSubview:nameLabel];
        
        UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 190, G_SCREEN_WIDTH-30, _headerHeight)];
        introLabel.numberOfLines = 0;
        introLabel.text = _model.intro;
        introLabel.textColor = TextColor;
        introLabel.font = [UIFont systemFontOfSize:12];
        [topView addSubview:introLabel];
        return view;
    }
    else
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *views in view.subviews)
        {
            [views removeFromSuperview];
        }
        
        
        [view addSubview:_rankView];
        return view;
        
    }
}


- (void)rankBtnViewWithParam:(NSDictionary *)dic
{
    
    [_param setValuesForKeysWithDictionary:dic];
    
    [self getActivityProductsWithPage:1];
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
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








#pragma mark - 获取数据
- (void)getActivityProductsWithPage:(NSInteger)page
{
    
    MJWeakSelf;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    [_param setObject:[NSString stringWithFormat:@"%li",(long)page] forKey:@"pageNumber"];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
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
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
            [self->_dataArray addObjectsFromArray:list.products];
            
        }
        else
        {
            if (weakSelf.isRefresh)
            {
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            else [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [hud hideAnimated:YES];
        
        [UIView performWithoutAnimation:^{
            [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }];
      
        
        
        
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
