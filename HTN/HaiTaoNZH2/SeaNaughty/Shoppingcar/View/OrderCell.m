//
//  OrderCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *secondPriceLabel;
@property (nonatomic, strong) UILabel *postageLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *skuLabel;
@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation OrderCell

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
        
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 100)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, G_SCREEN_WIDTH-145, 30)];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TitleColor;
        [self.contentView addSubview:_nameLabel];
        
        
        _postageLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, G_SCREEN_WIDTH-145, 15)];
        _postageLabel.textColor = TextColor;
        _postageLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_postageLabel];
        
        _skuLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 55,  G_SCREEN_WIDTH-145, 15)];
        _skuLabel.font = [UIFont systemFontOfSize:11];
        _skuLabel.textColor = LightGrayColor;
        [self.contentView addSubview:_skuLabel];
        
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 70, G_SCREEN_WIDTH-145, 15)];
        _weightLabel.font = [UIFont systemFontOfSize:11];
        _weightLabel.textColor = LightGrayColor;
        [self.contentView addSubview:_weightLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 85, G_SCREEN_WIDTH-145, 15)];
        _priceLabel.textColor = MainColor;
        _priceLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, 15, 85, 15)];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textColor = TitleColor;
        [self.contentView addSubview:_numLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119, G_SCREEN_WIDTH, 1)];
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
    
    _skuLabel.text = _model.sku;
    _weightLabel.text = [NSString stringWithFormat:@"重量:%@g",_model.weight];
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_model.firstCurrencyName,[self moneyWithString:_model.firstPrice],_model.secondCurrencyName,[self moneyWithString:_model.secondPrice]];
    
    if ([_model.weight isEqualToString:@"0"])
    {
        _weightLabel.text = @"";
    }
    
    if (_model.freePostage)
    {
        NSDictionary *freePostage = _model.freePostage;
        
        NSString *freePos = [NSString stringWithFormat:@"满%@%@/%@ %@包邮",freePostage[@"firstCurrencyName"],[self moneyWithString:freePostage[@"firstThreshold"]],freePostage[@"secondCurrencyName"],[self moneyWithString:freePostage[@"secondThreshold"]]];
        _postageLabel.text = freePos;
    }
    else
    {
        _postageLabel.text = @"";
    }
    
     _numLabel.text = [NSString stringWithFormat:@"X %@",_model.quantity];
    
   if ([_model.buyFree isEqualToString:@"1"])
    {
#pragma mark - 满赠商品
//        _numLabel.text = _model.quantity;
        _priceLabel.text = @"直邮价 0";
    }
//    else
//    {
//#pragma mark - 普通商品
//        _numLabel.text = @"";
//    }
    
}

- (NSString *)moneyWithString:(NSString *)str
{
    CGFloat price = [str floatValue];
    if (str.length > 6)
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
