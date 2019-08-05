//
//  PayViewController.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"

@interface PayViewController : BaseRootVC

@property (nonatomic, strong) NSArray *ordersArray;
@property (nonatomic, strong) NSString *totalFee;
@property (nonatomic, strong) NSArray *idArray;
@property (nonatomic, strong) NSString *firstTotalAmount;
@property (nonatomic, strong) NSString *secondTotalAmount;
@property (nonatomic, assign) BOOL isFromShop;


@end
