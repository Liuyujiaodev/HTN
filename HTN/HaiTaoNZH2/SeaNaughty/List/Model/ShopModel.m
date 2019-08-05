//
//  ShopModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/23.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, assign) NSInteger nzhIndex;
//@property (nonatomic, assign) NSInteger l2Index;
//@property (nonatomic, assign) NSInteger linkcIndex;
//@property (nonatomic, assign) NSInteger shopId;

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"shopId":@"id",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ShopModel class]};
}

@end
