//
//  AlertView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/2.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()

@property (nonatomic, strong) UIImageView *shadowView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *codeImageView;

@end

@implementation AlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self addSubview:self.shadowView];
        [self.codeImageView addSubview:self.btn];
        [self addSubview:self.codeImageView];
        self.codeImageView.clipsToBounds = YES;
        self.codeImageView.layer.cornerRadius = 10;
    }
    return self;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGPoint pointt = [self convertPoint:point toView:self.codeImageView];
//    if ([self.codeImageView pointInside:pointt withEvent:event])
//    {
//        return ;
//    }
//}


- (void)hideAlert
{
    self.hidden = YES;
}


- (UIImageView *)shadowView
{
    if (!_shadowView)
    {
        _shadowView = [[UIImageView alloc] initWithFrame:G_SCREEN_BOUNDS];
        _shadowView.userInteractionEnabled = YES;
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(hideAlert)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (UIButton *)btn
{
    if (!_btn)
    {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 206, G_SCREEN_WIDTH-50, 44)];
        _btn.backgroundColor = MainColor;
        [_btn setTitle:@"ok" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.clipsToBounds = YES;
        [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _btn;
}

- (void)btnAction
{
    self.hidden = YES;
}

- (UIView *)codeImageView
{
    if (!_codeImageView)
    {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 200, G_SCREEN_WIDTH-50, 250)];
        
        _codeImageView.backgroundColor = [UIColor whiteColor];
        _codeImageView.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, G_SCREEN_WIDTH-50, 20)];
        label.text = @"联系客服";
        label.textColor = TitleColor;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [_codeImageView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((G_SCREEN_WIDTH/2-85), 50, 120, 120)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"QRCODE"]]];
        [_codeImageView addSubview:imageView];
        
    }
    return _codeImageView;
}


@end
