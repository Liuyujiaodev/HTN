//
//  UserProfile.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "UserProfile.h"
#import "DataBaseManager.h"

@interface UserProfile ()

@end

@implementation UserProfile

static UserProfile *sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserProfile alloc] init];;
        [sharedInstance load];
    });
    
    return sharedInstance;
}

- (void)load
{
    [[DataBaseManager sharedInstance] loadUser:self];
}

- (BOOL)save
{
    return  [[DataBaseManager sharedInstance] savetUserInfo:self];
}

- (BOOL)cleanUp
{
    BOOL reslut = [[DataBaseManager sharedInstance] userLogOut:self];
    _phone = @"";
    _avatar = @"";
    _access_token = @"";
    
    return reslut;
}

-(BOOL)isLogin
{
    
    return _access_token.length > 0;
}


@end
