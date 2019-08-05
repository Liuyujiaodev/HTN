//
//  OrderListModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@protocol OrderModel

@end

@interface OrderListModel : NSObject

@property (nonatomic, strong) NSArray<OrderModel> *rows;

@end
