//
//  DataBaseManager.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "DataBaseManager.h"

#define DefaultBaseName @"SeaNaughtyData.db"

#define CreateUser    @"CREATE TABLE IF NOT EXISTS USER(id INTEGER PRIMARY KEY AUTOINCREMENT, EMAIL TEXT,PHONE TEXT, LOGINNAME TEXT, FULLNAME TEXT, MONTHLYSTATEMENT TEXT, MEMBERGROP TEXT, AVATARURL TEXT)"

//是否存在该用户
#define ExistUser @"SELECT * FROM USER WHERE id = '%@'"
//当登录时，存储信息
#define SaveUser @"INSERT INTO USER(id, EMAIL, PHONE, LOGINNAME, FULLNAME, MONTHLYSTATEMENT, MEMBERGROP, AVATARURL) VALUES('%@', '%@','%@', '%@', '%@','%@','%@','%@')"
//更新
#define UpdateUser @"UPDATE USER SET ACCESS_TOKEN = '%@', AVATAR = '%@', PHONE = '%@', NAME = '%@', NICKNAME = '%@' WHERE id = '%@'"
//用户退出
#define UserLogOut @"UPDATE USER SET ACCESS_TOKEN = NULL WHERE UESR_LOGIN = '%@'"
//加载用户
#define LoadUser @"SELECT UESR_LOGIN, ACCESS_TOKEN, AVATAR, PHONE, NAME, NICKNAME FROM USER WHERE ACCESS_TOKEN NOT NULL"

@interface DataBaseManager ()
/**
 *  默认数据库
 */
@property (nonatomic, strong) FMDatabase *defaultDataBase;

@end

@implementation DataBaseManager

static DataBaseManager *sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataBaseManager alloc] init];
    });
    return sharedInstance;
}


- (FMDatabase *)createDataBaseName:(NSString *)dataBaseName
{
    //APP所在路径
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                               NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:dataBaseName];
    
    //没有则创建
    FMDatabase *dataBase=[FMDatabase databaseWithPath:dbFilePath];
    
    return dataBase;
}

- (void)createDefaultDataBase
{
    _defaultDataBase = [self createDataBaseName:DefaultBaseName];
    [self createInitTableByDatabase];
}

//打开的前提下
- (void)createInitTableByDatabase
{
    if ([_defaultDataBase open])
    {
        if (![_defaultDataBase executeUpdate:CreateUser])
        {
            NSLog(@"创建用户表失败");
        }
        //关闭
        [_defaultDataBase close];
    }
}

- (BOOL)savetUserInfo:(UserProfile *)userInfo
{
    BOOL status = NO;
    if ([_defaultDataBase open])
    {
        FMResultSet *result = [_defaultDataBase executeQuery:[NSString stringWithFormat:ExistUser,userInfo.user_login]];
        
        if (result.next)
        {
            status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:UpdateUser,userInfo.access_token,userInfo.avatar,userInfo.phone,userInfo.name,userInfo.nickname,userInfo.user_login]];
        }
        else
        {
            status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:SaveUser,userInfo.user_login,userInfo.access_token,userInfo.avatar,userInfo.phone,userInfo.name,userInfo.nickname]];
        }
        
        [_defaultDataBase close];
    }
    
    return status;
}

- (BOOL)userLogOut:(UserProfile *)userInfo
{
    BOOL status = NO;
    if([_defaultDataBase open])
    {
        status = [_defaultDataBase executeUpdate:[NSString stringWithFormat:UserLogOut, userInfo.user_login]];
    }
    return status;
}

- (void)loadUser:(UserProfile *)userInfo
{
    if ([_defaultDataBase open]) {
        FMResultSet *result=[_defaultDataBase executeQuery:LoadUser];
        if(result.next)
        {
            userInfo.user_login = [result stringForColumn:@"UESR_LOGIN"];
            userInfo.access_token = [result stringForColumn:@"ACCESS_TOKEN"];
            userInfo.avatar = [result stringForColumn:@"AVATAR"];
            userInfo.phone = [result stringForColumn:@"PHONE"];
            userInfo.name = [result stringForColumn:@"NAME"];
            userInfo.nickname = [result stringForColumn:@"NICKNAME"];
        }
    }
}

@end
