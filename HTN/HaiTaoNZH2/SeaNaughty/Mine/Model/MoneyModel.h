//
//  MoneyModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/6.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MoneyModel : NSObject

//"amountChanged": "-41.99纽币",
//"currencyId": 1,
//"changeTime": 1539246898,
//"type": "订单消费",
//"currencyCode": "NZD",
//"currencyName": "纽币",
//"orderNumber": "EWR201810111634373887"

@property (nonatomic, strong) NSString *amountChanged;
@property (nonatomic, strong) NSString *currencyId;
@property (nonatomic, strong) NSString *object;
@property (nonatomic, strong) NSString *changeTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSString *currencyName;
@property (nonatomic, strong) NSString *orderNumber;
@end

NS_ASSUME_NONNULL_END
