//
//  CategoryModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"categoryID":@"id"
             };
}

@end
