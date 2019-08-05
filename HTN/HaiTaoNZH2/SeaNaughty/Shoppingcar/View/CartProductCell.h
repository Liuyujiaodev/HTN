//
//  CartProductCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

typedef void(^ProductModelBlock)(ProductModel *modelBlock);

@interface CartProductCell : UITableViewCell

@property (nonatomic, strong) ProductModel *model;
@property (nonatomic,copy) ProductModelBlock block;
@property (nonatomic, weak) UIViewController *superVC;

- (void)handlerButtonAction:(ProductModelBlock)block;

@end
