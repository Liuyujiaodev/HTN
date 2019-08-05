//
//  CartAllModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartModel.h"
#import "ProductModel.h"
#import "CouriersModel.h"
@protocol CartModel

@end

@interface CartAllModel : NSObject

@property (nonatomic, strong) NSString *checkedAll;
@property (nonatomic, strong) NSString *checkedCount;
@property (nonatomic, strong) NSString *firstCurrencyName;
@property (nonatomic, strong) NSString *secondCurrencyName;
@property (nonatomic, strong) NSDictionary *common;
@property (nonatomic, strong) NSDictionary *shippingFeeDescription;
@property (nonatomic, strong) NSArray <CartModel *> *detail;
@property (nonatomic, strong) NSDictionary *shopFreeProducts;
@property (nonatomic, strong) NSString *shippingCourier;
@property (nonatomic, strong) NSArray <CouriersModel *> *couriers;


@end
