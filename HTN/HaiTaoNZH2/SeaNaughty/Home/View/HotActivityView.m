//
//  HotActivityView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/29.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "HotActivityView.h"

@interface HotActivityView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *qukankanImageView;
@property (nonatomic, strong) UIButton *goBtn;

@end

@implementation HotActivityView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height*2/5.0, frame.size.width/2, frame.size.height*3/5.0)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, 8, frame.size.width/2, frame.size.height-16)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 15)];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = TitleColor;
        [self addSubview:_label];
        
        _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 200, 15)];
        _subLabel.font = [UIFont systemFontOfSize:13];
//        _subLabel.textColor = LightGrayColor;
        [self addSubview:_subLabel];
        
//        _qukankanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 57, 50, 20)];
//        _qukankanImageView.image = [UIImage imageNamed:@"icon-qukankan"];
//        [self addSubview:_qukankanImageView];
//        _qukankanImageView.hidden = YES;
        
        _goBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 57, 50, 20)];
        [_goBtn setTitle:@"GO>" forState:UIControlStateNormal];
        [_goBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _goBtn.enabled = NO;
        _goBtn.hidden = YES;
        _goBtn.layer.cornerRadius = 10;
        [self addSubview:_goBtn];
        
//        self.backgroundColor = [UIColor darkGrayColor];
//        self.userInteractionEnabled = YES;
//        _imageView.userInteractionEnabled = YES;
//        _qukankanImageView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _label.text = title;
    if (title.length>0)
    {
        _goBtn.hidden = NO;
    }
    
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subLabel.text = subTitle;
}

- (void)setSubTitleColor:(UIColor *)subTitleColor
{
    _subLabel.textColor = subTitleColor;
    _goBtn.backgroundColor = subTitleColor;
}

- (void)setImageName:(NSString *)imageName
{
    _imageView.image = [UIImage imageNamed:imageName];
    
    if ([imageName isEqualToString:@"3"])
    {
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, frame.size.height*2/5.0, frame.size.width/2, frame.size.height*3/5.0)];
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, 8, frame.size.width/2, frame.size.height-16)];
        _imageView.frame = CGRectMake(20, self.frame.size.height*2/5.0, self.frame.size.width-40, self.frame.size.height*3/5.0);
    }
    
}

- (void)setBgColor:(UIColor *)bgColor
{
    _imageView.backgroundColor = bgColor;
}




@end
