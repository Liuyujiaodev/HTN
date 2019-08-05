//
//  RankBtnView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "RankBtnView.h"

@interface RankBtnView ()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) NSString *tempBtn;
@property (nonatomic, strong) NSMutableDictionary *param;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) NSArray *scArray;

@end


@implementation RankBtnView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scArray = @[@"asc",@"desc"];
        CGFloat width = (frame.size.width-20)/4;
        CGFloat height = frame.size.height;
        
        _btn1 = [self btnWithFrame:CGRectMake(10, 0, width, height) title:@"综合"];
        _btn2 = [self btnWithFrame:CGRectMake(10+width, 0, width, height) title:@"价格"];
        _btn3 = [self btnWithFrame:CGRectMake(10+2*width, 0, width, height) title:@"销量"];
        _btn4 = [self btnWithFrame:CGRectMake(10+3*width, 0, width, height) title:@"新品上架"];
        
        
        [_btn2 setImage:[UIImage imageNamed:@"price-default"] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"time-default"] forState:UIControlStateNormal];
        [_btn3 setImage:[UIImage imageNamed:@"time-bottom"] forState:UIControlStateSelected];
        [_btn4 setImage:[UIImage imageNamed:@"time-default"] forState:UIControlStateNormal];
        [_btn4 setImage:[UIImage imageNamed:@"time-bottom"] forState:UIControlStateSelected];
        
        [_btn1 addTarget:self action:@selector(btnClicked1) forControlEvents:UIControlEventTouchUpInside];
        [_btn2 addTarget:self action:@selector(btnClicked2) forControlEvents:UIControlEventTouchUpInside];
        [_btn3 addTarget:self action:@selector(btnClicked3) forControlEvents:UIControlEventTouchUpInside];
        [_btn4 addTarget:self action:@selector(btnClicked4) forControlEvents:UIControlEventTouchUpInside];
        
        _tempBtn = @"综合";
        _param = [[NSMutableDictionary alloc] init];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, frame.size.height-2, frame.size.width-30, 1.5)];
        lineView.backgroundColor = LineColor;
        [self addSubview:lineView];
        
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 1, frame.size.width-30, 1.5)];
        _topLineView.backgroundColor = LineColor;
        _topLineView.hidden = YES;
        [self addSubview:_topLineView];
    }
    return self;
}

- (void)setFontSize:(CGFloat)fontSize
{
    for (id tempView in self.subviews)
    {
        if ([tempView isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)tempView;
            btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        }
    }
}

- (void)setShowTopline:(BOOL)showTopline
{
    _showTopline = showTopline;
    _topLineView.hidden = !_showTopline;
}

- (void)btnClicked1
{
    _btn2.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = NO;
    _btn1.selected = YES;
    [_btn2 setImage:[UIImage imageNamed:@"price-default"] forState:UIControlStateNormal];
    
    [_param setObject:@"" forKey:@"orderField"];
    
    [_param setObject:@"" forKey:@"orderRule"];
    [self sendParam];
}

- (void)btnClicked2
{
    _btn1.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = NO;
    _btn2.selected = !_btn2.selected;
    
    NSArray *array = @[@"price-top",@"price-bottom"];
    [_btn2 setImage:[UIImage imageNamed:array[_btn2.selected]] forState:UIControlStateNormal];
    
    [_param setObject:@"price" forKey:@"orderField"];
    
    [_param setObject:_scArray[_btn2.selected] forKey:@"orderRule"];
    
    [self sendParam];
}

- (void)btnClicked3
{
    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn4.selected = NO;
    _btn3.selected = YES;
    
    [_btn2 setImage:[UIImage imageNamed:@"price-default"] forState:UIControlStateNormal];
    
    [_param setObject:@"sales" forKey:@"orderField"];
    
    [_param setObject:@"desc" forKey:@"orderRule"];
    [self sendParam];
}

- (void)btnClicked4
{
    _btn1.selected = NO;
    _btn2.selected = NO;
    _btn3.selected = NO;
    _btn4.selected = YES;
    
    [_btn2 setImage:[UIImage imageNamed:@"price-default"] forState:UIControlStateNormal];
    
    [_param setObject:@"createTime" forKey:@"orderField"];
    
    [_param setObject:@"desc" forKey:@"orderRule"];
    [self sendParam];
}

- (void)sendParam
{
    if (_delegate && [_delegate respondsToSelector:@selector(rankBtnViewWithParam:)])
    {
        [_delegate rankBtnViewWithParam:(NSDictionary *)_param];
    }
}


- (UIButton *)btnWithFrame:(CGRect)frame title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexString:@"#666666"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 20);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, frame.size.width/2+4, 0, 0);
//    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -btn.imageView.frame.size.width - btn.frame.size.width + btn.titleLabel.frame.size.width, 0, 0);
//
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -btn.titleLabel.frame.size.width - btn.frame.size.width + btn.imageView.frame.size.width);
    [self addSubview:btn];
    return btn;
}

- (void)setDictionary:(NSDictionary *)dictionary
{
    _dictionary = dictionary;
    
    if (_dictionary.allValues.count>0)
    {
        NSString *str1 = [_dictionary valueForKey:@"orderField"];
        NSString *str2 = [_dictionary valueForKey:@"orderRule"];
//        desc
        BOOL selected = NO;
        if ([str2 isEqualToString:@"desc"])
        {
            selected = YES;
        }
        
        if ([str1 isEqualToString:@"createTime"])
        {
            _btn4.selected = NO;
            [self btnClicked4];
        }
        else if ([str1 isEqualToString:@"sales"])
        {
            _btn3.selected = NO;
            [self btnClicked3];
        }
        else if ([str1 isEqualToString:@"price"])
        {
            _btn2.selected = selected;
            [self btnClicked2];
        }
        else
        {
            _btn1.selected = NO;
            [self btnClicked1];
        }
    }
}

@end
