//
//  BaseVC.m
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseVC.h"
#import "SearchViewController.h"
#import "NavSearchBar.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "ScanViewController.h"
#import "ChatListVC.h"
#import "UIButton+Badge.h"
#import "UIBarButtonItem+Badge.h"

#import <Masonry.h>

@interface BaseVC () <UISearchBarDelegate>

@property (nonatomic, strong) NavSearchBar *searchBar;
@property (nonatomic, strong) SearchViewController *searchVC;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) UIBarButtonItem *serviceItem;

@property (nonatomic, strong) UILabel* badgeLabel;

@end

@implementation BaseVC

-(UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.text = @"0";
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.font = [UIFont systemFontOfSize:9];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.layer.cornerRadius = 8;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.hidden = YES;
    }return _badgeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"nav-saoyisao"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(scanCode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [rightBtn setImage:[UIImage imageNamed:@"new-cart"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(goToShopCar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 25, 25)];
    [serviceBtn setImage:[UIImage imageNamed:@"消息"] forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(goToChatList) forControlEvents:UIControlEventTouchUpInside];
    
    [serviceBtn addSubview:self.badgeLabel];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(serviceBtn.mas_right);
        make.centerY.equalTo(serviceBtn.mas_top);
        make.width.height.offset(16);
    }];
    
    
    _serviceItem = [[UIBarButtonItem alloc] initWithCustomView:serviceBtn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    [self.navigationItem setRightBarButtonItems:@[_serviceItem,rightItem]];
    [self reloadCount];
    
    
    
    
    _searchBar = [[NavSearchBar alloc] initWithFrame:CGRectMake(0, 5, G_SCREEN_WIDTH-120-20, 34)];
    _searchBar.placeholder = @"大家都在搜";
    
    _searchBar.delegate = self;
    _searchBar.contentInset = UIEdgeInsetsMake(3, 0, 3, 0);
    
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    searchField.layer.cornerRadius = 13;
    searchField.layer.masksToBounds = YES;
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 0, G_SCREEN_WIDTH-120, 44)];
    [view addSubview:_searchBar];
    self.navigationItem.titleView = view;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCount) name:@"reloadCount" object:nil];
    
}

- (void)reloadCount
{
    NSInteger all = [[NSUserDefaults standardUserDefaults] integerForKey:@"allUnreadCount"];
    
    if (all>0 && all<=9) {
        self.badgeLabel.text = [NSString stringWithFormat:@"%li",(long)all];
        self.badgeLabel.hidden = NO;
        
    } else if (all > 9) {
        self.badgeLabel.text = [NSString stringWithFormat:@"9+"];
        self.badgeLabel.hidden = NO;
        
    } else {
        self.badgeLabel.text = @"0";
        self.badgeLabel.hidden = YES;
        
    }
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    if (_searchText && _searchText.length > 0)
    {
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        searchField.text = _searchText;
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    BOOL haveSearch = NO;
    
//    for (UIViewController *vc in self.navigationController.viewControllers)
//    {
//        if ([vc isKindOfClass:[SearchViewController class]])
//        {
//            haveSearch = YES;
//            [self.navigationController popToViewController:vc animated:NO];
//        }
//    }
    
    if (!haveSearch)
    {
        SearchViewController *vc = [[SearchViewController alloc] init];
        vc.searchText = self.searchText;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    return NO;
}

- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView
{
    return 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)setLeftBackBtn:(BOOL)leftBackBtn
{
    _leftBackBtn = leftBackBtn;
    if (_leftBackBtn)
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
        [leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
}

- (void)goToShopCar
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tabbar.selectedIndex = 2;
}

- (void)goToChatList
{
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        ChatListVC *vc = [[ChatListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)scanCode
{
    ScanViewController *vc = [[ScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)backBtnClick
//{
//    if (self.isFromMessage)
//    {
//        if (self.navigationController.viewControllers.count > 1)
//        {
//            for (UIViewController *vc in self.navigationController.viewControllers)
//            {
//                if ([vc isKindOfClass:[ActivityMsgListVC class]] || [vc isKindOfClass:[PushListVC class]])
//                {
//                    [self.navigationController popToViewController:vc animated:YES];
//                }
//            }
//        }
//        return;
//    }
//    if (self.navigationController.viewControllers.count>0)
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
