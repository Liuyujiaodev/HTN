//
//  ListViewController.m
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ListViewController.h"
#import "LeftTableView.h"
#import "CategoryListModel.h"
#import "RightTableView.h"
#import "ShopListModel.h"
#import "ProductListModel.h"

#import "ListChildrenView.h"
#import "RankBtnView.h"
#import "RightCell.h"

#import "ListNextViewController.h"
#import "ProductDetailViewController.h"
#import "ListShopViewController.h"
#import "TagView.h"


#define RIGHTWIDTH (G_SCREEN_WIDTH-80)

@interface ListViewController () <LeftTableViewDelegate, UITableViewDelegate, UITableViewDataSource, ListChildrenViewDelegate,RankBtnViewDelegate,RightCellDelegate>

@property (nonatomic, strong) LeftTableView *leftTableView;
//@property (nonatomic, strong) RightTableView *rightTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) NSArray *shopList;
@property (nonatomic, assign) BOOL fistIn;

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, strong) ListChildrenView *listChildrenView;

@property (nonatomic, strong) ListChildrenView *shopChildrenView;

@property (nonatomic, strong) RankBtnView *rankBtn;
@property (nonatomic, strong) CategoryModel *category;

@property (nonatomic, assign) int page;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic, strong) CategoryModel *tempCategory;
@property (nonatomic, assign) BOOL showSpecialSale;
@property (nonatomic, strong) NSDictionary *tempDic;
@property (nonatomic, strong) CategoryListModel *categoryList;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _param = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetModel:) name:@"LeftTabelViewModel" object:nil];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reladData) name:@"NeedReload" object:nil];
    
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _showSpecialSale = NO;
    
    MJWeakSelf;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getCategoriesSuccess:^(BOOL isFinish) {
        dispatch_group_leave(group);
    }];
   
    _leftTableView = [[LeftTableView alloc] initWithFrame:CGRectMake(0, 0, 80, G_SCREEN_HEIGHT)];
    _leftTableView.leftTableViewDelegate = self;
    [self.view addSubview:_leftTableView];
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:SHOPLIST];
    
    if (dic.allKeys.count != 0)
    {
        ShopListModel *listModel = [ShopListModel yy_modelWithDictionary:dic];
        _shopList = listModel.data;
    }
    else
    {
        [self getShopList];
    }
    
 
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self initUI];
        if (weakSelf.selecteItem)
        {
            [weakSelf.leftTableView selectedWithName:weakSelf.selecteItem];
        }
        else
        {
            weakSelf.category = [[CategoryModel alloc] init];
            weakSelf.category.name = @"全球仓库";
            [weakSelf.leftTableView selectedWithName:@"全球仓库"];
        }
        
    });

  
}

- (void)reladData
{
    [self.leftTableView selectedWithName:@"全球仓库"];
    self.category.name = @"全球仓库";
    [self getProductListWithPage:1];
}

- (void)viewWillAppear:(BOOL)animated
{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:<#(BOOL)#>]
}


