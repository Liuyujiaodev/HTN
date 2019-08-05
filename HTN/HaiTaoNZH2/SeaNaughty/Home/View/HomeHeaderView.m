//
//  HomeHeaderView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "HomeHeaderView.h"

@interface HomeHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation HomeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 50)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 13, 18)];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 15, G_SCREEN_WIDTH-90, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
    
    self.rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-20, 20, 6, 10)];
    self.rightImage.image = [UIImage imageNamed:@"right-arrow"];
    [self addSubview:self.rightImage];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 50)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

- (void)updateTitle:(NSString *)title imageName:(NSString *)imageName needHiddenRight:(BOOL)hidden
{
    self.titleLabel.text = title;
    if (!imageName)
    {
        self.titleLabel.frame = CGRectMake(15, 15, 100, 20);
        self.imageView.hidden = YES;
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:imageName];
    }

    self.rightImage.hidden = hidden;
   
}

- (void)setBgColor:(UIColor *)bgColor
{
    self.bgView.backgroundColor = bgColor;
}

- (void)btnClick
{
    if (self.model)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToAllActivity" object:self.model];
    }
    else if ([self.titleLabel.text isEqualToString:@"品牌大全"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToAllBrand" object:nil];
    }
    else if ([self.titleLabel.text isEqualToString:@"限时特价"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToSaleList" object:nil];
    }
}



@end
