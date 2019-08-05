//
//  BankModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject

//"account": "06-0998-0193159-00",
//"bankName": "ANZ",
//"accountName": "NZH Ltd",
//"remark": "转账时请在Reference信息中注明您的单号“17218”，以便我们确认您的订单，支付完成后请务必将付款信息的截图发给客服",
//"currencyName": "纽币"
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *currencyName;
@property (nonatomic, assign) BOOL checked;

@end
