//
//  MineTableViewCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "MineTableViewCell.h"


@interface MineTableViewCell ()

@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UILabel *updateLabel;

@end

@implementation MineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 24, 24)];
        [self.contentView addSubview:_leftLogo];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 300, 24)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TitleColor;
        [self.contentView addSubview:_titleLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 0.8)];
        _lineView.backgroundColor = LineColor;
        [self.contentView addSubview:_lineView];
        
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-20, 17, 6, 10)];
        _rightImage.image = [UIImage imageNamed:@"right-arrow"];
        [self.contentView addSubview:_rightImage];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-120, 10, 110, 24)];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = TitleColor;
        _detailLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_detailLabel];
        
        _updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 100, 24)];
        _updateLabel.font = [UIFont systemFontOfSize:12];
        _updateLabel.textColor = [UIColor redColor];
//        _updateLabel.textAlignment = NSTextAlignmentRight;
        _updateLabel.text = @"(点击去更新)";
        [self.contentView addSubview:_updateLabel];
        
    }
    
    return self;
}

- (void)setShowUpdate:(BOOL)showUpdate
{
    _showUpdate = showUpdate;
    if (_showUpdate) {
        _updateLabel.hidden = NO;
    }else {
        _updateLabel.hidden = YES;
    }
}

- (void)setHideArrow:(BOOL)hideArrow
{
    _hideArrow = hideArrow;
    if (_hideArrow)
    {
        _rightImage.hidden = YES;
    }
    else
        _rightImage.hidden = NO;
}

//- (void)setLeftLogo:(UIImageView *)leftLogo
//{
//    UIImage *image = [UIImage imageNamed:@"image.jpg"];
//    // Begin a new image that will be the new image with the rounded corners
//    // (here with the size of an UIImageView)
//    UIGraphicsBeginImageContextWithOptions(_leftLogo.bounds.size, NO, [UIScreen mainScreen].scale);
//    // Add a clip before drawing anything, in the shape of an rounded rect
//    [[UIBezierPath bezierPathWithRoundedRect:_leftLogo.bounds cornerRadius:10.0] addClip];
//    // Draw your image
//    [image drawInRect:_leftLogo.bounds];
//    // Get the image, here setting the UIImageView image
//    _leftLogo.image = UIGraphicsGetImageFromCurrentImageContext();
//    // Lets forget about that we were drawing
//    UIGraphicsEndImageContext();
//}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