- (void)initUI
{
    MJWeakSelf;
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(80, 0, G_SCREEN_WIDTH-80, G_SCREEN_HEIGHT-G_TABBAR_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_rightTableView];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHTWIDTH, RIGHTWIDTH/3+20)];
    topView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, RIGHTWIDTH-30, RIGHTWIDTH/3-10)];
    imageView.image = [UIImage imageNamed:@"全球仓库"];
    [topView addSubview:imageView];
    _rightTableView.tableHeaderView = topView;
    [_rightTableView registerClass:[RightCell class] forCellReuseIdentifier:@"RightCell"];
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf getProductListWithPage:weakSelf.page];
    }];
    
    [_footer setTitle:@"小主，没有更多了哦" forState:MJRefreshStateNoMoreData];
    _rightTableView.mj_footer = _footer;
    _rightTableView.mj_footer.automaticallyHidden = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, G_SCREEN_HEIGHT)];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0)
    {
        ProductModel *model = _dataArray[indexPath.row];

        CGFloat width = G_SCREEN_WIDTH-80;
        CGFloat logoWidth = width*0.3;

        TagView *tagview = [[TagView alloc] initWithFrame:CGRectMake(0, 0, width-logoWidth-10, 20)];
        tagview.arr = model.tagsArray;
        
        NSString *name = model.name;
        CGFloat height = [name boundingRectWithSize:CGSizeMake(width-logoWidth-25, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+2;
        
        if ([model.firstOriginalPrice floatValue] > 0)
        {
            height = height + 25;
        }
        else
            height = height + 15;
        
        
        return height+25+tagview.bounds.size.height+18;
    }
    
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    self.rankBtn.dictionary = _tempDic;
    return self.rankBtn;
}

- (RankBtnView *)rankBtn
{
    if (!_rankBtn)
    {
        _rankBtn = [[RankBtnView alloc] initWithFrame:CGRectMake(0, 0, RIGHTWIDTH, 40)];
        _rankBtn.backgroundColor = [UIColor whiteColor];
        _rankBtn.showTopline = YES;
        _rankBtn.delegate = self;
    }
    return _rankBtn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell" forIndexPath:indexPath];
    cell.data = _dataArray[indexPath.row];
    cell.showSpecialSale = _showSpecialSale;
    cell.delegate = self;
    return cell;
}

- (void)rightCellAddProduct:(ProductModel *)model
{
    
    //商品详情需要登录的时候修改
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:model.productId forKey:@"productId"];
    [param setObject:model.shopId forKey:@"shopId"];
    [param setObject:@"1" forKey:@"quantity"];
    [param setObject:model.giftSale forKey:@"giftSale"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/add" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.label.text = @"添加成功!";
                [hud1 hideAnimated:YES afterDelay:1.2];
            });
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            [SVProgressHUD dismissWithDelay:1.2];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    ProductModel *model = _dataArray[indexPath.row];
    vc.productId = model.productId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rankBtnViewWithParam:(NSDictionary *)dic
{
    _tempDic = [[NSDictionary alloc] initWithDictionary:dic];
    [_param setValuesForKeysWithDictionary:dic];
    
    _page = 1;
    [self getProductListWithPage:_page];
}



- (void)setCategory:(CategoryModel *)category
{
    _category = category;

    NSLog(@"backImg = %@",_category.backImg);
    NSArray *array = @[@"好物推荐",@"特价专区",@"全球仓库"];



    if ([_category.name isEqualToString:@"全球仓库"])
    {
        NSMutableArray *shopArray = [[NSMutableArray alloc] init];

        NSMutableArray *childArray = [[NSMutableArray alloc] init];

        ShopModel *shopModel = [[ShopModel alloc] init];
        shopModel.name = @"所有仓库";
        shopModel.shopId = @"";
        [shopArray addObject:shopModel];
        [shopArray addObjectsFromArray:_shopList];

        NSArray *imageArray = @[@"shop-all",@"shop-icon0",@"shop-icon1",@"shop-icon2",@"shop-icon3",@"shop-icon4"];

        for (int i=0; i<6; i++)
        {
            ShopModel *shop = shopArray[i];
            ChildrenModel *model = [[ChildrenModel alloc] init];
            model.name = shop.name;
            model.childrenId = shop.shopId;
            model.backImg = imageArray[i];
            [childArray addObject:model];
        }

        _category.children = (NSArray <ChildrenModel *> *)childArray;

    }

    NSLog(@"zzzz  %lu", (unsigned long)_category.children.count);

    self.listChildrenView.model = _category;

    if ([array containsObject:_category.name])
    {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHTWIDTH, RIGHTWIDTH/3+10)];
        topView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, RIGHTWIDTH-30, RIGHTWIDTH/3-10)];
        imageView.image = [UIImage imageNamed:_category.name];
        [topView addSubview:imageView];

        if ([_category.name isEqualToString:@"全球仓库"])
        {
            self.shopChildrenView = [[ListChildrenView alloc] initWithFrame:CGRectMake(0, RIGHTWIDTH/3+10, RIGHTWIDTH, 100) dataArray:nil];
            self.shopChildrenView.childrenDelegate = self;
            self.shopChildrenView.model = _category;
            
            self.shopChildrenView.frame = CGRectMake(0, RIGHTWIDTH/3+10, RIGHTWIDTH, self.shopChildrenView.frame.size.height);

            topView.frame = CGRectMake(0, 0, RIGHTWIDTH, self.shopChildrenView.frame.size.height+RIGHTWIDTH/3+20);
            
            [topView addSubview:self.shopChildrenView];

            _rightTableView.tableHeaderView = topView;
        }
        else
        {
            topView.frame = CGRectMake(0, 0, RIGHTWIDTH, RIGHTWIDTH/3+10);
            _rightTableView.tableHeaderView = topView;
        }

    }
    else
    {
        if (_category.children.count>0)
        {
            _rightTableView.tableHeaderView = self.listChildrenView;
        }
        else
        {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RIGHTWIDTH, 1)];
            header.backgroundColor = [UIColor yellowColor];
            _rightTableView.tableHeaderView = header;
        }
    }

    [_rightTableView reloadData];
}






