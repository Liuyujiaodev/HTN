//
//  CouriersModel.h
//  SeaNaughty
//
//  Created by 娇 on 2019/8/2.
//  Copyright © 2019 chilezzz. All rights reserved.
// 快递的model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouriersModel : NSObject
@property (nonatomic, strong) NSString *additionalPerKg;
@property (nonatomic, strong) NSString *chargeAsPerKilo;
@property (nonatomic, strong) NSString *costPerKg;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *currencyId;
@property (nonatomic, assign) NSInteger couriersId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *price;

@end

NS_ASSUME_NONNULL_END
