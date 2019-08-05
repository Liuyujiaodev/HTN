//
//  BaseRootVC.m
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"
#import "ActivityMsgListVC.h"
#import "PushListVC.h"
#import "HomeViewController.h"


@interface BaseRootVC () <UIGestureRecognizerDelegate>

@end

@implementation BaseRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.viewControllers.count>1)
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
        [leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
//    self.navigationController.transitioningDelegate = self;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)backBtnClick
{
    
    if (_isFromMessage)
    {
        if (self.navigationController.viewControllers.count > 1)
        {
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if ([vc isKindOfClass:[ActivityMsgListVC class]] || [vc isKindOfClass:[PushListVC class]] || [vc isKindOfClass:[HomeViewController class]])
                {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }
        return;
    }
    
    if (self.navigationController.viewControllers.count>1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
//    
//    if (self.isFromMessage)
//    {
//        return NO;
//    }
//    
//    if (self.navigationController.viewControllers.count>1)
//    {
//        return YES;
//    }
//    
//    return NO;
//}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//    
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}

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
