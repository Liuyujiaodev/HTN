//
//  SearchViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "SearchViewController.h"
#import "NavSearchBar.h"
#import "ShopListModel.h"
#import "ListShopViewController.h"
#import "HomeViewController.h"
#import "ListViewController.h"


@interface SearchViewController () <UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NavSearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UIView *shopView;
@property (nonatomic, strong) UIView *hotView;
@property (nonatomic, strong) UIView *historyView;
@property (nonatomic, assign) CGFloat shopHeight;
@property (nonatomic, assign) CGFloat hotViewHeight;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSArray *shopArray;
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _searchArray = [[NSMutableArray alloc] init];
    _historyArray = [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
    
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"SEARCHHISTORY"])
    {
        NSArray *array = [[NSUserDefaults standardUserDefaults] valueForKey:@"SEARCHHISTORY"];
        
        [_historyArray addObjectsFromArray:array];
        if ([_historyArray containsObject:@""])
        {
            [_historyArray removeObject:@""];
        }
    }
    
    [self getSearchAutoComplete];
    [self initUI];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(searchBecomeActive) withObject:nil afterDelay:0.1];

}

- (void)searchBecomeActive
{
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    [searchField becomeFirstResponder];
}

- (void)initUI
{
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [rightBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(popVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    _searchBar = [[NavSearchBar alloc] initWithFrame:CGRectMake(0, 5, G_SCREEN_WIDTH-120, 34)];
    _searchBar.placeholder = @"大家都在搜";
    _searchBar.delegate = self;
    _searchBar.contentInset = UIEdgeInsetsMake(3, 0, 3, 0);
    
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    searchField.layer.cornerRadius = 13;
    searchField.layer.masksToBounds = YES;
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];

    
    _searchBar.text = self.searchText;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 0, G_SCREEN_WIDTH-120, 44)];
    [view addSubview:_searchBar];
    self.navigationItem.titleView = view;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, G_NAV_HEIGHT, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-G_NAV_HEIGHT)];
    _scrollView.contentSize = CGSizeMake(G_SCREEN_WIDTH, G_SCREEN_HEIGHT-G_NAV_HEIGHT);
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    
    UIImageView *shopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 12, 12)];
    shopImageView.image = [UIImage imageNamed:@"仓库筛选"];
    [_scrollView addSubview:shopImageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 13, 100, 16)];
    label.text = @"仓库筛选";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = LightGrayColor;
    [_scrollView addSubview:label];
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:SHOPLIST];
    MJWeakSelf;
    ShopListModel *listModel = [ShopListModel yy_modelWithDictionary:dic];
    _shopArray = listModel.data;
    
    _tempArray = [[NSMutableArray alloc] init];;
    
    [_shopArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ShopModel *model = obj;
        [weakSelf.tempArray addObject:model.name];
    }];
    
    _shopView = [self buttonWithArray:_tempArray top:32 selectType:YES];
    
    _shopHeight = _shopView.frame.size.height+38;
    
    [_scrollView addSubview:_shopView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _shopHeight, G_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = LineColor;
    [_scrollView addSubview:lineView];
    
    UIImageView *hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _shopHeight+15, 12, 12)];
    hotImageView.image = [UIImage imageNamed:@"hot-icon"];
    [_scrollView addSubview:hotImageView];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, _shopHeight+13, 100, 16)];
    label1.text = @"热门筛选";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = LightGrayColor;
    [_scrollView addSubview:label1];
    
}

