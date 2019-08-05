//
//  CategoryListModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"

@protocol CategoryModel

@end

@interface CategoryListModel : NSObject

@property (nonatomic, strong) NSArray<CategoryModel> *data;

@end
