//
//  RightCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/13.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@protocol RightCellDelegate <NSObject>

- (void)rightCellAddProduct:(ProductModel *)model;

@end

@interface RightCell : UITableViewCell

@property (nonatomic, strong) ProductModel *data;
@property (nonatomic, assign) BOOL showSpecialSale;
@property (nonatomic, weak) id <RightCellDelegate> delegate;

@end
