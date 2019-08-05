//
//  OrderBottomCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"
#import "TotalFeeView.h"

@interface OrderBottomCell : UITableViewCell

@property (nonatomic, strong) CartModel *model;
@property (nonatomic, strong) TotalFeeView *feeView;
@property (nonatomic, strong) UITextField *memoText;
@end
