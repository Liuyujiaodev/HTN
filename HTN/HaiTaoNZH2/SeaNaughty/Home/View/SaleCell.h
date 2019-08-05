//
//  SaleCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/30.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface SaleCell : UITableViewCell

@property (nonatomic, strong) ProductModel *data;
@property (nonatomic, assign) NSTimeInterval saleEndTimeSecond;

@end
