//
//  ActivityMsgCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/29.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "ActivityMsgCell.h"
#import <YYText.h>
#import <Masonry.h>

@interface ActivityMsgCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, strong) UIView *endView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation ActivityMsgCell

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
        
//        381:152
        CGFloat imageHeight = G_SCREEN_WIDTH/381.0*152;
        
        self.contentView.backgroundColor = [UIColor colorFromHexString:@"#EBEBEB"];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, G_SCREEN_WIDTH-30, 100)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 12;
        _bgView.clipsToBounds = YES;
        [self.contentView addSubview:_bgView];
        
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [_bgView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(_bgView);
        }];
        
        _endView = [[UIView alloc] init];
//        _endView.hidden = YES;
        [_bgView addSubview:_endView];
        [_endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(_bgView);
            make.height.mas_equalTo(imageHeight);
        }];
        
        UIView *blackView = [[UIView alloc] init];
        [_endView addSubview:blackView];
        [blackView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_endView);
        }];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.2;
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"已结束"];
        [_endView addSubview:_bgImageView];
        [_bgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_endView);
            make.size.mas_equalTo(CGSizeMake(100, 90));
        }];
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = TitleColor;
        _titleLabel.numberOfLines = 0;
        [_bgView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(_icon.mas_bottom).offset(5);
            make.width.mas_equalTo(G_SCREEN_WIDTH-50);
        }];
        
        _subLabel = [[UILabel alloc] init];
        _subLabel.font = [UIFont systemFontOfSize:13];
        _subLabel.textColor = TextColor;
        _subLabel.numberOfLines = 0;
        _subLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_bgView addSubview:_subLabel];
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
            make.width.mas_equalTo(G_SCREEN_WIDTH-50);
        }];
        
        _timeLabel = [[YYLabel alloc] init];
        _timeLabel.preferredMaxLayoutWidth = 300;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = [UIColor colorFromHexString:@"#DFDFDF"];
        _timeLabel.layer.cornerRadius = 12;
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(24);
            make.centerX.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setModel:(MsgModel *)model
{
    _model = model;
    CGFloat imageHeight = G_SCREEN_WIDTH/381.0*152;
    
    if ([_model.type integerValue] == 3)
    {
        _model.isEnd = NO;
    }
    
    _endView.hidden = YES;
    _bgImageView.hidden = NO;
    
    if (_model.thumbnail && _model.thumbnail.length > 0)
    {
        [_icon sd_setImageWithURL:[NSURL URLWithString:model.thumbnail]];
        
        [_endView updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
        }];
        
        [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
//            make.edges.mas_equalTo(_endView);
        }];
        
        if (_model.isEnd)
        {
            _endView.hidden = NO;
        }
    }
    else
    {
        [_icon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        if (_model.isEnd)
        {
            [_endView updateConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(_bgView);
            }];
            _endView.hidden = NO;
            _bgImageView.hidden = YES;
        }
    }
    
    _titleLabel.text = _model.alert;
    
    _subLabel.text = _model.subtitle;
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_model.titleHight);
    }];
    
    [_subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_model.subTitleHight);
    }];
    
//    CGFloat height = _model.imageHeight + _model.titleHight + _model.subTitleHight + 20;

    [_bgView makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(G_SCREEN_WIDTH-30);
        make.top.mas_equalTo(40);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    _timeLabel.text = _model.time;
    
    
    if (model.isEnd)
    {
        _titleLabel.textColor = LightGrayColor;
        _subLabel.textColor = LightGrayColor;
    }
    else
    {
        _titleLabel.textColor = TitleColor;
        _subLabel.textColor = TextColor;
    }
    
    
    [self layoutIfNeeded];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
