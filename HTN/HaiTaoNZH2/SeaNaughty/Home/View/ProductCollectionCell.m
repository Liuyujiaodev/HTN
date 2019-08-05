//
//  ProductCollectionCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/2.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProductCollectionCell.h"
#import "TagView.h"
#import "SQView.h"
#import <YYText.h>
#import <Masonry.h>

@interface ProductCollectionCell()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *firstPriceLabel;
@property (nonatomic, strong) UILabel *secondPriceLabel;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) TagView *tagView;
@property (nonatomic, strong) YYLabel *alertLabel;
@property (nonatomic, strong) UIButton *favoriteBtn;
@property (nonatomic, strong) SQView *sqView;
@property (nonatomic, strong) UIButton *shopCarBtn;

@end

@implementation ProductCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat width = G_SCREEN_WIDTH/2-21;
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, width-20, 200)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _sqView = [[SQView alloc] initWithFrame:CGRectMake(20, 10, width-20, 200)];
        _sqView.hidden = YES;
        [self.contentView addSubview:_sqView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, width, 20)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [self.contentView addSubview:_nameLabel];
        
        
        _alertLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10, 230, 100, 20)];
        _alertLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _alertLabel.text = @"登录后可见";
        _alertLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_alertLabel];
        [_alertLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:vc animated:YES];
        }];
        
        _firstPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, width+10, 20)];
        _firstPriceLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        _firstPriceLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_firstPriceLabel];
        
        _secondPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, width+10, 20)];
        _secondPriceLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _secondPriceLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_secondPriceLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 299, width, 1)];
        lineView.backgroundColor = LineColor;
        [self.contentView addSubview:lineView];
        
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 310, width, 20)];
        _shopNameLabel.font = [UIFont systemFontOfSize:11];
        _shopNameLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        [self.contentView addSubview:_shopNameLabel];
        
        
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 310, 90, 20)];
        _weightLabel.font = [UIFont systemFontOfSize:11];
        _weightLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        [self.contentView addSubview:_weightLabel];
        
        
        _favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-30, 310, 20, 20)];
        [_favoriteBtn setImage:[UIImage imageNamed:@"icon-shoucang"] forState:UIControlStateNormal];
        [_favoriteBtn setImage:[UIImage imageNamed:@"icon-shoucang1"] forState:UIControlStateSelected];
        [_favoriteBtn addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_favoriteBtn];
        
        _shopCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-5, 310, 20, 20)];
        [_shopCarBtn setImage:[UIImage imageNamed:@"icon-tianjia"] forState:UIControlStateNormal];
        [_shopCarBtn addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shopCarBtn];
        
        
        _tagView = [[TagView alloc] initWithFrame:CGRectMake(5, 5, G_SCREEN_WIDTH/2-5, 0)];
        [self.contentView addSubview:_tagView];
        
        
        
    }
    return self;
}