- (void)popVC
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)backClick
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[HomeViewController class]] || [vc isKindOfClass:[ListViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getSearchAutoComplete
{
    MJWeakSelf;
    _searchArray = [[NSMutableArray alloc] init];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/search/autoComplete" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
            NSArray *array = result[@"data"];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                [weakSelf.searchArray addObject:dic[@"keyword"]];
            }];
            
            weakSelf.hotView = [weakSelf buttonWithArray:weakSelf.searchArray top:weakSelf.shopHeight+35 selectType:NO];
            
            weakSelf.hotViewHeight = weakSelf.hotView.frame.size.height+weakSelf.shopHeight+40;
            
            [weakSelf.scrollView addSubview:weakSelf.hotView];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, weakSelf.hotViewHeight, G_SCREEN_WIDTH, 1)];
            lineView.backgroundColor = LineColor;
            [weakSelf.scrollView addSubview:lineView];
            
            [weakSelf addHistoryView];
            
         
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)addHistoryView
{
    UIImageView *hotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _hotViewHeight+15, 12, 12)];
    hotImageView.image = [UIImage imageNamed:@"历史"];
    [self.scrollView addSubview:hotImageView];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(35, _hotViewHeight+13, 100, 16)];
    label1.text = @"历史搜索";
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = LightGrayColor;
    [self.scrollView addSubview:label1];
    
    _historyView = [self buttonWithArray:_historyArray top:_hotViewHeight+32 selectType:NO];
    
    [self.scrollView addSubview:_historyView];
    
    self.scrollView.contentSize = CGSizeMake(G_SCREEN_WIDTH, _historyView.frame.size.height+_hotViewHeight+50);
    
}


- (void)searchAction:(UIButton *)btn
{
    NSString *searchString = btn.titleLabel.text;
    
    if ([searchString isEqualToString:@"搜索"])
    {
        searchString = _searchBar.text;
    }
    
    
    if (![_historyArray containsObject:_searchBar.text])
    {
        [_historyArray insertObject:_searchBar.text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:_historyArray forKey:@"SEARCHHISTORY"];
    }
    
    ListShopViewController *vc = [[ListShopViewController alloc] init];
    
    
    vc.searchString = searchString;
    if (_selectArray.count > 0)
    {
        vc.shopArray = _selectArray;
    }

     [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    
    if (![_historyArray containsObject:_searchBar.text])
    {
        [_historyArray insertObject:_searchBar.text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:_historyArray forKey:@"SEARCHHISTORY"];
    }
    
    ListShopViewController *vc = [[ListShopViewController alloc] init];
    if (_selectArray.count > 0)
    {
        vc.shopArray = _selectArray;
    }
    vc.searchString = searchBar.text;
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIView *)buttonWithArray:(NSArray *)array top:(CGFloat)top selectType:(BOOL)isShop
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, top, G_SCREEN_WIDTH, 100)];
    
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    
    CGFloat h = 5;//用来控制button距离父视图的高
    
    CGFloat lastBtnY = 0;
    
    for (int i = 0; i < array.count; i++)
    {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor colorFromHexString:@"#F2F2F2"];
        
        button.layer.cornerRadius = 13.0f;
        [button setTitleColor:TextColor forState:UIControlStateNormal];
        
        if (isShop)
        {
            button.tag = 100+i;
            [button addTarget:self action:@selector(shopAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:MainColor forState:UIControlStateSelected];
        }
        else
        {
            button.tag = 1000+i;
            [button addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.titleLabel.font=[UIFont systemFontOfSize:11];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button sizeToFit];
        
        CGFloat length = button.frame.size.width;
        
        button.frame = CGRectMake(10 + w, h, length + 25 , 25);
        if(10 + w + length + 25 > G_SCREEN_WIDTH)
        {
            w = 0; //换行时将w置为0
            
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 25, 25);//重设button的frame
            
        }
        
        if (length + 30 > G_SCREEN_WIDTH - 20)
        {
            button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, G_SCREEN_WIDTH - 20, 25);
        }
        
        w = button.frame.size.width + button.frame.origin.x;
        if (i==array.count-1)
        {
            lastBtnY=button.frame.origin.y;
        }
        [view addSubview:button];
        
        view.frame = CGRectMake(0, top, G_SCREEN_WIDTH, h+30);
        
    }
    
    return view;
}


- (void)shopAction:(UIButton *)btn
{
    NSInteger index = btn.tag - 100;
    btn.selected = !btn.selected;
    ShopModel *model = _shopArray[index];
    if (btn.selected && ![_selectArray containsObject:model.shopId])
    {
        [_selectArray addObject:model.shopId];
    }
    else if (!btn.selected && [_selectArray containsObject:model.shopId])
    {
        [_selectArray removeObject:model.shopId];
    }
}


@end
