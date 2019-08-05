//
//  FeeCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"
#import "CouriersModel.h"

typedef void(^FeeCellBlock)(CartModel *model);

@interface FeeCell : UITableViewCell

@property (nonatomic, strong) CartModel *model;
@property (nonatomic, assign) BOOL showBtn;
@property (nonatomic, copy) FeeCellBlock block;
@property (nonatomic, strong) NSArray <CouriersModel *> *couriers;

- (void)feeCellHandleAction:(FeeCellBlock)block;

@end
