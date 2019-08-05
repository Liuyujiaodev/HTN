//
//  VoucherModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface VoucherModel : NSObject

//"id":1704839,
//"voucherBookId":1000371,
//"amount":13.14,
//"description":"七夕测试",
//"minProductAmount":299,
//"superimposed":Object{...},
//"startTime":null,
//"endTime":null,
//"currencyId":2,
//"currencyCode":"CNY",
//"isValid":1,
//"firstAmount":"2.89",
//"secondAmount":"13.14",
//"firstMinProductAmount":"65.78",
//"secondMinProductAmount":"299.00",
//"firstCurrencyName":"NZD $",
//"secondCurrencyName":"￥",
//"shopId":Array[1],
//"shopName":Array[1],
//"selected":1
@property (nonatomic, strong) NSString *voucherId;
@property (nonatomic, strong) NSString *voucherBookId;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, strong) NSString *minProductAmount;
@property (nonatomic, strong) NSDictionary *superimposed;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *currencyId;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *isValid;
@property (nonatomic, strong) NSString *firstAmount;
@property (nonatomic, strong) NSString *secondAmount;
@property (nonatomic, strong) NSString *firstMinProductAmount;
@property (nonatomic, strong) NSString *secondMinProductAmount;
@property (nonatomic, strong) NSString *firstCurrencyName;
@property (nonatomic, strong) NSString *secondCurrencyName;
@property (nonatomic, strong) NSArray *shopId;
@property (nonatomic, strong) NSArray *brandName;
@property (nonatomic, strong) NSArray *brandId;
@property (nonatomic, strong) NSArray *shopName;
@property (nonatomic, strong) NSArray *productName;
@property (nonatomic, strong) NSString *useCondition;
@property (nonatomic, strong) NSString *selected;

@property (nonatomic, assign) BOOL isPFree;
@property (nonatomic, assign) BOOL hasSelect;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSArray <VoucherModel*> *data;

-(BOOL)isEqualToModel:(VoucherModel *)model;

@end
