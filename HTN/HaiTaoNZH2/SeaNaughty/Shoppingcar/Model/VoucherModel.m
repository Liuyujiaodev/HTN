//
//  VoucherModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "VoucherModel.h"

@implementation VoucherModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"voucherId":@"id",
             @"descriptionString":@"description"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [VoucherModel class]};
}

-(BOOL)isEqualToModel:(VoucherModel *)model{
    if (!model) {
        return NO;
    }
    
    BOOL haveEqualVoucherId = (!self.voucherBookId && !model.voucherBookId) || self.voucherBookId == model.voucherBookId;
    
    return haveEqualVoucherId;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {//对象本身
        return YES;
    }
    
    if (![object isKindOfClass:[VoucherModel class]]) {//不是本类
        return NO;
    }
    
    return [self isEqualToModel:(VoucherModel *)object];//必须全部属性相同 但是在实际开发中关键属性相同就可以
}

- (NSUInteger)hash {//hash比较 如果对象的属性是NSString等的对象 则需要用 ^运算逻辑异或
    return [self hash];
}

@end
