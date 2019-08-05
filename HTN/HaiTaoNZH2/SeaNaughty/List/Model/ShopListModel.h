//
//  ShopListModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/23.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ShopModel.h"

@protocol ShopModel

@end

@interface ShopListModel : NSObject

@property (nonatomic, strong) NSArray<ShopModel> *data;
@end
