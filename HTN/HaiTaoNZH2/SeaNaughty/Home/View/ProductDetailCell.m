//
//  ProductDetailCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/7.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProductDetailCell.h"
#import "TagView.h"
#import "LeftLabel.h"
#import <YYLabel.h>
#import "H5ViewController.h"

@interface ProductDetailCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) YYLabel *oneWordLabel;
@property (nonatomic, strong) UILabel *firstPriceLabel;
@property (nonatomic, strong) UILabel *secondPriceLabel;
@property (nonatomic, strong) LeftLabel *weightLabel;
@property (nonatomic, strong) TagView *tagView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) LeftLabel *skuLabel;
@property (nonatomic, strong) LeftLabel *stockLabel;
@property (nonatomic, strong) LeftLabel *timeLabel;
@property (nonatomic, strong) LeftLabel *giftLabel;

@end

@implementation ProductDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat width = G_SCREEN_WIDTH;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, width-30, 20)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = TitleColor;
        [self.contentView addSubview:_nameLabel];
        
        
        _oneWordLabel = [[YYLabel alloc] initWithFrame:CGRectMake(15, 40, width-30, 20)];
        _oneWordLabel.textColor = LightGrayColor;
        _oneWordLabel.font = [UIFont systemFontOfSize:12];
        _oneWordLabel.numberOfLines = 0;
        [self.contentView addSubview:_oneWordLabel];
        
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, 200, 20)];
        _alertLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _alertLabel.text = @"价格登录后可见";
        _alertLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_alertLabel];
        
        _firstPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, width, 20)];
        _firstPriceLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        _firstPriceLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_firstPriceLabel];
        
        _secondPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, width, 20)];
        _secondPriceLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _secondPriceLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_secondPriceLabel];

        
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 120, G_SCREEN_WIDTH-30, 50)];
        _bgView.backgroundColor = [UIColor colorFromHexString:@"#FAFAFA"];
        [self.contentView addSubview:_bgView];
        
        _skuLabel = [[LeftLabel alloc] initWithFrame:CGRectMake(15, 5, 220, 20)];
        [_bgView addSubview:_skuLabel];
        
        
        
        _weightLabel = [[LeftLabel alloc] initWithFrame:CGRectMake(215, 10, 120, 20)];
        [_bgView addSubview:_weightLabel];
        
        
        _timeLabel = [[LeftLabel alloc] initWithFrame:CGRectMake(15, 25, 320, 20)];
        [_bgView addSubview:_timeLabel];
        
        _stockLabel = [[LeftLabel alloc] initWithFrame:CGRectMake(105, 10, 120, 20)];
        [_bgView addSubview:_stockLabel];
        
        
        _giftLabel = [[LeftLabel alloc] initWithFrame:CGRectMake(105, 25, 200, 20)];
//        [_bgView addSubview:_giftLabel];
        
        
        
        
    }
    
    return self;
}


