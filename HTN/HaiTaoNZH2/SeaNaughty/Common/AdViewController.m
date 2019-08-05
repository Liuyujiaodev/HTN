//
//  AdViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/5/22.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "AdViewController.h"
#import <SDCycleScrollView.h>
#import "AppDelegate.h"
#import "ProductDetailViewController.h"
#import "IndexListViewController.h"
#import "ListShopViewController.h"
#import "H5ViewController.h"
#import <SDWebImage/SDWebImageManager.h>

@interface AdViewController () <SDCycleScrollViewDelegate>


@property (nonatomic, strong) SDCycleScrollView *adView;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"launch.jpg"]];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:G_SCREEN_BOUNDS];
    bgView.image = [UIImage imageNamed:@"launch.jpg"];
    [self.view addSubview:bgView];
    
//    self.view.backgroundColor = [UIColor redColor];
    
    _adView = [[SDCycleScrollView alloc] initWithFrame:G_SCREEN_BOUNDS];
    _adView.autoScroll = YES;
    _adView.delegate = self;
//    _adView.contentMode
    _adView.placeholderImage = [UIImage imageNamed:@"launch.jpg"];
    _adView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
    [_adView disableScrollGesture];
//     [self.view addSubview:_adView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:) name:@"ADDATA" object:nil];
    
    _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, G_STATUSBAR_HEIGHT+12, 80, 30)];
    _skipBtn.layer.cornerRadius = 15;
    _skipBtn.backgroundColor = LightGrayColor;
    _skipBtn.alpha = 0.7;
    [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    _skipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_skipBtn addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_skipBtn];

    
    
//    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/banners/advertising" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
//
//        if ([[[result valueForKey:@"code"] stringValue] isEqualToString:@"0"])
//        {
//            NSArray *array = result[@"data"];
//            _dataArray = [[NSMutableArray alloc] initWithArray:array];
//            if (_dataArray.count > 0)
//            {
//                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
//                [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//                NSMutableArray *imageURL = [NSMutableArray arrayWithCapacity:_dataArray.count];
//                for (NSDictionary *dic in _dataArray)
//                {
//                    [imageURL addObject:dic[@"src"]];
//                }
//                _adView.imageURLStringsGroup = imageURL;
//                _adView.autoScrollTimeInterval = 5.0;
//                _count = _dataArray.count*5+1;
//                [_timer fire];
//
////                [SDWebImageManager sharedManager]
//            }
//            else
//            {
//                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                app.window.rootViewController = app.tabbar;
//            }
//        }
//
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
}

- (void)reloadData:(NSNotification *)notification
{

    [self.view addSubview:_adView];
    [self.view addSubview:_skipBtn];
    
    NSArray *array = notification.object;
    _dataArray = array;
    if (_dataArray.count > 0)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        NSMutableArray *imageURL = [NSMutableArray arrayWithCapacity:_dataArray.count];
        for (NSDictionary *dic in _dataArray)
        {
            [imageURL addObject:[self imageFromSdcache:dic[@"src"]]];
        }
        //        _adView.imageURLStringsGroup = imageURL;
        _adView.localizationImageNamesGroup = imageURL;
        _adView.autoScrollTimeInterval = 5.0;
        _count = _dataArray.count*5+1;
        [_timer fire];
    }
    else
    {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.window.rootViewController = app.tabbar;
    }
}

-(UIImage*)imageFromSdcache:(NSString *)url
{
    
    NSData*imageData =nil;
    __block BOOL isExit;
    [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:url] completion:^(BOOL isInCache) {
        isExit = isInCache;
        
    }];
    
    if(isExit)
    {
        NSString*cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
        if(cacheImageKey.length)
        {
            NSString*cacheImagePath = [[SDImageCache sharedImageCache]defaultCachePathForKey:cacheImageKey];
            if(cacheImagePath.length)
            {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if(!imageData)
    {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    }
    UIImage*image = [UIImage imageWithData:imageData];
    
    return image;
    
}


- (void)timeAction
{
    _count--;
    if (_count == 0)
    {
        [_timer invalidate];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.window.rootViewController = app.tabbar;
        return;
    }
    [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%lis", (long)_count] forState:UIControlStateNormal];
}

- (void)skipAD
{
    [_timer invalidate];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = app.tabbar;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *bannerDic = _dataArray[index];
    
    if ([bannerDic[@"link"] isKindOfClass:[NSNull class]] || [bannerDic[@"link"] isEqualToString:@""])
    {
        return;
    }
   
    H5ViewController *vc = [[H5ViewController alloc] init];
    NSString *urlString = bannerDic[@"link"];
    
//    NSString *testUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
//    {
//        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"] isKindOfClass:[NSString class]])
//        {
//            urlString = [NSString stringWithFormat:@"%@/m/user/appRedirect?sessionId=%@&ref=%@",testUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"],[NSString stringWithFormat:@"%@",bannerDic[@"showData"]]];
//        }
//        else
//            return;
//    }
//    else
//    {
//        [SVProgressHUD showErrorWithStatus:@"请先登录"];
//        [SVProgressHUD dismissWithDelay:1.2];
//        return;
//    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = app.tabbar;
    
    vc.urlString = urlString;
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabbar.selectedViewController pushViewController:vc animated:YES];
    

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
