//
//  PostageView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartAllModel.h"

@interface TotalFeeView : UIView

@property (nonatomic, strong) CartAllModel *model;
@property (nonatomic, strong) CartModel *cartModel;
@property (nonatomic, assign) BOOL zero;
@property (nonatomic, assign) BOOL isConfirm;

- (instancetype)init;

@end
