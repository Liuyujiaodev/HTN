//
//  CommonModelList.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/30.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonModel.h"

@protocol CommonModel

@end

@interface CommonModelList : NSObject

@property (nonatomic, strong) NSArray <CommonModel *> *data;
@property (nonatomic, strong) NSArray <CommonModel *> *rows;
@property (nonatomic, strong) NSArray <CommonModel *> *products;


@end
