//
//  ThirdOrderCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/15.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ThirdOrderCell.h"



@interface ThirdOrderCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *secondPriceLabel;
@property (nonatomic, strong) UILabel *postageLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *skuLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation ThirdOrderCell

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
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 60, 70)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, G_SCREEN_WIDTH-155, 20)];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TitleColor;
        [self.contentView addSubview:_nameLabel];
        
        
        
        _skuLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 35,  G_SCREEN_WIDTH-155, 15)];
        _skuLabel.font = [UIFont systemFontOfSize:11];
        _skuLabel.textColor = LightGrayColor;
        [self.contentView addSubview:_skuLabel];
        
        
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, G_SCREEN_WIDTH-155, 15)];
        _priceLabel.textColor = MainColor;
        _priceLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, 15, 85, 15)];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textColor = TitleColor;
        [self.contentView addSubview:_numLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setModel:(ProductModel *)model
{
    _model = model;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl]];
    
    
    _nameLabel.text = _model.name;
    
    _skuLabel.text = [NSString stringWithFormat:@"sku:%@",  _model.sku];
    
    
   
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_model.firstCurrencyName,[self moneyWithString:_model.firstPrice],_model.secondCurrencyName,[self moneyWithString:_model.secondPrice]];
    
    
    _numLabel.text = [NSString stringWithFormat:@"X %@",_model.orderedQty];
    
}

- (NSString *)moneyWithString:(NSString *)str
{
    CGFloat price = [str floatValue];
    if (str.length > 8)
    {
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        str = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    return str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

