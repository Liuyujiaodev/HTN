//
//  CommonModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/30.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface CommonModel : NSObject


//"sku":"9415998201017",

//"type":1,
//"weight":400,
//"shopId":1,
//"currencyId":1,
//"brandId":1000103,
//"mainCategoryId":10,
//"subCategoryId":21,
//"validDate":1622548799,
//"shippingFeeWay":1,
//"zeroShippingFeeQty":null,
//"fixedShippingFee":null,
//"status":true,
//"createTime":1456581643,
//"giftSale":0,
//"limitedQty":null,
//"mppId":null,
//"sales":1439,
//"quantity":9999,
//"imgUrl":"http://auhdev-10054974.file.myqcloud.com/product/hk77gL7zn8SgyJGVSftWm9vm.jpg",
//"shopName":"新西兰直邮仓",
@property (nonatomic, strong) NSString *commonID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *rule;
@property (nonatomic, strong) NSString *homeLimit;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *backImg;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *intro;

//firstCurrencyName  firstPrice  secondCurrencyName  secondPrice

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *giftSale;
@property (nonatomic, strong) NSString *mppId;
@property (nonatomic, strong) NSString *sales;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *limitedQty;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *firstCurrencyName;
@property (nonatomic, strong) NSString *secondCurrencyName;
@property (nonatomic, strong) NSString *firstPrice;
@property (nonatomic, strong) NSString *secondPrice;
@property (nonatomic, strong) NSString *firstOriginalPrice;
@property (nonatomic, strong) NSString *secondOriginalPrice;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSDictionary *freePostage;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, assign) NSTimeInterval validDate;

@property (nonatomic, strong) NSString *receiveName;
@property (nonatomic, strong) NSString *receivePhone;
@property (nonatomic, strong) NSString *receiveAddress;
@property (nonatomic, strong) NSString *receiveIdCard;
@property (nonatomic, strong) NSString *receiveProvince;
@property (nonatomic, strong) NSString *receiveCity;
@property (nonatomic, strong) NSString *receiveArea;

@property (nonatomic, strong) NSString *sendAddress;
@property (nonatomic, strong) NSString *sendName;
@property (nonatomic, strong) NSString *sendPhone;

@property (nonatomic, strong) NSString *favoriteId;

@property (nonatomic, strong) NSString *areaName;




@end
