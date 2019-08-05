

//
//  BankListModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BankListModel.h"

@implementation BankListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [BankModel class]};
}


@end
