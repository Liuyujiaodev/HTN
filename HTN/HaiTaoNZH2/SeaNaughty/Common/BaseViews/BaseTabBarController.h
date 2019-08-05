//
//  BaseTabBarController.h
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationVC.h"
#import "HomeViewController.h"
#import "ListViewController.h"
#import "ShoppingCarViewController.h"
#import "MineViewController.h"

@interface BaseTabBarController : UITabBarController

@property (nonatomic, strong) BaseNavigationVC *home;

@property (nonatomic, strong) BaseNavigationVC *list;

@property (nonatomic, strong) BaseNavigationVC *shop;

@property (nonatomic, strong) BaseNavigationVC *mine;

@end
