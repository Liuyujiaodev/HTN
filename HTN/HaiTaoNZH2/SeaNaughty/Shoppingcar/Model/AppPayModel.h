//
//  AppPayModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppPayModel : NSObject

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *mhtOrderNo;
@property (nonatomic, strong) NSString *mhtOrderType;
@property (nonatomic, strong) NSString *mhtOrderName;
@property (nonatomic, strong) NSString *mhtCurrencyType;
@property (nonatomic, strong) NSString *mhtAmtCurrFlag;
@property (nonatomic, strong) NSString *mhtOrderAmt;
@property (nonatomic, strong) NSString *mhtOrderDetail;
@property (nonatomic, strong) NSString *mhtOrderTimeOut;
@property (nonatomic, strong) NSString *mhtOrderStartTime;
@property (nonatomic, strong) NSString *notifyUrl;
@property (nonatomic, strong) NSString *mhtCharset;
@property (nonatomic, strong) NSString *payChannelType;
@property (nonatomic, strong) NSString *mhtReserved;
@property (nonatomic, strong) NSString *mhtSignature;
@property (nonatomic, strong) NSString *mhtSignType;
@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *str;

@end
