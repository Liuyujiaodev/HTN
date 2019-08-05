//
//  TagView.m
//  CustomTag
//
//  Created by za4tech on 2017/12/15.
//  Copyright © 2017年 Junior. All rights reserved.
//

#import "TagView.h"
#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
@implementation TagView

-(void)setArr:(NSArray *)arr{
    _arr = arr;
    CGFloat marginX = 2;
    CGFloat marginY = 4;
    CGFloat height = 14;
    UIButton * markBtn;
    for (int i = 0; i < _arr.count; i++) {
        CGFloat width =  [self calculateString:_arr[i] Width:12]+5;
        
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!markBtn) {
            tagBtn.frame = CGRectMake(marginX, marginY, width, height);
        }else{
            CGFloat temp = markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX;
            
            CGFloat tt = self.frame.size.width;
            
            NSLog(@"%f, %f", temp, tt);
            
            if (markBtn.frame.origin.x + markBtn.frame.size.width + marginX + width + marginX > self.frame.size.width) {
                tagBtn.frame = CGRectMake(marginX, markBtn.frame.origin.y + markBtn.frame.size.height + marginY, width, height);
            }else{
                tagBtn.frame = CGRectMake(markBtn.frame.origin.x + markBtn.frame.size.width + marginX, markBtn.frame.origin.y, width, height);
            }
        }
        [tagBtn setTitle:_arr[i] forState:UIControlStateNormal];
        if ([_arr[i] isEqualToString:@"特价"])
        {
            [tagBtn setTitleColor:MainColor forState:UIControlStateNormal];
            tagBtn.backgroundColor = [UIColor colorFromHexString:@"#FFEFD5"];
        }
        else
        {
            [tagBtn setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
            tagBtn.backgroundColor = [UIColor colorFromHexString:@"#F6F6F6"];
        }
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:10];
       
//        [self makeCornerRadius:7 borderColor:[UIColor blackColor] layer:tagBtn.layer borderWidth:.5];
        markBtn = tagBtn;
        
        [tagBtn addTarget:self action:@selector(clickTo:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:markBtn];
    }
    CGRect rect = self.frame;
    rect.size.height = markBtn.frame.origin.y + markBtn.frame.size.height + marginY;
    self.frame = rect;
}


-(void)clickTo:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(handleSelectTag:)]) {
        [self.delegate handleSelectTag:sender.titleLabel.text];
    }
}



//-(void)makeCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor layer:(CALayer *)layer borderWidth:(CGFloat)borderWidth
//{
//    layer.cornerRadius = radius;
//    layer.masksToBounds = YES;
//    layer.borderColor = borderColor.CGColor;
//    layer.borderWidth = borderWidth;
//}

-(CGFloat)calculateString:(NSString *)str Width:(NSInteger)font
{
    CGFloat temp = self.frame.size.width-5;
    CGSize size = [str boundingRectWithSize:CGSizeMake(temp, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
    
    if (str.length > 10)
    {
        return size.width-19.3;
    }
    
    return size.width-5;
}


@end
