//
//  FilterView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/26.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "FilterView.h"

@interface FilterView ()

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat width = G_SCREEN_WIDTH/3-30;
        NSArray *array = @[@"品牌", @"分类", @"仓库"];
        _btnArray = [[NSMutableArray alloc] init];
        for (int i=0; i<3; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15*(i*2+1)+width*i, 5, width, 30)];
            
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            [btn setTitleColor:MainColor forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = LineColor;
            btn.layer.cornerRadius = 3;
            btn.tag = 0x100+i;
            [self addSubview:btn];
        }
        _btn1 = [self viewWithTag:0x100];
        _btn2 = [self viewWithTag:0x100+1];
        _btn3 = [self viewWithTag:0x100+2];
    }
    return self;
}

- (void)btnAction:(UIButton *)btn
{
    int tag = (int)btn.tag-0x100;
    
    if (tag == 0)
    {
        _btn2.selected = NO;
        _btn3.selected = NO;
    }
    else if (tag == 1)
    {
        _btn1.selected = NO;
        _btn3.selected = NO;
    }
    else if (tag == 2)
    {
        _btn2.selected = NO;
        _btn1.selected = NO;
    }

    btn.selected = !btn.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIndex:show:)])
    {
        [_delegate selectedIndex:tag show:btn.selected];
    }
    
}

- (void)setHideAll:(BOOL)hideAll
{
    _hideAll = hideAll;
    
    if (_hideAll)
    {
        _btn1.selected = NO;
        _btn2.selected = NO;
        _btn3.selected = NO;
    }
}


@end
