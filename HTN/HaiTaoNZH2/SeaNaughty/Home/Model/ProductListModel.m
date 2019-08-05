//
//  ProductListModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProductListModel.h"

@implementation ProductListModel



+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"products" : [ProductModel class],
             @"rows" : [ProductModel class],
             @"data" : [ProductModel class] };

}

@end