- (void)setModel:(ProductModel *)model
{
    _model = model;
    
    _model.shopName = _model.shopName ? _model.shopName : @"";
    
    NSString *nameString = [NSString stringWithFormat:@"【%@】%@",_model.shopName,_model.name];
    
    CGFloat height = [nameString boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height+2;
    _nameLabel.frame = CGRectMake(15, 10, G_SCREEN_WIDTH-30, height);
    _nameLabel.text = nameString;
    
    NSString *oneWord = _model.oneWord;
    CGFloat height1 = [oneWord boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+2;
    _oneWordLabel.frame = CGRectMake(15, 15+height, G_SCREEN_WIDTH-30, height1);
    
    
    if (_model.href && _model.href.length > 0)
    {
        MJWeakSelf;
        
        _oneWordLabel.textColor = [UIColor redColor];
        
        NSMutableAttributedString *oneWordString = [[NSMutableAttributedString alloc] initWithString:oneWord];
        [oneWordString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, oneWord.length)];
        [oneWordString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, oneWord.length)];
        [oneWordString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, oneWord.length)];
        _oneWordLabel.attributedText = oneWordString;
        
        _oneWordLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            
            H5ViewController *vc = [[H5ViewController alloc] init];
            NSString *urlString = weakSelf.model.href;
            
            //            NSString *testUrl = @"http://test.aulinkc.com/m";
            NSString *testUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
            {
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"] isKindOfClass:[NSString class]])
                {
                    urlString = [NSString stringWithFormat:@"%@/m/user/appRedirect?sessionId=%@&ref=%@",testUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"],[NSString stringWithFormat:@"%@",weakSelf.model.href]];
                }
                else
                    return;
            }
            else
            {
//                [SVProgressHUD showErrorWithStatus:@"请先登录"];
//                [SVProgressHUD dismissWithDelay:0.6];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app.tabbar.selectedViewController pushViewController:[LoginViewController new] animated:YES];
//                });
                return;
            }
            
            vc.urlString = urlString;
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:vc animated:YES];
            
        };
    }
    else
    {
        _oneWordLabel.text = oneWord;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        _alertLabel.hidden = YES;
        _firstPriceLabel.hidden = NO;
        _secondPriceLabel.hidden = NO;
    }
    else
    {
        _alertLabel.hidden = NO;
        _firstPriceLabel.hidden = YES;
        _secondPriceLabel.hidden = YES;
    }
    
    _alertLabel.frame = CGRectMake(15, 20+height+height1,200, 20);
    
    if (_model.secondPrice.length > 8)
    {
        float price = [_model.secondPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _model.secondPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    if (_model.firstPrice.length > 8)
    {
        float price = [_model.firstPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _model.firstPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    if (_model.firstOriginalPrice.length > 8)
    {
        float price = [_model.firstOriginalPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _model.firstOriginalPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    if (_model.secondOriginalPrice.length > 8)
    {
        float price = [_model.secondOriginalPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _model.secondOriginalPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    if (_model.firstPrice)
    {
    
        _firstPriceLabel.hidden = NO;
        
        if (!_model.firstOriginalPrice)
        {
            _firstPriceLabel.hidden = YES;
        }
        _firstPriceLabel.frame = CGRectMake(15, 50+height+height1, G_SCREEN_WIDTH-30, 20);
        
        NSString *firstPrice = [NSString stringWithFormat:@"%@ %@/%@ %@",_model.firstCurrencyName,_model.firstOriginalPrice,_model.secondCurrencyName,_model.secondOriginalPrice];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:firstPrice];
        
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, firstPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorFromHexString:@"#999999"] range:NSMakeRange(0, firstPrice.length)];
        
        //        _firstPriceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_model.firstCurrencyName,_model.firstOriginalPrice,_model.secondCurrencyName,_model.secondOriginalPrice];
        _firstPriceLabel.attributedText = attri;
        _secondPriceLabel.frame = CGRectMake(15, 30+height+height1, G_SCREEN_WIDTH-30, 20);
        
        
        if ([_model.shopName isEqualToString:@"中国快快仓"] || [_model.shopName isEqualToString:@"全球精选仓"])
        {
            _secondPriceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_model.firstCurrencyName,_model.firstPrice,_model.secondCurrencyName,_model.secondPrice];
        }
        else
        {
            _secondPriceLabel.text = [NSString stringWithFormat:@"直邮价 %@ %@/%@ %@",_model.firstCurrencyName,_model.firstPrice,_model.secondCurrencyName,_model.secondPrice];
        }
        
        if (_model.firstOriginalPrice == _model.firstPrice)
        {
            _firstPriceLabel.hidden = YES;
        }
        
    }
    
    _bgView.frame = CGRectMake(15, 80+height+height1, G_SCREEN_WIDTH-30, 50);
    
//    _model.sku = @"12580129123138108";
    
    _skuLabel.text = [NSString stringWithFormat:@"sku %@",_model.sku];
    
    CGFloat width1 = [[NSString stringWithFormat:@"sku %@",_model.sku] boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.width+10;
    _skuLabel.width = width1;
    
    _skuLabel.frame = CGRectMake(15, 5, width1, 20);
    CGFloat width2 = 2;
    
    BOOL needChange = NO;
    BOOL skuTooLong = NO;
    
    if (_model.stock)
    {
        _stockLabel.hidden = NO;
        _stockLabel.text = [NSString stringWithFormat:@"库存 %@",_model.stock];
        
        
        
        width2 = [[NSString stringWithFormat:@"库存 %@",_model.stock] boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.width+20;
        
        if (width1 + width2 > G_SCREEN_WIDTH-80)
        {
            skuTooLong = YES;
            _stockLabel.frame = CGRectMake(15, 25, width2, 20);
        }
        else
            _stockLabel.frame = CGRectMake(width1+25, 5, width2, 20);
        
        _stockLabel.width = width2;
    }
    else
    {
        _stockLabel.hidden = YES;
    }
   
    
   
    if (!_model.weight || [_model.weight floatValue] == 0)
    {
        _weightLabel.hidden = YES;
    }
    else
    {
        _weightLabel.hidden = NO;
        _weightLabel.text = [NSString stringWithFormat:@"重量%@g",_model.weight];
        
        if (!skuTooLong)
        {
            if (width1+width2+35 > G_SCREEN_WIDTH-90) {
                needChange = YES;
                _weightLabel.frame = CGRectMake(15, 25, 70, 20);
            }
            else
                _weightLabel.frame = CGRectMake(width1+35+width2, 5, 200, 20);
        }
        else
        {
            _weightLabel.frame = CGRectMake(15+width2+15, 25, 70, 20);
        }
        
    }
    
    if (_model.validDate && _model.validDate.length>0)
    {
        _timeLabel.hidden = NO;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_model.validDate longLongValue]];
        NSString *timeString = [formatter stringFromDate:confromTimesp];
        if (!skuTooLong)
        {
            if (needChange)
            {
                _timeLabel.frame = CGRectMake(100, 25, 70, 20);
            }
        }
        else
        {
            _timeLabel.frame = CGRectMake(110+width2, 25, 70, 20);
        }
        
        _timeLabel.text = [NSString stringWithFormat:@"有效期 %@",timeString];
    }
    else
    {
        _timeLabel.hidden = YES;
    }
    
    if ([_model.giftSale floatValue] == 1)
    {
        _timeLabel.hidden = NO;
        NSString *first;
        if ([_model.firstGiftThreshold floatValue] == 0)
        {
            first = @"0";
        }
        else
        {
            first = [NSString stringWithFormat:@"%@%@/%@%@",_model.firstCurrencyName,_model.firstGiftThreshold,_model.secondCurrencyName,_model.secondGiftThreshold];
        }
        
        if (!skuTooLong)
        {
            if (needChange)
            {
                _timeLabel.frame = CGRectMake(100, 25, 260, 20);
            }
            else
                _timeLabel.frame = CGRectMake(15, 25, 260, 20);
        }
        else
        {
            _timeLabel.frame = CGRectMake(15, 45, 70, 20);
        }
        
        
        _timeLabel.text = [NSString stringWithFormat:@"换购 购满%@，加%@%@/%@%@换购",first,_model.firstCurrencyName,_model.firstGiftPrice,_model.secondCurrencyName,_model.secondGiftPrice];
        
    }
    
    if (_model.properties && _model.properties.count > 0)
    {
        _firstPriceLabel.hidden = YES;
    }
    
}

- (void)setHiddenOriginPrice:(BOOL)hiddenOriginPrice
{
    _hiddenOriginPrice = hiddenOriginPrice;
     _firstPriceLabel.hidden = YES;
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
