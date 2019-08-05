//
//  ShopListModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/23.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ShopListModel.h"


@implementation ShopListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ShopModel class]};
}

@end
