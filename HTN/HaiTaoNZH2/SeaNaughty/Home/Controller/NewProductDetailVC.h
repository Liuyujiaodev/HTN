//
//  NewProductDetailVC.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/25.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"

#import "ProductModel.h"

@interface NewProductDetailVC : BaseRootVC

@property (nonatomic, strong) NSString *productId;

@property (nonatomic, assign) BOOL isSale;

@end


