//
//  MoneyListModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/6.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "MoneyListModel.h"

@implementation MoneyListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"rows" : [MoneyModel class]};
}


@end
