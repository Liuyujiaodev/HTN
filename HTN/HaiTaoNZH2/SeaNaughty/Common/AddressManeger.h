//
//  AddressManeger.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/12.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    Platform_Test,
    Platform_Online,
} Platform;

@interface AddressManeger : NSObject

@property (nonatomic, assign) Platform isOnlinePlatform;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
