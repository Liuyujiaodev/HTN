//
//  NewsVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/30.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "NewsVC.h"
#import <WebKit/WebKit.h>
#import "InfoViewController.h"
#import "ProductDetailViewController.h"
#import "ShoppingCarViewController.h"
#import "IndexListViewController.h"
#import "ListShopViewController.h"

@interface NewsVC () <WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
//    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    
    
    
//    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
   
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES;
    [userContentController addUserScript:wkUScript];
     [userContentController addScriptMessageHandler:self name:@"iOS"];
//    configuration.userContentController = wkUController;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT) configuration:configuration];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
    
    [_webView loadHTMLString:_news baseURL:nil];
    
    NSLog(@"%@", _news);
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    [_hud showAnimated:YES];
    
//    <p><a href="http://test.aulinkc.com/search/result?keyword=%E7%A5%9E%E4%BB%99%E6%B0%B4&amp;brandId=1000082&amp;brandName=Jurlique%20%E8%8C%B1%E8%8E%89%E8%94%BB" target="_blank">茱莉蔻的神仙水</a><br></p><p>这里有很多茱莉蔻的神仙水，都是新西兰直邮仓的哦</p>
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_hud hideAnimated:YES];
    
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        
        NSString *heightStr = [NSString stringWithFormat:@"%@",any];
        
        CGFloat height = [heightStr floatValue]+10;
        [UIView performWithoutAnimation:^{
            _webView.scrollView.contentSize = CGSizeMake(G_SCREEN_WIDTH, height);
        }];
        
        
    }];
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

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
////    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
////        decisionHandler(WKNavigationActionPolicyAllow);
////    } else {
////        decisionHandler(WKNavigationActionPolicyAllow);
////        NSLog(@"WKNavigationActionPolicyAllow");
////    }
//    decisionHandler(WKNavigationActionPolicyAllow);
//}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    
    if (!navigationAction.targetFrame.isMainFrame) {
        
        NSString *testUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
//        H5ViewController *vc = [[H5ViewController alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@/m/user/appRedirect?sessionId=%@&ref=%@",testUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"],[NSString stringWithFormat:@"%@",[navigationAction.request.URL absoluteString]]];
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }

    
    return nil;
}

@end
