//
//  GiftCollectionCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/27.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "GiftCollectionCell.h"
#import "TagView.h"

@interface GiftCollectionCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *firstPriceLabel;
@property (nonatomic, strong) UILabel *secondPriceLabel;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) TagView *tagView;
@property (nonatomic, strong) UILabel *needLabel;
@property (nonatomic, strong) UIButton *botBtn;

@end

@implementation GiftCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 130)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        CGFloat width = G_SCREEN_WIDTH-30;
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 110)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_bgView addSubview:_logoImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, width-130, 20)];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [_bgView addSubview:_nameLabel];
        
        _tagView = [[TagView alloc] initWithFrame:CGRectMake(100, 30, width-130, 30)];
        [_bgView addSubview:_tagView];
        
        _firstPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, width-100, 20)];
        _firstPriceLabel.textColor = [UIColor colorFromHexString:@"#DDDDDD"];
        _firstPriceLabel.font = [UIFont systemFontOfSize:8];
        [_bgView addSubview:_firstPriceLabel];
        
        _needLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, width-130, 20)];
        _needLabel.font = [UIFont systemFontOfSize:11];
        _needLabel.textColor = TextColor;
        [_bgView addSubview:_needLabel];
        
        _botBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 68, 20)];
        [_botBtn setTitle:@"立即换购" forState:UIControlStateNormal];
        [_botBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
        _botBtn.enabled = NO;
        _botBtn.layer.cornerRadius = 4;
        [_botBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
        _botBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        _botBtn.layer.borderWidth = 0.8;
        _botBtn.layer.borderColor = LightGrayColor.CGColor;
        [_bgView addSubview:_botBtn];
        
    }
    return self;
}

- (void)setModel:(ProductModel *)model
{
    _model = model;
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl]];
    
    CGFloat width = G_SCREEN_WIDTH-30;
    
    CGFloat height = [_model.name boundingRectWithSize:CGSizeMake(width-130, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height+2;
    _nameLabel.frame = CGRectMake(100, 10, width-130, height);
    _nameLabel.text = _model.name;
    
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:_model.tags];
    
    [_tagView removeFromSuperview];
    
    _tagView = [[TagView alloc] initWithFrame:CGRectMake(100, height+5, width-130, 10)];
    [_bgView addSubview:_tagView];
    
    _tagView.arr = (NSArray *)tagArray;
    
    NSString *price = @"";
    
    if ([_model.firstGiftPrice floatValue] == 0)
    {
        price = @"0";
        _needLabel.hidden = YES;
    }
    else
    {
        _needLabel.hidden = NO;
        price = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [self moneyWithString:_model.firstGiftPrice], _model.secondCurrencyName, [self moneyWithString:_model.secondGiftPrice]];
    }
    
    NSString *string = [price stringByAppendingString:[NSString stringWithFormat:@"    %@ %@/%@ %@", _model.firstCurrencyName, [self moneyWithString:_model.firstPrice], _model.secondCurrencyName, [self moneyWithString:_model.secondPrice]]];
    
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [priceString addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, price.length)];
    [priceString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, price.length)];
    
    
    [priceString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(price.length+4, string.length-price.length-4)];
    [priceString addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorFromHexString:@"#999999"] range:NSMakeRange(price.length+4, string.length-price.length-4)];
     [priceString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#999999"] range:NSMakeRange(price.length+4, string.length-price.length-4)];
    
    _firstPriceLabel.attributedText = priceString;
    
    NSString *threshol = @"0";
    if (_model.firstGiftThreshold && [_model.firstGiftThreshold floatValue] != 0)
    {
        threshol = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [self moneyWithString:_model.firstGiftThreshold], _model.secondCurrencyName, [self moneyWithString:_model.secondGiftThreshold]];
    }
    _needLabel.text = [NSString stringWithFormat:@"购满%@换购", threshol];
//    _needLabel.text = @"zzzzz";

    if ([_model.canGiftSale intValue] == 1)
    {
        _botBtn.enabled = YES;
        [_botBtn setTitleColor:TextColor forState:UIControlStateNormal];
        _botBtn.layer.borderColor = TextColor.CGColor;
        _botBtn.alpha = 1;
    }
    else
    {
        _botBtn.enabled = NO;
        [_botBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
        _botBtn.layer.borderColor = LightGrayColor.CGColor;
        _botBtn.alpha = 0.5;
    }
    
    CGFloat pricee = [_model.firstGiftThreshold floatValue];
    
//    if ([_model.shopId isEqualToString:@"4"])
//    {
//        pricee = [_model. floatValue];
//    }
    
    if (pricee > self.needMoney)
    {
        _botBtn.enabled = NO;
        [_botBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
        _botBtn.layer.borderColor = LightGrayColor.CGColor;
        _botBtn.alpha = 0.5;
    }
    else
    {
        _botBtn.enabled = YES;
        [_botBtn setTitleColor:TextColor forState:UIControlStateNormal];
        _botBtn.layer.borderColor = TextColor.CGColor;
        _botBtn.alpha = 1;
    }
    
}

- (void)buyAction
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:_model.productId forKey:@"productId"];
    [param setObject:_model.shopId forKey:@"shopId"];
    [param setObject:@"1" forKey:@"quantity"];
    [param setObject:_model.giftSale forKey:@"giftSale"];
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/add" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [loadingHud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADPRODUCT" object:nil];
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
        }
        [SVProgressHUD dismissWithDelay:1];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
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
