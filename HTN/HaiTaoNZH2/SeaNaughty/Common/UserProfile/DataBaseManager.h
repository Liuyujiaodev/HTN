//
//  DataBaseManager.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "UserProfile.h"

@interface DataBaseManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  创建默认数据库
 */
- (void)createDefaultDataBase;

- (FMDatabase *)createDataBaseName:(NSString *)dataBaseName;

- (BOOL)savetUserInfo:(UserProfile *)userInfo;

- (void)loadUser:(UserProfile *)userInfo;

- (BOOL)userLogOut:(UserProfile *)userInfo;

@end
