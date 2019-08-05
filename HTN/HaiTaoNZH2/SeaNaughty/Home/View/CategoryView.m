//
//  CategoryView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/30.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CategoryView.h"
#import <Masonry.h>

@interface CategoryView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.cornerRadius = 23;
        bgView.backgroundColor = RGBCOLOR(241, 241, 241);
        [self addSubview:bgView];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorFromHexString:@"#666666"];
        [self addSubview:_titleLabel];
        
        [_imageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@24);
            make.height.mas_equalTo(@24);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-10);
            
        }];
        
        [bgView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@46);
            make.height.mas_equalTo(@46);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-10);
        }];
        
        [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.bottom.equalTo(self).offset(-5);
            make.height.mas_equalTo(@20);
            make.left.equalTo(self);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)setImageName:(NSString *)imageName
{
    _imageView.image = [UIImage imageNamed:imageName];
}



@end
