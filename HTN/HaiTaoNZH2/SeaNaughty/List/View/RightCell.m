//
//  RightCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/13.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "RightCell.h"
#import <Masonry.h>
#import "TagView.h"
#import "SQView.h"
#import <YYText.h>

@interface RightCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *firstPriceLabel;
@property (nonatomic, strong) UILabel *secondPriceLabel;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *freePosLabel;
@property (nonatomic, strong) YYLabel *alertLabel;
@property (nonatomic, strong) TagView *tagView;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) SQView *sqView;
@property (nonatomic, strong) UIButton *shopCarBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation RightCell

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
        
        CGFloat width = G_SCREEN_WIDTH-80;
        CGFloat logoWidth = width*0.3;
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, logoWidth, 130)];
//        _logoImageView.backgroundColor = [UIColor yellowColor];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _sqView = [[SQView alloc] initWithFrame:CGRectMake(5, 10, logoWidth, 130)];
        _sqView.hidden = YES;
        [self.contentView addSubview:_sqView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoWidth+10, 10, width-logoWidth-30, 20)];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = TitleColor;
        [self.contentView addSubview:_nameLabel];
        
        _alertLabel = [[YYLabel alloc] initWithFrame:CGRectMake(logoWidth+10, 40, 100, 20)];
        _alertLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _alertLabel.text = @"登录后可见";
        _alertLabel.font = [UIFont systemFontOfSize:13];
        [_alertLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:vc animated:YES];
        }];
        [self.contentView addSubview:_alertLabel];
        
        _firstPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoWidth+10, 100, width*0.7-20, 15)];
        _firstPriceLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        _firstPriceLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_firstPriceLabel];
        
        _secondPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoWidth+10, 115, width*0.7-20, 15)];
        _secondPriceLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _secondPriceLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_secondPriceLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(logoWidth+10, 130, width*0.7-20, 1)];
        _lineView.backgroundColor = LineColor;
        [self.contentView addSubview:_lineView];
        
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoWidth+10, 101, width*0.7-20, 30)];
        _shopNameLabel.textColor = LightGrayColor;
        _shopNameLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_shopNameLabel];
        
        

        
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-50, 109, 14, 14)];
        [_likeBtn setImage:[UIImage imageNamed:@"icon-shoucang"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"icon-shoucang1"] forState:UIControlStateSelected];
        [_likeBtn addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_likeBtn];
        
        _shopCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-30, 109, 14, 14)];
        [_shopCarBtn setImage:[UIImage imageNamed:@"icon-tianjia"] forState:UIControlStateNormal];
        [_shopCarBtn addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shopCarBtn];
        
        
        
        _tagView = [[TagView alloc] initWithFrame:CGRectMake(5, 130, G_SCREEN_WIDTH-10, 0)];
        [self.contentView addSubview:_tagView];
        
    }
    return self;
}

