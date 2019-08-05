//
//  UIView+LLSegmentBar.m
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import "UIView+LLSegmentBar.h"

@implementation UIView (LLSegmentBar)

-(void)setLl_centerX:(CGFloat)ll_centerX {
    CGPoint center = self.center;
    center.x = ll_centerX;
    self.center = center;
}

-(CGFloat)ll_centerX {
    return self.center.x;
}

-(void)setLl_centerY:(CGFloat)ll_centerY {
    CGPoint center = self.center;
    center.y = ll_centerY;
    self.center = center;
}

-(CGFloat)ll_centerY {
    return self.center.y;
}


-(CGFloat)ll_x{
    return self.frame.origin.x;
}

-(void)setLl_x:(CGFloat)ll_x {
    CGRect temp = self.frame;
    temp.origin.x = ll_x;
    self.frame = temp;
}

-(CGFloat)ll_y{
    return self.frame.origin.y;
}


-(void)setLl_y:(CGFloat)ll_y {
    CGRect temp = self.frame;
    temp.origin.y = ll_y;
    self.frame = temp;
}




-(CGFloat)ll_width{
    return self.frame.size.width;
}

-(void)setLl_width:(CGFloat)ll_width {
    CGRect temp = self.frame;
    temp.size.width = ll_width;
    self.frame = temp;
}


-(CGFloat)ll_height{
    return self.frame.size.height;
}

-(void)setLl_height:(CGFloat)ll_height {
    CGRect temp = self.frame;
    temp.size.height = ll_height;
    self.frame = temp;
}


@end
