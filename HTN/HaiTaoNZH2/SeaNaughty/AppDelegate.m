//
//  AppDelegate.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "ShopListModel.h"
#import <IQKeyboardManager.h>
#import "WXApi.h"
#import "QYSDK.h"
#import "IPNCrossBorderPluginAPi.h"
#import "PPNetworkHelper.h"
#import <UserNotifications/UserNotifications.h>
#import <Bugly/Bugly.h>
#import "AddressManeger.h"
#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import "ActivityMsgListVC.h"
#import "PushListVC.h"
#import "OrderDetailViewController.h"
#import "AdViewController.h"
#import "UITabBarItem+WZLBadge.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@interface AppDelegate () <WXApiDelegate, UITabBarControllerDelegate,UNUserNotificationCenterDelegate,QYConversationManagerDelegate,JPUSHRegisterDelegate>

@property (nonatomic, strong) AdViewController *adVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
   
#pragma mark - 正式测试环境修改
    [AddressManeger sharedInstance].isOnlinePlatform = NO;
     [self getShopList];
     [[UITabBar appearance] setTranslucent:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/banners/advertising" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
            
            if ([[[result valueForKey:@"code"] stringValue] isEqualToString:@"0"])
            {
                NSArray *array = result[@"data"];
                dataArray = [[NSMutableArray alloc] initWithArray:array];
                [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"addata"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDATA" object:dataArray];
                
                if (dataArray.count > 0)
                {
                    NSMutableArray *imageURL = [NSMutableArray arrayWithCapacity:dataArray.count];
                    for (NSDictionary *dic in dataArray)
                    {
                        [imageURL addObject:dic[@"src"]];
                        //                    [SDWebImageManager sharedManager] st
                        
                        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:dic[@"src"]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            
                        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                        }];
                    }
                    
                }
                
                //            [self showMianVC:(NSArray *)dataArray];
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
            //        [self showMianVC:@[]];
        }];
    });
    
   
    
    [NSThread sleepForTimeInterval:1.8];
    
    _adVC = [[AdViewController alloc] init];
//
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first"] == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"first"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ShowUpdateAlert"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NeedUpdate"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"launchTime"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"startTime"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1.0.0" forKey:@"ServiceVersion"];
        self.window.rootViewController = _adVC;
    }
    else
    {
        NSDate *lastTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"launchTime"];
        NSTimeInterval secondsBetweenDates= [[NSDate date] timeIntervalSinceDate:lastTime];

        if (secondsBetweenDates >= 3600)
        {
            self.window.rootViewController = _adVC;
        }
        else
        {
            self.window.rootViewController = self.tabbar;
        }
    }
    
    [self checkAppVersion];
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"customerId"];
    }
    

    [[QYSDK sharedSDK] registerAppId:@"452f06e09ff1718295af1caaa3fb690e" appName:@"NZH跨境平台"];
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UIUserNotificationType types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:types completionHandler:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    
    NSUInteger allUnreadCount = [[QYSDK sharedSDK].conversationManager allUnreadCount];
    
    [[NSUserDefaults standardUserDefaults] setInteger:allUnreadCount forKey:@"allUnreadCount"];
    
   
    [self configJPushWithApplication:application options:launchOptions];
    
    [self getCompanyDetail];
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    // 友盟
    [UMConfigure initWithAppkey:@"5cf8d8083fc195ad52000f75" channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    [MobClick setCrashReportEnabled:YES];
    
//    [WXApi registerApp:@"wx52be9661e1617e75" withDescription:@"Wechat"];
    
//    [WXApi registerApp:@"wx52be9661e1617e75"];
    
    [WXApi registerApp:@"wxf3e19abaf90ffa09"];
//    wx4be4774445493dc5
    
    [self.window makeKeyAndVisible];
    
    [Bugly startWithAppId:@"55206acd9b"];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification.allKeys.count > 0 && [remoteNotification.allKeys containsObject:@"msgId"])
    {
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEEDLOGIN" object:nil];
        }
        else
        {
            [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/push/detail" parameters:@{@"id":[NSString stringWithFormat:@"%@", remoteNotification[@"msgId"]], @"customerId":[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"]} success:^(NSURLSessionDataTask *task, id result) {
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
                    NSDictionary *data = result[@"data"];
                    NSNumber *type = data[@"type"];
                    if ([[NSString stringWithFormat:@"%@", type] isEqualToString:@"1"])
                    {
                        PushListVC *vc = [[PushListVC alloc] init];
                        vc.fromPush = YES;
                        vc.type = @"1";
                        vc.titleString = @"系统通知";
                        BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
                        [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
                        
                    }
                    else if ([[NSString stringWithFormat:@"%@", type] isEqualToString:@"2"])
                    {
                        ActivityMsgListVC *vc = [[ActivityMsgListVC alloc] init];
                        vc.fromPush = YES;
                        BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
                        [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
                    }
                    else if ([[NSString stringWithFormat:@"%@", type] isEqualToString:@"3"])
                    {
                        //                    OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
                        //                    vc.fromPush = YES;
                        //                    vc.orderId = data[@"href"];
                        //                    BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
                        //                    [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
                        PushListVC *vc = [[PushListVC alloc] init];
                        vc.fromPush = YES;
                        vc.type = @"3";
                        vc.titleString = @"交易物流";
                        BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
                        [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
                        
                    }
                }
                
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }
    
    [JPUSHService setBadge:0];
    application.applicationIconBadgeNumber = 0;
    
    return YES;
}

- (void)configJPushWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    
    // 极光推送环境
    //正式 9386fbdd40575d735a844523
    //测试 9a71c53306494eb675aad677
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"9386fbdd40575d735a844523"
                          channel:@""
                 apsForProduction:YES
            advertisingIdentifier:nil];
