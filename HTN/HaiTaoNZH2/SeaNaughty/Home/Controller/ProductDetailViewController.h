//
//  ProductDetailViewController.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/6.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"
#import "ProductModel.h"

@interface ProductDetailViewController : BaseRootVC

@property (nonatomic, strong) NSString *productId;

@property (nonatomic, assign) BOOL isSale;

@end
