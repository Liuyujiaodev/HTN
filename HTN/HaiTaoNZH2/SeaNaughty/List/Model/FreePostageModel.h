//
//  FreePostageModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreePostageModel : NSObject

@property (nonatomic, strong) NSString *postageId;
@property (nonatomic, strong) NSString *firstThreshold;
@property (nonatomic, strong) NSString *secondThreshold;
@property (nonatomic, strong) NSString *firstCurrencyName;
@property (nonatomic, strong) NSString *secondCurrencyName;
@end
