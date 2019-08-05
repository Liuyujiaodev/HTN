//
//  ShopListCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/5.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ShopListCell.h"
#import <Masonry.h>

@interface ShopListCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;

@end

@implementation ShopListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = TitleColor;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_nameLabel];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = LineColor;
        [self.contentView addSubview:_bgView];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
//            make.height.mas_greaterThanOrEqualTo(1);
        }];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).mas_offset(15);
            make.left.equalTo(@15);
            make.right.mas_equalTo(self.contentView).offset(-15);
            make.bottom.mas_equalTo(self.contentView).offset(-15);
        }];
    
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneLabel.font = [UIFont systemFontOfSize:13];
        _phoneLabel.numberOfLines = 0;
        _phoneLabel.textColor = TextColor;
        [_bgView addSubview:_phoneLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = TextColor;
        _addressLabel.numberOfLines = 0;
        [_bgView addSubview:_addressLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = TextColor;
        _timeLabel.numberOfLines = 0;
        [_bgView addSubview:_timeLabel];
        
        _imageView1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView1.image = [UIImage imageNamed:@"电话"];
        [_bgView addSubview:_imageView1];
        
        _imageView2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView2.image = [UIImage imageNamed:@"位置"];
        [_bgView addSubview:_imageView2];
        
        _imageView3 = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView3.image = [UIImage imageNamed:@"时间"];
        [_bgView addSubview:_imageView3];
        
        
        
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView).offset(35);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(_bgView).offset(-10);
//            make.height.mas_greaterThanOrEqualTo(25);
        }];
//
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView).offset(35);
            make.top.mas_equalTo(_phoneLabel.mas_bottom).offset(10);
            make.right.mas_equalTo(_bgView).offset(-10);
//            make.height.mas_greaterThanOrEqualTo(25);
        }];
//
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView).offset(35);
            make.top.mas_equalTo(_addressLabel.bottom).offset(10);
            make.right.mas_equalTo(_bgView).offset(-10);
            make.bottom.mas_equalTo(_bgView).offset(-10);
//            make.height.mas_greaterThanOrEqualTo(25);
        }];
        
        [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView).offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
//            make.centerY.mas_equalTo(_phoneLabel);
        }];

        [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView).offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
//            make.centerY.mas_equalTo(_addressLabel);
        }];

        [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView).offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
    }
    return self;
}

- (void)setModel:(ShopModel *)model
{
    _model = model;
    
    _nameLabel.text = _model.name;
    
    if (_model.phone && _model.phone.length > 0)
    {
        _phoneLabel.text = _model.phone;
        _imageView1.hidden = NO;
    }
    else
    {
        _phoneLabel.text = @"";
        _imageView1.hidden = YES;
    }
    
    if (_model.address && _model.address.length > 0)
    {
        _imageView2.hidden = NO;
        _addressLabel.text = _model.address;
    }
    else
    {
        _addressLabel.text = @"";
        _imageView2.hidden = YES;
    }
    
    if (_model.time && _model.time.length > 0)
    {
        _imageView3.hidden = NO;
        _timeLabel.text = _model.time;
    }
    else
    {
        _imageView3.hidden = YES;
        _timeLabel.text = @"";
    }
    
    [_imageView1 updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_phoneLabel);
    }];

    [_imageView2 updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addressLabel);
    }];

    [_imageView3 updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeLabel);
    }];
    
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
