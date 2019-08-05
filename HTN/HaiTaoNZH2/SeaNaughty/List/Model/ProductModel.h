//
//  ProductModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreePostageModel.h"
#import "CartModel.h"

@protocol ProductModel
@end

@interface ProductModel : NSObject

@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *currencyId;
@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, assign) NSString *mainCategoryId;
@property (nonatomic, strong) NSString *subCategoryId;
@property (nonatomic, strong) NSString *validDate;
@property (nonatomic, strong) NSString *shippingFeeWay;
@property (nonatomic, strong) NSString *zeroShippingFeeQty;
@property (nonatomic, strong) NSString *limitedQty;

@property (nonatomic, strong) NSString *fixedShippingFee;
@property (nonatomic, strong) NSString *sales;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *onSale;

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *mainCategoryName;
@property (nonatomic, strong) NSString *subCategoryName;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *firstCurrencyName;
@property (nonatomic, strong) NSString *secondCurrencyName;
@property (nonatomic, strong) NSString *mppId;
@property (nonatomic, strong) NSDictionary *freePostage;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSString *firstPrice;
@property (nonatomic, strong) NSString *secondPrice;
@property (nonatomic, strong) NSString *unitFirstPrice;
@property (nonatomic, strong) NSString *unitSecondPrice;
@property (nonatomic, strong) NSString *firstOriginalPrice;
@property (nonatomic, strong) NSString *secondOriginalPrice;

@property (nonatomic, strong) NSString *oneWord;
@property (nonatomic, strong) NSString *news;
@property (nonatomic, strong) NSString *params;
@property (nonatomic, strong) NSString *guide;
@property (nonatomic, strong) NSDictionary *brandInfo;

@property (nonatomic, strong) NSString *giftSale;
@property (nonatomic, strong) NSString *firstGiftThreshold;
@property (nonatomic, strong) NSString *secondGiftThreshold;
@property (nonatomic, strong) NSString *firstGiftPrice;
@property (nonatomic, strong) NSString *secondGiftPrice;

@property (nonatomic, strong) NSArray *carouselImgs;

@property (nonatomic, strong) NSString *favoriteId;

@property (nonatomic, strong) NSString *buyFree;

@property (nonatomic, strong) NSString *canGiftSale;

@property (nonatomic, strong) NSString *checked;

@property (nonatomic, strong) NSString *orderedQty;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *stockStatus;

@property (nonatomic, strong) NSString *href;

@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) NSArray <ProductModel *> *data;

@property (nonatomic, strong) NSArray *properties;
@property (nonatomic, strong) NSString *discountType;//选择优惠券或者运费的时候切换的
//@property (nonatomic, strong) NSArray <SppModel *> *spp;
//"currencyCode":"NZD",
//"firstPrice":26.29,
//"secondPrice":"120.95",
//"firstOriginalPrice":30,
//"secondOriginalPrice":"138.01",
//"firstCurrencyName":"NZD $",
//"secondCurrencyName":"￥",
//"favoriteId":344

@property (nonatomic, strong) NSString *fullOffId;
@property (nonatomic, strong) NSString *prefixName;
@property (nonatomic, strong) NSString *byProductId;

@end
