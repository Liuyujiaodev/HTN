//
//  AppServiceUploadFile.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  用于多文件传输使用
 */
@interface AppServiceUploadFile : NSObject

/**
 *  文件地址
 */
@property (nonatomic, copy) NSString *fileURL;

/**
 *  外面参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  传到服务器的文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end
