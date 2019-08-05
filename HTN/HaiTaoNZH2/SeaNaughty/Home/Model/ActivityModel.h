//
//  ActivityModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ProductListModel.h"

@interface ActivityModel : NSObject

//"id":52,
//"name":"活动这么少吗",
//"subTitle":"22222222222222",
//"rule":1,
//"imgUrl":null,
//"homeLimit":7,
//"products":Array[6]
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *rule;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *homeLimit;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *backImg;

@end
