//
//  FourthFeeCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/16.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "FourthFeeCell.h"

@interface FourthFeeCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation FourthFeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        _leftLabel.textColor = TextColor;
        [self.contentView addSubview:_leftLabel];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 0, 300, 40)];
        _rightLabel.font = [UIFont systemFontOfSize:12];
        _rightLabel.textColor = TextColor;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 39, G_SCREEN_WIDTH-30, 1)];
        _lineView.backgroundColor = LineColor;
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)setFeeDictionary:(NSDictionary *)feeDictionary
{
    _feeDictionary = feeDictionary;
    
    if ([_feeDictionary[@"name"] isEqualToString:@"实付"] || [_feeDictionary[@"name"] isEqualToString:@"待付"] || [_feeDictionary[@"name"] isEqualToString:@"支付方式"])
    {
        _lineView.hidden = YES;
    }
    else
    {
        _lineView.hidden = NO;
    }
    
    if ([_feeDictionary[@"name"] isEqualToString:@"商品合计"])
    {
        _leftLabel.textColor = TitleColor;
        _rightLabel.textColor = MainColor;
    }
    else
    {
        _leftLabel.textColor = TextColor;
        _rightLabel.textColor = TextColor;
    }
    
    _leftLabel.text = _feeDictionary[@"name"];
    _rightLabel.text = _feeDictionary[@"fee"];
    
    
    if ([_feeDictionary[@"fee"] isEqualToString:@"免单"])
    {
        _leftLabel.text = @"实付";
        _rightLabel.textColor = [UIColor redColor];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
