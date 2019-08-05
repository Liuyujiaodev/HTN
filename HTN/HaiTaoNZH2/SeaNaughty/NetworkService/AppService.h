//
//  AppService.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppServiceResult.h"
#import <YYModel.h>
#import <AFNetworking.h>

typedef void(^SuccessBlock)(NSURLSessionDataTask *task, id result);

typedef void(^GetBlock)(NSURLSessionDataTask *task, id responseObject);

typedef void(^FailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface AppService : NSObject

/**
 对网络请求进行封装，基本网络请求
 
 @param method 请求方式
 @param URL 请求地址
 @param parameters 参数
 @param success 网络成功回调
 @param fail 网络失败回调
 */
+ (void)requestHTTPMethod:(NSString *)method
                      URL:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(SuccessBlock)success
                     fail:(FailureBlock)fail;

@end
