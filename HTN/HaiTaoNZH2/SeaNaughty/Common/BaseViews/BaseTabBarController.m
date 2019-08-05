//
//  BaseTabBarController.m
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseTabBarController.h"




@interface BaseTabBarController ()



@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViewController];
    [self createTabbarItem];
}

- (void)createViewController
{
    _home = [[BaseNavigationVC alloc] init];
    _home.viewControllers = @[[[HomeViewController alloc] init]];
    
    _list = [[BaseNavigationVC alloc] init];
    _list.viewControllers = @[[[ListViewController alloc] init]];
    
    _shop = [[BaseNavigationVC alloc] init];
    _shop.viewControllers = @[[[ShoppingCarViewController alloc] init]];
    
    _mine = [[BaseNavigationVC alloc] init];
    _mine.viewControllers = @[[[MineViewController alloc] init]];
    
    self.viewControllers = @[_home,_list,_shop,_mine];
    
}

- (void)createTabbarItem
{
    for (int i = 0; i<self.viewControllers.count; i++)
    {
        BaseNavigationVC *nav = self.viewControllers[i];
        if (nav == _home) {
            [self createTabBarItemWithTitle:@"首页" withUnSelectedImage:@"icon-shouye-n" withSelectedImage:@"icon-shouye-h" withTag:i];
        }
        else if (nav == _list)
        {
            [self createTabBarItemWithTitle:@"分类" withUnSelectedImage:@"icon-fenlei-n" withSelectedImage:@"icon-fenlei-h" withTag:i];
        }
        else if (nav == _shop)
        {
            [self createTabBarItemWithTitle:@"购物车" withUnSelectedImage:@"icon-gouwuche-n" withSelectedImage:@"icon-gouwuche-h" withTag:i];
        }
        else if (nav == _mine)
        {
            [self createTabBarItemWithTitle:@"个人" withUnSelectedImage:@"icon-geren-n" withSelectedImage:@"icon-geren-h" withTag:i];
        }
    }
}





-(void)createTabBarItemWithTitle:(NSString *)title withUnSelectedImage:(NSString *)unSelectedImage withSelectedImage:(NSString *)selectedImage withTag:(NSInteger)tag
{
    UIImage *image1_0 = [[UIImage imageNamed:unSelectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image1_1 = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    (void)[[self.tabBar.items objectAtIndex:tag] initWithTitle:title image:image1_0 selectedImage:image1_1];
    
    [[self.tabBar.items objectAtIndex:tag] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                   MainColor, NSForegroundColorAttributeName,
                                                                   nil] forState:UIControlStateSelected];
    
}



@end
