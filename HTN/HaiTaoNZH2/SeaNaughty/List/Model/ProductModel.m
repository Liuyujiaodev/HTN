//
//  ProductModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
        @"productId":@"id"
        };
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ProductModel class]};
}

@end
