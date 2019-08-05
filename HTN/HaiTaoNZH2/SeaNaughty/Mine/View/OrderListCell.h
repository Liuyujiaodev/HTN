//
//  OrderListCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/8.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^OrderListCellBlock)(OrderModel *blockModel);

@interface OrderListCell : UITableViewCell

@property (nonatomic, copy) OrderListCellBlock block;
@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, strong) UIViewController *fatherVC;

- (void)handlerButtonAction:(OrderListCellBlock)block;


@end
