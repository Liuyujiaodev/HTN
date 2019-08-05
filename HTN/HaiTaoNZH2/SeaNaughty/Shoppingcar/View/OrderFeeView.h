//
//  OrderFeeView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartAllModel.h"

@interface OrderFeeView : UIView

@property (nonatomic, strong) CartAllModel *model;
@property (nonatomic, strong) CartModel *cartModel;

- (instancetype)init;

@end
