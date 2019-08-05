//
//  CartModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VoucherModel.h"
#import "ProductModel.h"
#import "CYHShopFullProduModel.h"

@interface CartModel : NSObject

@property (nonatomic, strong) NSString *checked;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSDictionary *common;
@property (nonatomic, strong) NSDictionary *shippingFeeDescription;
@property (nonatomic, strong) NSMutableArray  *orderItems;
@property (nonatomic, strong) NSArray <VoucherModel *> *voucher;
@property (nonatomic, strong) NSString *voucherCount;
@property (nonatomic, strong) NSDictionary *freePostage;
@property (nonatomic, strong) NSString *discountType;
@property (nonatomic, strong) NSArray *giftProducts;
@property (nonatomic, strong) NSString *firstCurrencyName;
@property (nonatomic, strong) NSString *secondCurrencyName;
@property (nonatomic, strong) NSString *postageName;
@property (nonatomic, strong) NSString *memo;

//购物车满减活动列表用到
@property (nonatomic, strong) NSMutableArray* shopFullOffs;
@property (nonatomic, strong) NSMutableArray* shopFullProducts;


//chargeTotalWeight = 1500;
//firstFixedTotalFee = 0;
//firstNormalTotalFee = "5.98";
//fixedTotalWeight = 0;
//freeTotalWeight = 0;
//normalTotalWeight = 1500;
//orderTotalWeight = 1500;
//secondFixedTotalFee = 0;
//secondNormalTotalFee = "28.93";

@property (nonatomic, strong) NSString *chargeTotalWeight;
@property (nonatomic, strong) NSString *firstFixedTotalFee;
@property (nonatomic, strong) NSString *firstNormalTotalFee;
@property (nonatomic, strong) NSString *fixedTotalWeight;
@property (nonatomic, strong) NSString *freeTotalWeight;
@property (nonatomic, strong) NSString *normalTotalWeight;
@property (nonatomic, strong) NSString *orderTotalWeight;
@property (nonatomic, strong) NSString *secondFixedTotalFee;
@property (nonatomic, strong) NSString *secondNormalTotalFee;

@property (nonatomic, strong) NSString *firstGiftThreshold;
@property (nonatomic, assign) BOOL canGiftSale;

@property (nonatomic, assign) CGFloat needMoney;

@end
