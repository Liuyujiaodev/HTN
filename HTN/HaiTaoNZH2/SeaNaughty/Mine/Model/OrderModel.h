//
//  OrderModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "ProductModel.h"

@interface OrderModel : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *customerComment;
@property (nonatomic, strong) NSString *creatorComment;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *shippingNumber;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *receiveName;
@property (nonatomic, strong) NSString *receivePhone;
@property (nonatomic, strong) NSString *receiveAddress;
@property (nonatomic, strong) NSString *receiveIdCard;
@property (nonatomic, strong) NSString *receiveProvince;
@property (nonatomic, strong) NSString *receiveCity;
@property (nonatomic, strong) NSString *receiveArea;
@property (nonatomic, strong) NSString *sendName;
@property (nonatomic, strong) NSString *sendPhone;
@property (nonatomic, strong) NSString *sendAddress;
@property (nonatomic, strong) NSString *payTime;
@property (nonatomic, strong) NSString *confirmTime;
@property (nonatomic, strong) NSString *shipTime;
@property (nonatomic, strong) NSString *shipImgUrl;
@property (nonatomic, strong) NSString *shipPhotoUrl;
@property (nonatomic, strong) NSString *shipVideoUrl;
@property (nonatomic, strong) NSString *processingShopId;
@property (nonatomic, strong) NSString *lottery;
@property (nonatomic, strong) NSString *courierName;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *courierCode;
@property (nonatomic, strong) NSString *firstAmount;
@property (nonatomic, strong) NSString *secondAmount;
@property (nonatomic, strong) NSString *firstGoodsAmount;
@property (nonatomic, strong) NSString *secondGoodsAmount;
@property (nonatomic, strong) NSString *firstPaymentDueAmount;
@property (nonatomic, strong) NSString *secondPaymentDueAmount;
@property (nonatomic, strong) NSString *firstCurrencyName;
@property (nonatomic, strong) NSString *secondCurrencyName;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *isPay;
@property (nonatomic, strong) NSString *paymentMethod;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *firstShippingFeeAmount;
@property (nonatomic, strong) NSString *secondShippingFeeAmount;
@property (nonatomic, strong) NSArray <ProductModel *>  *products;
@property (nonatomic, strong) NSString *firstDiscountAmount;
@property (nonatomic, strong) NSString *secondDiscountAmount;
@property (nonatomic, assign) BOOL orderSelected;
@property (nonatomic, strong) NSString *btnName;
@property (nonatomic, strong) NSNumber *totalAmount;


@end
