//
//  AppService.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "AppService.h"
//#import "AppServiceAgent.h"
#import <AFNetworking.h>


@implementation AppService


+ (void)requestHTTPMethod:(NSString *)method
                      URL:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(SuccessBlock)success
                     fail:(FailureBlock)fail
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [dic setObject:@"NZH" forKey:@"company"];
    
    if (![AFNetworkReachabilityManager sharedManager].reachable)
    {
        [SVProgressHUD showErrorWithStatus:@"您的网络好像不是很给力哦"];
        [SVProgressHUD dismissWithDelay:1.2];
    }
    
    if (![URL containsString:@"://"])
    {
        if (![URL containsString:@"https://api.weixin.qq.com/sns/userinfo"])
        {
            URL = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"mainUrl"],URL];
        }
    }
    
   
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    sessionManager.requestSerializer.timeoutInterval = 30.f;
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    
    [sessionManager.requestSerializer setValue:@"$2a$08$bW3CufG4d5HGlBRWkgRSyuc5E0viJ40V8qQdDOx9TzAy84OMipXVa" forHTTPHeaderField:@"token"];
    

    
    
    
    if ([method isEqualToString:@"get"])
    {
        [sessionManager GET:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(task,responseObject);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            fail(task,error);
            
        }];
    }
    else if ([method isEqualToString:@"post"])
    {
        [sessionManager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            fail(task,error);
        }];
    }
    
    
    
//
//    [AppService requestHTTPMethod:method
//                              URL:URL
//                 headerParameters:@{@"token":@"$2a$08$bW3CufG4d5HGlBRWkgRSyuc5E0viJ40V8qQdDOx9TzAy84OMipXVa"}
//                       parameters:dic
//                          success:success
//                             fail:fail];
}



@end