- (void)setData:(ProductModel *)data
{
    _data = data;
    
    CGFloat width = G_SCREEN_WIDTH-80;
    CGFloat logoWidth = width*0.3;
    
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
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_data.imgUrl]];
    
    NSString *name = _data.name;
    CGFloat height = [name boundingRectWithSize:CGSizeMake(width-logoWidth-25, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+2;
    _nameLabel.frame = CGRectMake(logoWidth+10, 15, width-logoWidth-25, height);
    _nameLabel.text = name;
    
    
    if (_data.favoriteId.length>0)
    {
        _likeBtn.selected = YES;
    }
    else
    {
        _likeBtn.selected = NO;
    }
    
    if (_data.secondPrice.length > 6)
    {
        float price = [_data.secondPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _data.secondPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    if (_data.firstPrice.length > 6)
    {
        float price = [_data.firstPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _data.firstPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    if (_data.firstOriginalPrice.length > 6)
    {
        float price = [_data.firstOriginalPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _data.firstOriginalPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    if (_data.secondOriginalPrice.length > 6)
    {
        float price = [_data.secondOriginalPrice floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _data.secondOriginalPrice = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    CGFloat tempHeight = height;
    
    if (_data.secondPrice.length > 0)
    {
        if (_data.firstOriginalPrice.length > 0)
        {
            NSString *firstPrice = [NSString stringWithFormat:@"%@ %@/%@ %@",_data.firstCurrencyName,_data.firstOriginalPrice,_data.secondCurrencyName,_data.secondOriginalPrice];
            
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:firstPrice];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, firstPrice.length)];
            [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorFromHexString:@"#999999"] range:NSMakeRange(0, firstPrice.length)];
            [attri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [firstPrice length])];
            
            [_firstPriceLabel setAttributedText:attri];
        }
        else
            _firstPriceLabel.text = @"";
        
        if ([_data.shopName isEqualToString:@"中国快快仓"] || [_data.shopName isEqualToString:@"全球精选仓"])
        {
            _secondPriceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_data.firstCurrencyName,_data.firstPrice,_data.secondCurrencyName,_data.secondPrice];
        }
        else
        {
            _secondPriceLabel.text = [NSString stringWithFormat:@"直邮价 %@ %@/%@ %@",_data.firstCurrencyName,_data.firstPrice,_data.secondCurrencyName,_data.secondPrice];
        }
        
        if ([_data.firstOriginalPrice floatValue]>0 || [_data.secondOriginalPrice floatValue]>0)
        {
            _firstPriceLabel.hidden = NO;
            _firstPriceLabel.frame = CGRectMake(logoWidth+10, height+20, width*0.7-25, 15);
            _secondPriceLabel.frame = CGRectMake(logoWidth+10, height+35, width*0.7-25, 15);
            tempHeight = height+27;
        }
        else
        {
            _firstPriceLabel.hidden = YES;
            _secondPriceLabel.frame = CGRectMake(logoWidth+10, height+20, width*0.7-25, 15);
        
            tempHeight = height+15;
        }
        
    
    }
    else
    {
        tempHeight = height+15;
        _secondPriceLabel.frame = CGRectMake(logoWidth+10, height+20, width*0.7-25, 15);
        _alertLabel.frame = CGRectMake(logoWidth+10, height+20, width*0.7-25, 15);
    }
    
    NSString *shopName = _data.shopName ? _data.shopName : @"";
    NSString *weight = [_data.weight isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%@g",_data.weight];
    
    _shopNameLabel.text = [NSString stringWithFormat:@"%@      %@", shopName, weight];
   
  
    [_tagView removeFromSuperview];
    
    CGFloat hhh = 15;
    
     if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"YES"])
     {
         _tagView = [[TagView alloc] initWithFrame:CGRectMake(logoWidth+10, tempHeight+hhh, width-logoWidth-10, height)];
     }
    else
    {
        hhh = 24;
        _tagView = [[TagView alloc] initWithFrame:CGRectMake(logoWidth+10, tempHeight+hhh, width-logoWidth-10, height)];
    }
    
    [self.contentView addSubview:_tagView];
    
    _tagView.arr = _data.tagsArray;
  
    
    CGFloat lineTop = tempHeight+_tagView.bounds.size.height+hhh-6 ;
    
    _lineView.frame = CGRectMake(logoWidth+10, lineTop+30, width*0.7-20, 1);
    
    _shopNameLabel.frame = CGRectMake(logoWidth+10, lineTop, width*0.7-20, 30);
    
    
    _likeBtn.frame = CGRectMake(width-50, lineTop+8, 14, 14);
    _shopCarBtn.frame = CGRectMake(width-30, lineTop+8, 14, 14);
    
    
}


- (void)likeAction
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    _likeBtn.selected = !_likeBtn.selected;
    
    MJWeakSelf;
    
    if (!_likeBtn.selected)
    {
        [param setObject:_data.productId forKey:@"id"];
        
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/favorites/remove" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                //                [weakSelf.favoriteBtn setImage:[UIImage imageNamed:@"icon-shoucang"] forState:UIControlStateNormal];
                weakSelf.likeBtn.selected = NO;
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
                _data.favoriteId = [NSString stringWithFormat:@"%@",favorite];
                weakSelf.likeBtn.selected = YES;
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (void)addProduct:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(rightCellAddProduct:)])
    {
        [_delegate rightCellAddProduct:_data];
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