- (void)setData:(ProductModel *)data
{
    CGFloat width = G_SCREEN_WIDTH/2-31;
    
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
    
    _data = data;
    
    if (_data.productId)
    {
        
        if ([_data.name containsString:@"Danie"])
        {
            
        }
        
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_data.imgUrl]];
        
        if ([_data.stock isEqualToString:@"售罄"])
        {
            _sqView.hidden = NO;
            _shopCarBtn.hidden = YES;
        }
        else
        {
            _sqView.hidden = YES;
            _shopCarBtn.hidden = NO;
        }
        
        _nameLabel.text = _data.name;
        
        CGFloat height = [_data.name boundingRectWithSize:CGSizeMake(width, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+2;
        _nameLabel.frame = CGRectMake(10, 210, width, height);
        
        _alertLabel.frame = CGRectMake(10, 210+height, width, 20);
        
        if (_data.secondPrice.length > 8)
        {
            float price = [_data.secondPrice floatValue];
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            NSDecimalNumber *ouncesDecimal;
            NSDecimalNumber *roundedOunces;
            
            ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
            roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
            
            _data.secondPrice = [NSString stringWithFormat:@"%@",roundedOunces];
        }
        
        
        
        if (_data.secondPrice.length > 8)
        {
            float price = [_data.secondPrice floatValue];
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            NSDecimalNumber *ouncesDecimal;
            NSDecimalNumber *roundedOunces;
            
            ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
            roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
            
            _data.secondPrice = [NSString stringWithFormat:@"%@",roundedOunces];
        }
        
        if (_data.firstPrice.length > 8)
        {
            float price = [_data.firstPrice floatValue];
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            NSDecimalNumber *ouncesDecimal;
            NSDecimalNumber *roundedOunces;
            
            ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
            roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
            
            _data.firstPrice = [NSString stringWithFormat:@"%@",roundedOunces];
        }
        
        if (_data.firstOriginalPrice.length > 8)
        {
            float price = [_data.firstOriginalPrice floatValue];
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            NSDecimalNumber *ouncesDecimal;
            NSDecimalNumber *roundedOunces;
            
            ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
            roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
            
            _data.firstOriginalPrice = [NSString stringWithFormat:@"%@",roundedOunces];
        }
        
        if (_data.secondOriginalPrice.length > 8)
        {
            float price = [_data.secondOriginalPrice floatValue];
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            NSDecimalNumber *ouncesDecimal;
            NSDecimalNumber *roundedOunces;
            
            ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
            roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
            
            _data.secondOriginalPrice = [NSString stringWithFormat:@"%@",roundedOunces];
        }
        
        if (_data.firstPrice)
        {
            
            if (!_data.firstOriginalPrice)
            {
                
                _firstPriceLabel.hidden = YES;
            }
            _firstPriceLabel.frame = CGRectMake(10, 215+height, width, 20);
            
            NSString *str = [NSString stringWithFormat:@"%@ %@/%@ %@",_data.firstCurrencyName,_data.firstOriginalPrice,_data.secondCurrencyName,_data.secondOriginalPrice];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
            
            _firstPriceLabel.attributedText = string;
            
            _secondPriceLabel.frame = CGRectMake(10, 235+height, width+10, 20);
            
            
            
            if ([_data.shopName isEqualToString:@"中国快快仓"] || [_data.shopName isEqualToString:@"全球精选仓"])
            {
                _secondPriceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_data.firstCurrencyName,_data.firstPrice,_data.secondCurrencyName,_data.secondPrice];
            }
            else
            {
                _secondPriceLabel.text = [NSString stringWithFormat:@"直邮价 %@ %@/%@ %@",_data.firstCurrencyName,_data.firstPrice,_data.secondCurrencyName,_data.secondPrice];
            }
            
            if (_data.firstOriginalPrice == _data.firstPrice)
            {
                _firstPriceLabel.hidden = YES;
            }
            
        }
        
        if (!_data.firstOriginalPrice)
        {
            _firstPriceLabel.hidden = YES;
        }
        
        if (_data.weight)
        {
            _weightLabel.text = [NSString stringWithFormat:@"%@g",_data.weight];
        }
        
        
        
        if (_data.weight && [_data.weight isEqualToString:@"0"])
        {
            _weightLabel.text = @"";
        }
        
        _shopNameLabel.text = _data.shopName;
        if (_data.shopName.length >= 10)
        {
            _weightLabel.text = @"";
        }
        
        NSMutableArray *tagArray = [NSMutableArray arrayWithArray:_data.tags];
        
        if (_data.zeroShippingFeeQty.length>0)
        {
            
            NSString *str;
            if ([_data.shopId isEqualToString:@"4"])
            {
                str = [NSString stringWithFormat:@"%@件包邮闪电发货",_data.zeroShippingFeeQty];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@件包邮",_data.zeroShippingFeeQty];
            }
            if(![_data.zeroShippingFeeQty isEqualToString:@"0"]){
                [tagArray addObject:str];
            }
            
        }
        
        if (_data.limitedQty.length>0)
        {
            NSString *str = [NSString stringWithFormat:@"限购%@件", _data.limitedQty];
            [tagArray addObject:str];
        }
        
        if ([_data.giftSale isEqualToString:@"1"])
        {
            
            NSString *str = [NSString stringWithFormat:@"换购"];
            [tagArray addObject:str];
        }
        
        if (_data.freePostage.allValues.count>0)
        {
            NSDictionary *freePostage = _data.freePostage;
            
            if(freePostage[@"firstCurrencyName"] == nil){
                
            }
            NSString *freePos = [NSString stringWithFormat:@"满%@%@/%@ %@包邮",freePostage[@"firstCurrencyName"],freePostage[@"firstThreshold"],freePostage[@"secondCurrencyName"],freePostage[@"secondThreshold"]];
            if(freePostage[@"firstCurrencyName"] != nil && freePostage[@"firstThreshold"] != nil){
                [tagArray addObject:freePos];
            }
            
        }
        
        
        
        
        [_tagView removeFromSuperview];
        
        _tagView = [[TagView alloc] initWithFrame:CGRectMake(2, 5, G_SCREEN_WIDTH/2-2, 0)];
        [self.contentView addSubview:_tagView];
        
        _tagView.arr = (NSArray *)tagArray;
        
        if ([_data.favoriteId isKindOfClass:[NSNumber class]])
        {
            _data.favoriteId = [NSString stringWithFormat:@"%@", _data.favoriteId];
        }
        
        if (_data.favoriteId.length>0)
        {
            _favoriteBtn.selected = YES;
        }
        else
        {
            _favoriteBtn.selected = NO;
        }
    }
    else
    {
        _firstPriceLabel.text = @"直邮价0";
        _logoImageView.image = [[UIImage alloc] init];
        _shopNameLabel.text = @"";
        _weightLabel.text = @"";
        _favoriteBtn.selected = NO;
//        _alertLabel.hidden = YES;
//        _firstPriceLabel.textColor = MainColor;
//        _firstPriceLabel.font = [UIFont systemFontOfSize:12];
        _secondPriceLabel.text = @"";
        _nameLabel.text = @"";
        [_tagView removeFromSuperview];
    }
    
    
   
}

- (void)shopAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buyAction" object:_data];
}

- (void)likeAction
{
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
    {
        [self shopAction];
        return;
    }
    
    if (!_data.productId)
    {
        return;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    _favoriteBtn.selected = !_favoriteBtn.selected;
    
    MJWeakSelf;
    
    if (!_favoriteBtn.selected)
    {
        [param setObject:_data.favoriteId forKey:@"id"];
        
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/favorites/remove" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
//                [weakSelf.favoriteBtn setImage:[UIImage imageNamed:@"icon-shoucang"] forState:UIControlStateNormal];
                weakSelf.favoriteBtn.selected = NO;
                weakSelf.data.favoriteId = @"";
                [param removeObjectForKey:@"id"];
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    else
    {
        [param setObject:_data.productId forKey:@"productId"];
        
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/favorites/add" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                NSNumber *favorite = result[@"data"][@"id"];
                weakSelf.data.favoriteId = [NSString stringWithFormat:@"%@",favorite];
                weakSelf.favoriteBtn.selected = YES;
                [param removeObjectForKey:@"productId"];
            }

            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}



@end
