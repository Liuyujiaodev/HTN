//
//  AfterSaleViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/5/23.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "AfterSaleViewController.h"
#import <WebKit/WebKit.h>


@interface AfterSaleViewController () <WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation AfterSaleViewController


- (void)viewDidLoad
{
    
    self.title = @"售后细则";
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    
//    [userContentController addScriptMessageHandler:self name:@"iOS"];
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES;
    
    _webView = [[WKWebView alloc] initWithFrame:G_SCREEN_BOUNDS configuration:configuration];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    [self.view addSubview:_webView];
    
    NSString * pathString = [[NSBundle mainBundle] pathForResource:@"shxz" ofType:@"html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pathString]]];
    //
    
//    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>";
//    [self.wkWebView loadHTMLString:[headerString stringByAppendingString:self.detailModel.content] baseURL:nil];
    
  
}

@end
