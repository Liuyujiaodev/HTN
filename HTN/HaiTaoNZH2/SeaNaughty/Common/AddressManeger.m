//
//  AddressManeger.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/12.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "AddressManeger.h"

@implementation AddressManeger

static AddressManeger *sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AddressManeger alloc] init];;
//        [sharedInstance loadAccount];
    });
    
    return sharedInstance;
}

- (void)setIsOnlinePlatform:(Platform)isOnlinePlatform
{
    _isOnlinePlatform = isOnlinePlatform;
    
    NSString *mainUrl = @"http://api.nzhg.co.nz";
    NSString *loginUrl = @"http://www.nzhg.co.nz";
    
    if (!_isOnlinePlatform)
    {
        mainUrl = @"http://test.api.aulinkc.com";
        loginUrl = @"http://test.aulinkc.com";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:mainUrl forKey:@"mainUrl"];
    [[NSUserDefaults standardUserDefaults] setObject:loginUrl forKey:@"loginUrl"];
    
}


@end
