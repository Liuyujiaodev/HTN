//
//  CartModel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel

- (NSMutableArray<ProductModel *> *)orderItems
{
    
    if (!_orderItems)
    {
        _orderItems = (NSMutableArray<ProductModel *> *)[[NSMutableArray alloc] init];
    }
    return _orderItems;
}

- (NSMutableArray<CYHShopFullProduModel *> *)shopFullOffs {
    
    if (!_shopFullOffs) {
        
        _shopFullOffs = (NSMutableArray<CYHShopFullProduModel *> *)[[NSMutableArray alloc] init];
        
    }return _shopFullOffs;
}

- (NSMutableArray *)shopFullProducts {
    
    if (!_shopFullProducts) {
        
        _shopFullProducts = [[NSMutableArray alloc] init];
        
    }return _shopFullProducts;
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderItems" : [ProductModel class],
             @"giftProducts" :[ProductModel class],
             @"voucher" : [VoucherModel class],
             @"shopFullOffs" :[CYHShopFullProduModel class]
             };
}

@end