//    JPUSHService
    
}

- (void)showMianVC:(NSArray *)dataArray
{
    
}

- (BaseTabBarController *)tabbar
{
    if (!_tabbar)
    {
        _tabbar = [[BaseTabBarController alloc] init];
        _tabbar.delegate = self;
    }
    return _tabbar;
}

- (void)onUnreadCountChanged:(NSInteger)count
{
    NSLog(@"====count %ld",count);
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"allUnreadCount"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCount" object:nil];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//
    if ([viewController.tabBarItem.title isEqualToString:@"个人"]  || [viewController.tabBarItem.title isEqualToString:@"购物车"])
    {
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
        {
            self.tabbar.selectedIndex = 0;
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.tabbar.home pushViewController:vc animated:YES];
            //        NSLog(@"%@", self.tabbar.home.viewControllers);
            return NO;
        }
        return YES;
    }
//
    return YES;
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[QYSDK sharedSDK] updateApnsToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
        
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    if ([userInfo.allKeys containsObject:@"msgId"])
    {
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEEDLOGIN" object:nil];
        }
        else
        {
            [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/push/detail" parameters:@{@"id":[NSString stringWithFormat:@"%@", userInfo[@"msgId"]], @"customerId":[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"]} success:^(NSURLSessionDataTask *task, id result) {
                
                if ([[result[@"code"] stringValue] isEqualToString:@"0"])
                {
                    
                    
                    NSDictionary *data = result[@"data"];
                    NSNumber *type = data[@"type"];
                    if ([[NSString stringWithFormat:@"%@", type] isEqualToString:@"1"])
                    {
                        PushListVC *vc = [[PushListVC alloc] init];
                        vc.fromPush = YES;
                        vc.type = @"1";
                        vc.titleString = @"系统通知";
                        BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
                        [self.tabbar.selectedViewController presentViewController:nvc animated:YES completion:nil];
                        
                    }
                    else if ([[NSString stringWithFormat:@"%@", type] isEqualToString:@"2"])
                    {
                        ActivityMsgListVC *vc = [[ActivityMsgListVC alloc] init];
                        vc.fromPush = YES;
                        BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
                        [self.tabbar.selectedViewController presentViewController:nvc animated:YES completion:nil];
                    }
                    else if ([[NSString stringWithFormat:@"%@", type] isEqualToString:@"3"])
                    {
                        PushListVC *vc = [[PushListVC alloc] init];
                        vc.fromPush = YES;
                        vc.type = @"3";
                        vc.titleString = @"交易物流";
                        BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
                        [self.tabbar.selectedViewController presentViewController:nvc animated:YES completion:nil];
                    }
                }
                
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    
    }

    
    
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}




- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    
    NSLog(@"%@", [url absoluteString]);
    
    if ([[url absoluteString] containsString:@"pay"]) {
        
       return [IPNCrossBorderPluginAPi application:application openURL:url sourceApplication:@"" annotation:nil];
        
    }
    else
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
    
    
//    wx52be9661e1617e75://oauth?code=021kgtiW1t5e7V0J86jW1c3siW1kgtiL&state=App
//    wx52be9661e1617e75://oauth?code=00134vhk0mtNrm1L04fk0S1khk034vh2&state=App
}


//微信代理方法
- (void)onResp:(BaseResp *)resp
{
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if(aresp.errCode== 0 && [aresp.state isEqualToString:@"App"])
    {
        NSString *code = aresp.code;
        [self getWeiXinOpenId:code];
    }
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url absoluteString] containsString:@"pay"]) {
        
        return [IPNCrossBorderPluginAPi application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
        
    }
    else
    {
        return  [WXApi handleOpenURL:url delegate:self];
    }
    
}

//通过code获取access_token，openid，unionid
- (void)getWeiXinOpenId:(NSString *)code{
    
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx4be4774445493dc5",@"873a9b379bf5f55052cf569ffbc68746",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data){
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSString *openID = dic[@"openid"];
//                NSString *unionid = dic[@"unionid"];
                
                NSLog(@"%@", dic);
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WECHAT" object:dic];
                
            }
        });
    });
    
}


- (void)getShopList
{
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/shops" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        if ([[[result valueForKey:@"code"] stringValue] isEqualToString:@"0"]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:result forKey:SHOPLIST];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 检查版本
- (void)checkAppVersion
{
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/appVersion?platform=ios" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appversion = [infoDictionary valueForKey:@"CFBundleShortVersionString"];
            NSString *version = result[@"data"][@"version"];
            NSArray *tabBarItems = self.tabbar.tabBar.items;
//            NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
          
    
            UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:3];
            if (![version isEqualToString:appversion])
            {
                // 如果版本不同，判断是否有更新的版本：按照.分割，从前往后判断
                NSArray *versionArray = [version componentsSeparatedByString:@"."];
                NSArray *appversionArray = [appversion componentsSeparatedByString:@"."];
                bool needUpdate = false;
                for (NSInteger i=0; i<[versionArray count]; i++) {
                    int versionNum = [versionArray[i] intValue];
                    int appversionNum = [appversionArray[i] intValue];
                    if(versionNum>appversionNum){
                        // 有大于，则提示更新
                        needUpdate = true;
                        break;
                    }else if(versionNum<appversionNum){
                        // 出现小于，不更新
                        break;
                    }
                }
                
                if(needUpdate){
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"NeedUpdate"];
                    // 版本更新提示在一个版本内只提示一次，因此需要记录当前app是否已经弹过该版本
                    NSString *temp = [[NSUserDefaults standardUserDefaults] valueForKey:@"ServiceVersion"];
                    if (![temp isEqualToString:version])
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ShowUpdateAlert"];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"ServiceVersion"];
                    [personCenterTabBarItem showBadge];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NeedUpdate"];
                    [personCenterTabBarItem clearBadge];
                }
                
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"NeedUpdate"];
                [personCenterTabBarItem clearBadge];
            }
            
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getCompanyDetail
{
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/companies?name=NZH" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *data = result[@"data"];
            [[NSUserDefaults standardUserDefaults] setValue:data[@"qrcode"] forKey:@"QRCODE"];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
#pragma mark - 退出到后台计时
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"launchTime"];
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [JPUSHService setBadge:0];
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
#pragma mark - 应用被杀死计时
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"launchTime"];
    
}


@end
