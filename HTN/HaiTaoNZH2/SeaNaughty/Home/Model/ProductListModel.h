//
//  ProductListModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import<Foundation/Foundation.h>
#import "ProductModel.h"


@interface ProductListModel : NSObject

@property (nonatomic, strong) NSArray<ProductModel *>* products;
@property (nonatomic, strong) NSArray<ProductModel *>* rows;
@property (nonatomic, strong) NSArray<ProductModel *>* data;

@end
