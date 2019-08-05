//
//  CYHShopFullProduModel.h
//  SeaNaughty
//
//  Created by Apple on 2019/6/28.
//  Copyright © 2019年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProductModel.h"


NS_ASSUME_NONNULL_BEGIN

//{
//    activated =                         {
//        data =                             (
//                                            1
//                                            );
//        type = Buffer;
//    };
//    activityProduct = 2;
//    channel = 3;
//    discount = 10;
//    distance = 1;
//    fullOffDiscountAmount = 80;
//    id = 4;
//    memo = "备注";
//    name = "活动名称";
//    nextFullOffDiscountAmount = 90;
//    prefixName = "前置名称";
//    productIds =                         (
//                                          1007102,
//                                          1000251
//                                          );
//    shopId = 1;
//    status = 1;
//    thresholdAmount = 0;
//    thresholdQty = 1;
//    type = 1;
//}

@interface CYHShopFullProduModel : NSObject

@property(nonatomic,strong) NSDictionary* activated;
@property(nonatomic,strong) NSString* activityProduct;
@property(nonatomic,strong) NSString* channel;
@property(nonatomic,strong) NSString* discount;
@property(nonatomic,strong) NSString* distance;
@property(nonatomic,strong) NSString* fullOffDiscountAmount;
@property(nonatomic,strong) NSString* firstFullOffDiscountAmount;
@property(nonatomic,strong) NSString* shopFullID;
@property(nonatomic,strong) NSString* memo;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* nextFullOffDiscountAmount;
@property(nonatomic,strong) NSString* prefixName;
@property(nonatomic,strong) NSArray* productIds;
@property(nonatomic,strong) NSString* shopId;
@property(nonatomic,strong) NSString* status;
@property(nonatomic,strong) NSString* thresholdAmount;
@property(nonatomic,strong) NSString* thresholdQty;
@property(nonatomic,strong) NSString* type;

//自定义物品字段
@property(nonatomic,strong) NSMutableArray  *orderItems;

@end

NS_ASSUME_NONNULL_END
