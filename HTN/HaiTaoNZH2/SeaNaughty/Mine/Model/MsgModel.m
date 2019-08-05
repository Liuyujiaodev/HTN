//
//  MsgModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/30.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "MsgModel.h"

@implementation MsgModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"msgId":@"id"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rows" : [MsgModel class]};
}

@end
