//
//  WuliuCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "WuliuCell.h"

@interface WuliuCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation WuliuCell

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
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(60, 87, G_SCREEN_WIDTH-60, 1)];
        _bottomView.backgroundColor = LineColor;
        [self.contentView addSubview:_bottomView];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, G_SCREEN_WIDTH-75, 30)];
        _detailLabel.textColor = TextColor;
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_detailLabel];
        
        
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 60, G_SCREEN_WIDTH-75, 15)];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = LightGrayColor;
        [self.contentView addSubview:_timeLabel];
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 2, 88)];
        _lineView.backgroundColor = LineColor;
        [self.contentView addSubview:_lineView];
        
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 15, 10, 10)];
        _leftImageView.image = [UIImage imageNamed:@"椭圆11"];
        [self.contentView addSubview:_leftImageView];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    
    CGFloat height = [_dataDic[@"context"] boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-75, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height+2;
    _detailLabel.frame = CGRectMake(60, 15, G_SCREEN_WIDTH-75, height);
    
    if (height<45)
    {
        height = 45;
    }
    
    
    _timeLabel.frame = CGRectMake(60, height+15, G_SCREEN_WIDTH-75, 15);
    
    _timeLabel.text = _dataDic[@"ftime"];
    _detailLabel.text = _dataDic[@"context"];
    
}

- (void)setIsFirst:(BOOL)isFirst
{
    _isFirst = isFirst;
    
    if (_isFirst)
    {
        _detailLabel.textColor = MainColor;
       
        _lineView.frame = CGRectMake(20, 20, 2, 68);
        _leftImageView.image = [UIImage imageNamed:@"椭圆22"];
    }
    else
    {
        _detailLabel.textColor = TextColor;
        _lineView.frame = CGRectMake(20, 0, 2, 88);
        _leftImageView.image = [UIImage imageNamed:@"椭圆11"];
    }
    
}

- (void)setIsLast:(BOOL)isLast
{
    _isLast = isLast;
    if (_isLast)
    {
        _lineView.frame = CGRectMake(20, 0, 2, 20);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
