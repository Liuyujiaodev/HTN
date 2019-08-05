//
//  MsgModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/30.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgModel : NSObject

//"id":3,
//"type":2,
//"alert":"促销消息1",
//"subtitle":"111",
//"news":"<p>",
//"thumbnail":"http://nzhgpro-10054974.file.myqcloud.com/product/KlLNKPtgFz5PtbJvPuWBPoBL.jpg",
//"createTime":1555998899,
//"pushTime":1556269685,
//"showType":2,
//"audience":null,
//"status":1,
//"href":"http://test.aulinkc.com"

@property (nonatomic, strong) NSNumber *msgId;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *alert;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *news;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *audience;
@property (nonatomic, strong) NSString *href;
@property (nonatomic, strong) NSNumber *showType;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *createTime;
@property (nonatomic, strong) NSNumber *pushTime;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGFloat titleHight;
@property (nonatomic, assign) CGFloat subTitleHight;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSNumber *endTime;
@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, strong) NSArray <MsgModel *> *rows;

@end

NS_ASSUME_NONNULL_END
