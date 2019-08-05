//
//  SppModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/24.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SppModel
@end

@interface SppModel : NSObject

//"productId":1069263,
//"type":4,
//"currencyId":3,
//"sku":"9349788162335",
//"颜色":"栗色",
//"尺码":"39码",
//"stock":9999
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *currencyId;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *key1;
@property (nonatomic, strong) NSString *key2;
@property (nonatomic, strong) NSString *key3;
@property (nonatomic, strong) NSString *key4;
@property (nonatomic, strong) NSString *key5;

@property (nonatomic, strong) NSArray <SppModel *> *spp;

@end


