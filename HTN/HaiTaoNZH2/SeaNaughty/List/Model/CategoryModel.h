//
//  CategoryModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChildrenModel.h"

@protocol ChildrenModel

@end

@interface CategoryModel : NSObject

@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *backImg;
@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSArray<ChildrenModel> *children;
@property (nonatomic, strong) NSArray *commonProductIds;
@property (nonatomic, strong) NSArray *recommendProductIds;
@property (nonatomic, strong) NSArray *commonProducts;
@property (nonatomic, strong) NSArray *recommendProducts;
@property (nonatomic, strong) NSString *mainCategoryId;
@property (nonatomic, strong) NSString *topImageName;
@end


