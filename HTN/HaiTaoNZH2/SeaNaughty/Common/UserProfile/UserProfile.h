//
//  UserProfile.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *ethnicity;

@property (nonatomic, strong) NSString *nativePlace;

@property (nonatomic, strong) NSString *political;

@property (nonatomic, strong) NSString *joinTime;

@property (nonatomic, strong) NSString *object;

@property (nonatomic, strong) NSString *university;

@property (nonatomic, strong) NSString *major;

@property (nonatomic, strong) NSString *education;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, strong) NSString *workExperience;

@property (nonatomic, strong) NSString *workingLifeTime;

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *gender;

@property (nonatomic, strong) NSString *age;

@property (nonatomic, strong) NSString *introduce;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *birthday;

@property (nonatomic, strong) NSString *user_login;

@property (nonatomic, strong) NSString *access_token;

@property(nonatomic, readonly)BOOL isLogin;

+ (instancetype)sharedInstance;

- (BOOL)save;

- (BOOL)cleanUp;

- (void)load;


@end
