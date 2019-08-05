//
//  ProductDetailCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/7.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface ProductDetailCell : UITableViewCell

@property (nonatomic, strong) ProductModel *model;
@property (nonatomic, assign) BOOL hiddenOriginPrice;

@end
