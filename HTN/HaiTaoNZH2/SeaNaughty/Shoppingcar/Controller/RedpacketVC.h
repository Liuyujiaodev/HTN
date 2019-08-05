//
//  RedpacketVC.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/3/31.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedpacketVC : BaseRootVC

@property (nonatomic, strong) NSString *orderID;//红包的id
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, strong) NSString *luckyMoney;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSArray *ordersArray;//购物车全部的订单id
@property (nonatomic, strong) NSString *luckOrder;
@property (nonatomic, strong) NSDictionary *nextDic;
@property (nonatomic, assign) BOOL needPay;//是否需要支付

@end

NS_ASSUME_NONNULL_END
