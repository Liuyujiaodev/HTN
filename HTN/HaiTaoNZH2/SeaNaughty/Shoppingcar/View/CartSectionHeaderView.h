//
//  CartSectionHeaderView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

typedef void(^CartModelBlock)(CartModel *modelBlock);

@interface CartSectionHeaderView : UIView

@property (nonatomic, strong) CartModel *model;
@property (nonatomic,copy) CartModelBlock block;

@property(nonatomic,weak) UIViewController* superSelf;

- (instancetype)init;

- (void)handlerButtonAction:(CartModelBlock)block;

@end
