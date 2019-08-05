//
//  VoucherCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/29.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "VoucherCell.h"

@interface VoucherCell ()

@property (nonatomic, strong) UILabel *voucherLabel;

@end

@implementation VoucherCell

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
        _voucherLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 35)];
        _voucherLabel.font = [UIFont systemFontOfSize:10];
        _voucherLabel.textColor = LightGrayColor;
        self.contentView.backgroundColor = [UIColor colorFromHexString:@"#FFFDF3"];
        [self.contentView addSubview:_voucherLabel];
    }
    return self;
}

- (void)setModel:(CartModel *)model
{
    _model = model;
    NSDictionary *dic = _model.common;
    
    NSString *firstDiscountAmount = dic[@"firstDiscountAmount"];
    
    if ([firstDiscountAmount isEqualToString:@"0"]) {
        _voucherLabel.text = @"选择优惠券 >";
    }
    else
    {
        _voucherLabel.text = [NSString stringWithFormat:@"使用优惠(已使用推荐组合)【优惠%@%@/%@%@】 选择其他 >", _model.firstCurrencyName, [self moneyWithString:firstDiscountAmount], _model.secondCurrencyName, [self moneyWithString:dic[@"secondDiscountAmount"]]];
    }
    
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
