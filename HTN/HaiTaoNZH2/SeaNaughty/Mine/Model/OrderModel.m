//
//  OrderModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"orderId":@"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"products" : [ProductModel class]};
}


@end
