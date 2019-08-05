//
//  VoucherListModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "VoucherListModel.h"

@implementation VoucherListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [VoucherModel class]};
}

@end
