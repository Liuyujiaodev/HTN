//
//  AppService.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "AppServiceAgent.h"
#import <AFNetworking.h>
#import "AppServiceUploadFile.h"

@interface AppServiceAgent ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end



@implementation AppServiceAgent


+ (instancetype)shareService
{
    static AppServiceAgent *serviceAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceAgent = [[AppServiceAgent alloc] init];
    });
    return serviceAgent;
}

- (instancetype)init
{
    if (self = [super init]) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 30.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        
    }
    return self;
}

/**
 *  获取默认配置标准的AFHTTPSessionManager
 *
 *  @return AFHTTPSessionManager实例
 */
//- (AFHTTPSessionManager *)httpSessionManagerByDefaultConfig
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    manager.requestSerializer.timeoutInterval = 20;
//    if([UIDevice currentDevice].systemVersion.floatValue < 11.0)
//    {
//        // 客户端是否信任非法证书
//        manager.securityPolicy.allowInvalidCertificates = YES;
//        // 是否在证书域字段中验证域名
//        [manager.securityPolicy setValidatesDomainName:NO];
//    }
//
//    return manager;
//}


- (NSURLSessionDataTask *)appDataTaskWithHTTPMethod:(NSString *)method
                                          URLString:(NSString *)URLString
                                         parameters:(NSDictionary *)parameters
                                    headerParamters:(NSDictionary *)headerParamters
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self appDataTaskWithHTTPMethod:method
                                 URLString:URLString
                                parameters:parameters
                           headerParamters:headerParamters
                            uploadProgress:nil
                          downloadProgress:nil
                                   success:success
                                   failure:failure];
    
}




- (NSURLSessionDataTask *)appDataTaskWithHTTPMethod:(NSString *)method
                                          URLString:(NSString *)URLString
                                         parameters:(id)parameters
                                    headerParamters:(id)headerParamters
                                     uploadProgress:(void (^)(NSProgress *uploadProgress)) uploadProgress
                                   downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgress
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = _manager;
    
    
    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript",@"image/jpeg",nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSError *serializationError = nil;
    if (headerParamters) {
        [headerParamters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }

        return nil;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [manager dataTaskWithRequest:request
                             uploadProgress:uploadProgress
                           downloadProgress:downloadProgress
                          completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {

                              if (error) {
                                  if (failure) {
                                      NSLog(@"error = %@",error);
                                      failure(dataTask, error);
                                  }
                              } else {
                                  if (success) {

                                      success(dataTask, responseObject);
                                  }
                              }
                          }];
    //启动
    [dataTask resume];

    return dataTask;
}


#pragma mark - 上传文件


//- (NSURLSessionUploadTask *)appUploadTaskWithURLString:(NSString *)URLString
//                                            parameters:(NSDictionary *)parameters
//                                           uploadFiles:(NSArray<AppServiceUploadFile *> *)uploadFiles
//                                              progress:(void (^)(NSProgress *uploadProgress))uploadProgress
//                                               success:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
//                                               failure:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure
//{
//    return [self appUploadTaskWithURLString:URLString parameters:parameters headerParamters:nil uploadFiles:uploadFiles progress:uploadProgress success:success failure:failure];
//}

//- (NSURLSessionUploadTask *)appUploadTaskWithURLString:(NSString *)URLString
//                                            parameters:(NSDictionary *)parameters
//                                       headerParamters:(NSDictionary *)headerParamters
//                                           uploadFiles:(NSArray<AppServiceUploadFile *> *)uploadFiles
//                                              progress:(void (^)(NSProgress *uploadProgress))uploadProgress
//                                               success:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
//                                               failure:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure
//{
//    AFHTTPSessionManager *manager = _manager;
//    manager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json" ,@"text/javascript", nil];
//    NSError *serializationError = nil;
//    if (headerParamters) {
//        [headerParamters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
//        }];
//    }
//    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        if (uploadFiles && uploadFiles.count > 0) {
//            for (AppServiceUploadFile *file in uploadFiles) {
//                NSData *fileData = [NSData dataWithContentsOfFile:file.fileURL];
//                [formData appendPartWithFileData:fileData name:file.name fileName:file.filename mimeType:file.mimeType];
//            }
//        }
//    } error:&serializationError];
//    if (serializationError) {
//        if (failure) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wgnu"
//            dispatch_async(manager.completionQueue ?: dispatch_get_main_queue(), ^{
//                failure(nil, serializationError);
//            });
//#pragma clang diagnostic pop
//        }
//
//        return nil;
//    }
//
//    __block NSURLSessionUploadTask *task = [manager uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
//        if (error) {
//            if (failure) {
//                failure(task, error);
//            }
//        } else {
//            if (success) {
//                success(task, responseObject);
//            }
//        }
//    }];
//
//    [task resume];
//
//    return task;
//}



@end
