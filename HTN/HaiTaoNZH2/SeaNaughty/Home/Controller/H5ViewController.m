//
//  H5ViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/2/21.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "H5ViewController.h"
#import <WebKit/WebKit.h>
#import "InfoViewController.h"
#import "ProductDetailViewController.h"
#import "ShoppingCarViewController.h"
#import "IndexListViewController.h"
#import "ListShopViewController.h"


@interface H5ViewController () <WKNavigationDelegate,WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation H5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
   
    NSString *url = [[NSString stringWithFormat:@"%@", self.urlString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
   
    
//    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'height=device-height'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
//    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//    [wkUController addUserScript:wkUScript];
    
//    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//    wkWebConfig.userContentController = wkUController;
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
    [userContentController addScriptMessageHandler:self name:@"iOS"];
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES;
    
    _webView = [[WKWebView alloc] initWithFrame:G_SCREEN_BOUNDS configuration:configuration];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    
     [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    NSString * pathString = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathString]]];
//
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud showAnimated:YES];
    
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_hud hideAnimated:YES];
}


- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ? : @"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text ? : @"");
    }];
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}


#pragma mark - 回调
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
//    js回调接口
//    分类  toGoodsCategory
//    购物车 toShoppingCar
//    个人中心  toUserCenter
//    商品详情  toGoodsDetail     参数 字符串id
//    搜索结果  toFilterProducts   参数  字符串keyword   整数列表shops
//    活动列表   toActiveProducts   参数 字符串activeId
    
    if([message.name isEqualToString:@"iOS"])
    {
        NSDictionary *bodyDic = message.body;
        NSString *func = [bodyDic valueForKey:@"func"];
        NSDictionary *param;
        if ([bodyDic.allKeys containsObject:@"param"])
        {
            param = [bodyDic valueForKey:@"param"];
        }
        
        
        if ([func isEqualToString:@"toUserCenter"])
        {
            InfoViewController *vc = [InfoViewController new];
            vc.isFromMessage = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([func isEqualToString:@"toGoodsDetail"])
        {
            ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
            vc.isFromMessage = YES;
            vc.productId = [param valueForKey:@"productId"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([func isEqualToString:@"toShoppingCar"])
        {
//            ShoppingCarViewController *vc = [[ShoppingCarViewController alloc] init];
//            vc.isSecond = YES;
//            vc.isFromMessage = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.tabbar.selectedIndex = 2;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([func isEqualToString:@"toGoodsCategory"])
        {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.tabbar.selectedIndex = 1;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if ([func isEqualToString:@"toActiveProducts"])
        {
//            NSString *activityId = [param valueForKey:@"activityId"];
            NSNumber *activityId = [NSNumber numberWithInteger:0];
            activityId = [param valueForKey:@"activityId"];
//            if (activityId.length == 0)
//            {
//                return;
//            }
            
            [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/activities/detail" parameters:@{@"id":activityId} success:^(NSURLSessionDataTask *task, id result) {
                
                if ([[[result valueForKey:@"code"] stringValue] isEqualToString:@"0"])
                {
                    ActivityModel *model = [ActivityModel yy_modelWithDictionary:result[@"data"]];
                    IndexListViewController *vc = [[IndexListViewController alloc] init];
                    vc.model = model;
                    vc.isFromMessage = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            } fail:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }
        else if ([func isEqualToString:@"toFilterProducts"])
        {
            ListShopViewController *vc = [[ListShopViewController alloc] init];
            vc.searchString = [param valueForKey:@"keyword"];
            vc.shopArray = [param valueForKey:@"shopId"];
            vc.isFromMessage = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}


- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}


@end
