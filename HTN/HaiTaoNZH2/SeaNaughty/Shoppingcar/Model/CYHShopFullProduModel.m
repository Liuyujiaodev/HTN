//
//  CYHShopFullProduModel.m
//  SeaNaughty
//
//  Created by Apple on 2019/6/28.
//  Copyright © 2019年 chilezzz. All rights reserved.
//

#import "CYHShopFullProduModel.h"

@implementation CYHShopFullProduModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"shopFullID" : @"id",};
}

- (NSMutableArray<ProductModel *> *)orderItems {
    if (!_orderItems)
    {
        _orderItems = (NSMutableArray<ProductModel *> *)[[NSMutableArray alloc] init];
    }
    return _orderItems;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderItems" : [ProductModel class]
             };
}

@end
