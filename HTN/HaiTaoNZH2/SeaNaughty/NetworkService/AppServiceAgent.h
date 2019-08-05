//
//  AppService.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppServiceUploadFile.h"

@interface AppServiceAgent : NSObject

+ (instancetype)shareService;

#pragma mark - 基本请求
/**
 *  适应所有基本请求
 *
 *  @param method          请求方式
 *  @param URLString       请求URL
 *  @param parameters      参数
 *  @param headerParamters 在头部添加参数,nil则不附加公共参数
 *  @param success         成功回调
 *  @param failure         失败回调
 *
 *  @return NSURLSessionDataTask实例
 */
- (NSURLSessionDataTask *)appDataTaskWithHTTPMethod:(NSString *)method
                                          URLString:(NSString *)URLString
                                         parameters:(NSDictionary *)parameters
                                    headerParamters:(NSDictionary *)headerParamters
                                            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                            failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

#pragma mark - 下载文件

/**
 *  下载文件，只能是GET和POST,如果是其他，则返回nil对象，在DEBUG下产生断言
 *
 *  @param method                请求方式，只适合GET,POST
 *  @param URLString             请求URL
 *  @param parameters            参数
 *  @param downloadProgressBlock 下载进度
 *  @param destination           下载存放路径
 *  @param success               成功回调
 *  @param failure               失败回调
 *
 *  @return  NSURLSessionDownloadTask实例
 */
- (NSURLSessionDownloadTask *)appDownloadTaskWithHTTPMethod:(NSString *)method
                                                  URLString:(NSString *)URLString
                                                 parameters:(NSDictionary *)parameters
                                                   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                                destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                                    success:(void (^)(NSURLSessionDownloadTask *task, NSURLResponse *response))success
                                                    failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure;


#pragma mark - 文件上传

/**
 *  单文件上传
 *
 *  @param URLString      请求URL
 *  @param parameters     参数
 *  @param uploadFiles    上传文件数组
 *  @param uploadProgress 上传进度
 *  @param success        成功回调
 *  @param failure        失败回调
 *
 *  @return NSURLSessionUploadTask实例
 */
- (NSURLSessionUploadTask *)appUploadTaskWithURLString:(NSString *)URLString
                                            parameters:(NSDictionary *)parameters
                                           uploadFiles:(NSArray<AppServiceUploadFile *> *)uploadFiles
                                              progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                               success:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
                                               failure:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure;


/**
 *  上传多文件
 *
 *  @param URLString       请求URL
 *  @param parameters      参数
 *  @param headerParamters http头参数，nil则不附加公共参数
 *  @param uploadFiles     上传文件数组
 *  @param uploadProgress  上传进度
 *  @param success         成功回调
 *  @param failure         失败回调
 *
 *  @return NSURLSessionUploadTask实例
 */
- (NSURLSessionUploadTask *)appUploadTaskWithURLString:(NSString *)URLString
                                            parameters:(NSDictionary *)parameters
                                       headerParamters:(NSDictionary *)headerParamters
                                           uploadFiles:(NSArray<AppServiceUploadFile *> *)uploadFiles
                                              progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                                               success:(void (^)(NSURLSessionUploadTask *task, id responseObject))success
                                               failure:(void (^)(NSURLSessionUploadTask *task, NSError *error))failure;

@end
