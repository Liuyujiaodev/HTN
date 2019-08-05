//
//  ActivityModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"activityID":@"id"
             };
}

@end
