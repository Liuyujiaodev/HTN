//
//  OrderDetailViewController.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/15.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"

@interface OrderDetailViewController : BaseRootVC

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, assign) BOOL miandan;
@property (nonatomic, assign) BOOL fromPush;

@end
