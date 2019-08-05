//
//  CommonModelList.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/30.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CommonModelList.h"

@implementation CommonModelList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rows" : [CommonModel class],
             @"data" : [CommonModel class],
             @"products" : [CommonModel class]
             };
}


@end
