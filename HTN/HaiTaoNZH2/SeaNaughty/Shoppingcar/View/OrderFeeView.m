//
//  OrderFeeView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OrderFeeView.h"




@interface OrderFeeView ()

@property (nonatomic, strong) UILabel *postageLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@end

@implementation OrderFeeView



- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 70)];
    if (self)
    {
        self.backgroundColor = [UIColor colorFromHexString:@"#FCFBF9"];
        NSArray *array = @[@"运费:",@"合计 (含运费):",@"实付:"];
        for (int i=0; i<3; i++)
        {
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 6+20*i, 200, 20)];
            leftLabel.text = array[i];
            leftLabel.font = [UIFont systemFontOfSize:12];
            leftLabel.textColor = TextColor;
            [self addSubview:leftLabel];
            
            UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 6+20*i, 300, 20)];
            rightLabel.textColor = TextColor;
            rightLabel.textAlignment = NSTextAlignmentRight;
            rightLabel.font = [UIFont systemFontOfSize:12];
            rightLabel.tag = 300+i;
            [self addSubview:rightLabel];
            if (i==0)
            {
                rightLabel.frame = CGRectMake(G_SCREEN_WIDTH-333, 6, 300, 20);
            }
            if (i==2)
            {
                rightLabel.textColor = MainColor;
            }
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-30, 8, 14, 14)];
        [btn setImage:[UIImage imageNamed:@"q-icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _postageLabel = [self viewWithTag:300];
        _discountLabel = [self viewWithTag:301];
        _totalLabel = [self viewWithTag:302];
    }
    return self;
}

- (void)setModel:(CartAllModel *)model
{
    _model = model;
    
    if (!_model.firstCurrencyName || _model.firstCurrencyName.length == 0)
    {
        _model.firstCurrencyName = @"NZD $";
        _model.secondCurrencyName = @"¥";
    }
    
    NSDictionary *dic = _model.common;
    NSString *postage = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [dic valueForKey:@"firstShippingFee"],_model.secondCurrencyName,[dic valueForKey:@"secondShippingFee"]];
    _postageLabel.text = postage;
    
//    NSString *discount = [NSString stringWithFormat:@"-%@ %@/%@ %@", _model.firstCurrencyName, [dic valueForKey:@"firstDiscountAmount"],_model.secondCurrencyName,[dic valueForKey:@"secondDiscountAmount"]];
//    _discountLabel.text = discount;
    
    NSString *total = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [dic valueForKey:@"firstTotalAmount"],_model.secondCurrencyName,[dic valueForKey:@"secondTotalAmount"]];
    _totalLabel.text = total;
    _discountLabel.text = total;
}

- (void)setCartModel:(CartModel *)cartModel
{
    _cartModel = cartModel;
    
    if (!_cartModel.firstCurrencyName || _cartModel.firstCurrencyName.length == 0)
    {
        _cartModel.firstCurrencyName = @"NZD $";
        _cartModel.secondCurrencyName = @"¥";
    }
    
    NSDictionary *dic = _cartModel.common;
    NSString *postage = [NSString stringWithFormat:@"%@ %@/%@ %@", _cartModel.firstCurrencyName, [self moneyWithString:[dic valueForKey:@"firstShippingFee"]],_cartModel.secondCurrencyName,[self moneyWithString:[dic valueForKey:@"secondShippingFee"]]];
    _postageLabel.text = postage;
    
    NSString *discount = [NSString stringWithFormat:@"-%@ %@/%@ %@", _cartModel.firstCurrencyName, [self moneyWithString:[dic valueForKey:@"firstDiscountAmount"]],_cartModel.secondCurrencyName,[self moneyWithString:[dic valueForKey:@"secondDiscountAmount"]]];
    _discountLabel.text = discount;
    
    NSString *total = [NSString stringWithFormat:@"%@ %@/%@ %@", _cartModel.firstCurrencyName, [self moneyWithString:[dic valueForKey:@"firstTotalAmount"]],_cartModel.secondCurrencyName,[self moneyWithString:[dic valueForKey:@"secondTotalAmount"]]];
    _totalLabel.text = total;
}

- (void)detailAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AllTextAlert" object:_model];
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

@end