- (ListChildrenView *)listChildrenView
{
    if (!_listChildrenView)
    {
        _listChildrenView = [[ListChildrenView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH-80, 100) dataArray:nil];
        _listChildrenView.childrenDelegate = self;
    }
    return _listChildrenView;
}


- (void)listChildrenViewDidClickedModel:(ChildrenModel *)model andCategoryModel:(CategoryModel *)category
{
    
    if (!category.categoryID)
    {
        
        ListShopViewController *vc = [[ListShopViewController alloc] init];
        vc.shopId = model.childrenId;
        vc.categoryList = self.categoryList;
        
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    ListNextViewController *vc = [[ListNextViewController alloc] init];
    
    vc.category = category;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)setSelecteItem:(NSString *)selecteItem
{
    _selecteItem = selecteItem;
    
    [_leftTableView selectedWithName:selecteItem];
    
}

- (void)getCategoriesSuccess:(void(^)(BOOL isFinish))requestFinish
{
    
    __weak typeof(self) weakSelf = self;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/categories/pc" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        CategoryListModel *list = [CategoryListModel yy_modelWithDictionary:result];
        
        weakSelf.categoryList = list;
        
        [weakSelf.leftTableView updateCategories:list];
        
        requestFinish(YES);
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getShopList
{
    __weak typeof(self) weakSelf = self;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/shops" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        [[NSUserDefaults standardUserDefaults] setValue:result forKey:SHOPLIST];
    
        
        ShopListModel *listModel = [ShopListModel yy_modelWithDictionary:result];
        weakSelf.shopList = listModel.data;
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - LeftTableViewDelegate
- (void)leftTableView:(LeftTableView *)tableView didSelectCategoryName:(CategoryModel *)model
{
    self.category = model;
    

    if (![_tempCategory.name isEqualToString:self.category.name])
    {
        [_dataArray removeAllObjects];
        [_rightTableView reloadData];
        _page = 1;
        _rightTableView.mj_footer = nil;
        [self getProductListWithPage:1];
    }
    
    
}


- (void)resetModel:(NSNotification *)notification
{

    CategoryModel *model = notification.object;
    self.category = model;
    
    if (![_tempCategory.name isEqualToString:self.category.name])
    {
        [_dataArray removeAllObjects];
        [_rightTableView reloadData];
        _page = 1;
        [self getProductListWithPage:1];
    }
}

- (void)getProductListWithPage:(int)page
{
    MJWeakSelf;
    
    _showSpecialSale = YES;;
    
    if ([self.category.name isEqualToString:@"好物推荐"])
    {
        _showSpecialSale = NO;
        [_param setObject:@"74" forKey:@"activityId"];
        [_param setObject:@"" forKey:@"activityRule"];
        [_param setObject:@"" forKey:@"mainCategoryId"];
    }
    else if ([self.category.name isEqualToString:@"特价专区"])
    {
        [_param setObject:@"24" forKey:@"activityId"];
        [_param setObject:@"4" forKey:@"activityRule"];
        [_param setObject:@"" forKey:@"mainCategoryId"];
    }
    else if (self.category.categoryID)
    {
        [_param setObject:@"" forKey:@"activityId"];
        [_param setObject:@"" forKey:@"activityRule"];
        [_param setObject:self.category.categoryID forKey:@"mainCategoryId"];
    }
    else
    {
        [_param setObject:@"" forKey:@"activityId"];
        [_param setObject:@"" forKey:@"activityRule"];
        [_param setObject:@"" forKey:@"mainCategoryId"];
    }
    _tempCategory = self.category;
    
    [_param setObject:[NSString stringWithFormat:@"%i",page] forKey:@"pageNumber"];
    [_param setObject:@"60" forKey:@"pageSize"];
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    loadingHud.label.text = @"正在加载";
    [loadingHud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/products" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        [loadingHud hideAnimated:YES];
        if (page == 1)
        {
            weakSelf.rightTableView.mj_footer = nil;
            [_dataArray removeAllObjects];
        }
        ProductListModel *list = [ProductListModel yy_modelWithDictionary:result[@"data"]];
        
        if (list.products.count>0)
        {
            for (ProductModel *model in list.products)
            {
                NSMutableArray *tagArray = [[NSMutableArray alloc] init];
                
                if ([model.tags isKindOfClass:[NSArray class]])
                {
                     tagArray = [NSMutableArray arrayWithArray:model.tags];
                }
               
                
                if ([model.giftSale isEqualToString:@"1"])
                {
                    NSString *str = [NSString stringWithFormat:@"换购"];
                    [tagArray addObject:str];
                }
                
                if (model.zeroShippingFeeQty.length > 0)
                {
                    NSString *str;
                    if ([model.shopId isEqualToString:@"4"])
                    {
                        str = [NSString stringWithFormat:@"%@件包邮闪电发货",model.zeroShippingFeeQty];
                    }
                    else
                    {
                        str = [NSString stringWithFormat:@"%@件包邮",model.zeroShippingFeeQty];
                    }
                    if(![model.zeroShippingFeeQty isEqualToString:@"0"]){
                        [tagArray addObject:str];
                    }
                    
                }
                
                if (model.limitedQty.length > 0)
                {
                    NSString *str = [NSString stringWithFormat:@"限购%@件", model.limitedQty];
                    [tagArray addObject:str];
                }
                
                
                NSDictionary *freePostage = model.freePostage;
                
                if (freePostage.allKeys.count > 0)
                {
                    NSString *freePos = [NSString stringWithFormat:@"满%@%@/%@ %@包邮",freePostage[@"firstCurrencyName"],freePostage[@"firstThreshold"],freePostage[@"secondCurrencyName"],freePostage[@"secondThreshold"]];
                    [tagArray addObject:freePos];
                }
                
                
//                NSString *tagsString = [tagArray componentsJoinedByString:@","];
                
                NSString *tagsString = [tagArray componentsJoinedByString:@",,,,"];
                
                CGFloat width = G_SCREEN_WIDTH-80;
                CGFloat logoWidth = width*0.3;
                
                CGFloat height = [tagsString boundingRectWithSize:CGSizeMake(width-logoWidth-15, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height;
                
                NSLog(@"height = %f", height);
                
                model.tagsArray = tagArray;
                
            }
            
            [weakSelf.dataArray addObjectsFromArray:list.products];
//            weakSelf.rightTableView.mj_footer = _footer;
            [weakSelf.rightTableView reloadData];
            [weakSelf.rightTableView.mj_header endRefreshing];
            [weakSelf.rightTableView.mj_footer endRefreshing];
        }
        else
        {
            
            if (weakSelf.page == 1)
            {
                [weakSelf.rightTableView reloadData];
                [weakSelf.rightTableView.mj_header endRefreshing];
            }
            else
            {
                [weakSelf.rightTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
//
//        [UIView performWithoutAnimation:^{
//            [weakSelf.rightTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//        }];
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
