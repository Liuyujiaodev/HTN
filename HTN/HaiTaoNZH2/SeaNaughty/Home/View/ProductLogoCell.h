//
//  ProductLogoCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/7.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface ProductLogoCell : UITableViewCell

@property (nonatomic, strong) ProductModel *model;
@property (nonatomic, assign) NSTimeInterval saleEndTimeSecond;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isSale;

@end
