//
//  UIWebView+Finish.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/17.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "UIWebView+Finish.h"

@implementation UIWebView (Finish)

/** 判断webView是否完全加载完数据 */
- (BOOL)isFinishLoading{
    NSString *readyState = [self stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && !self.isLoading) {
        return YES;
    }else{
        return NO;
    }
}


@end
