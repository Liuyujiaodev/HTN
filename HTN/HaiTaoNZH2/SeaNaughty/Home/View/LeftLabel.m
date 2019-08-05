//
//  LeftLabel.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/8.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "LeftLabel.h"

@interface LeftLabel()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation LeftLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height/2-3, 6, 6)];
        leftView.backgroundColor = [UIColor colorFromHexString:@"#FEE4B5"];
        leftView.layer.cornerRadius = 3;
        [self addSubview:leftView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, frame.size.height/2-8, frame.size.width-10, 16)];
        _textLabel.font = [UIFont systemFontOfSize:11];
        _textLabel.textColor = LightGrayColor;
        
        [self addSubview:_textLabel];
        
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _textLabel.text = _text;
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    _textLabel.frame = CGRectMake(9, self.frame.size.height/2-8, width-10, 16);
}


@end
