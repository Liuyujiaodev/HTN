//
//  CartAllModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CartAllModel.h"

@implementation CartAllModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"detail" : [CartModel class],
             @"couriers" : [CouriersModel class]
             };
}



@end
