//
//  SaleCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/30.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "SaleCell.h"
#import <Masonry.h>
#import "TagView.h"
#import <YYText.h>
@interface SaleCell ()

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
@property (nonatomic, strong) UIButton *favoriteBtn;
@property (nonatomic, strong) UIButton *shopCarBtn ;

@end

@implementation SaleCell

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
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 110, 150)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 8, G_SCREEN_WIDTH-150, 20)];
        _nameLabel.numberOfLines = 2;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor colorFromHexString:@"#333333"];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 30, G_SCREEN_WIDTH-150, 20)];
        _timeLabel.layer.cornerRadius = 10;
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.clipsToBounds = YES;
        _timeLabel.backgroundColor = [UIColor colorFromHexString:@"#FF3635"];
        [self.contentView addSubview:_timeLabel];
        
        _alertLabel = [[YYLabel alloc] initWithFrame:CGRectMake(135, 100, 100, 20)];
        _alertLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _alertLabel.text = @"登录后可见";
        _alertLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_alertLabel];
        [_alertLabel setTextTapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.tabbar.selectedViewController pushViewController:vc animated:YES];
        }];
        
        
        _firstPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 100, G_SCREEN_WIDTH-150, 15)];
        _firstPriceLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        _firstPriceLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_firstPriceLabel];
        
        _secondPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 115, G_SCREEN_WIDTH-150, 15)];
        _secondPriceLabel.textColor = [UIColor colorFromHexString:@"#FFA800"];
        _secondPriceLabel.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_secondPriceLabel];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(135, 130, G_SCREEN_WIDTH-150, 1)];
        lineView1.backgroundColor = LineColor;
        [self.contentView addSubview:lineView1];
        
        _shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 131, G_SCREEN_WIDTH-150, 30)];
        _shopNameLabel.textColor = LightGrayColor;
        _shopNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_shopNameLabel];
        
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 131, 200, 30)];
        _weightLabel.font = [UIFont systemFontOfSize:12];
        _weightLabel.textColor = [UIColor colorFromHexString:@"#999999"];
        [self.contentView addSubview:_weightLabel];
        
        
        _favoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-70, 136, 20, 20)];
        [_favoriteBtn setImage:[UIImage imageNamed:@"icon-shoucang"] forState:UIControlStateNormal];
        [_favoriteBtn setImage:[UIImage imageNamed:@"icon-shoucang1"] forState:UIControlStateSelected];
        [_favoriteBtn addTarget:self action:@selector(likeAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_favoriteBtn];
        
        UIButton *shopCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-35, 136, 20, 20)];
        [shopCarBtn setImage:[UIImage imageNamed:@"icon-tianjia"] forState:UIControlStateNormal];
        [shopCarBtn addTarget:self action:@selector(shopAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:shopCarBtn];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 160, G_SCREEN_WIDTH-30, 1.8)];
        lineView2.backgroundColor = LineColor;
        [self.contentView addSubview:lineView2];
        
        _tagView = [[TagView alloc] initWithFrame:CGRectMake(5, 160, G_SCREEN_WIDTH-10, 0)];
        [self.contentView addSubview:_tagView];
        
    }
    return self;
}

- (void)setData:(ProductModel *)data
{
    _data = data;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_data.imgUrl]];
    
    NSString *name = _data.name;
    CGFloat height = [name boundingRectWithSize:CGSizeMake( G_SCREEN_WIDTH-150, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height+2;
    _nameLabel.frame = CGRectMake(135, 8, G_SCREEN_WIDTH-150, height);
    _nameLabel.text = name;
    
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
    
    
    
    if (_data.firstOriginalPrice.length>0)
    {
//        _alertLabel.hidden = YES;
        NSString *firstPrice = [NSString stringWithFormat:@"%@ %@/%@ %@",_data.firstCurrencyName,_data.firstOriginalPrice,_data.secondCurrencyName,_data.secondOriginalPrice];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:firstPrice];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, firstPrice.length)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorFromHexString:@"#999999"] range:NSMakeRange(0, firstPrice.length)];
        [_firstPriceLabel setAttributedText:attri];
    }
    
    
    if ([_data.shopName isEqualToString:@"中国快快仓"] || [_data.shopName isEqualToString:@"全球精选仓"])
    {
        _secondPriceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_data.firstCurrencyName,_data.firstPrice,_data.secondCurrencyName,_data.secondPrice];
    }
    else
    {
        _secondPriceLabel.text = [NSString stringWithFormat:@"直邮价 %@ %@/%@ %@",_data.firstCurrencyName,_data.firstPrice,_data.secondCurrencyName,_data.secondPrice];
    }
    
    _shopNameLabel.text = _data.shopName;
    
    _weightLabel.text = [NSString stringWithFormat:@"%@g",_data.weight];
    
    if ([_data.weight isEqualToString:@"0"])
    {
        _weightLabel.text = @"";
    }
    
    NSDictionary *freePostage = _data.freePostage;
    
    NSMutableArray *tagArray = [NSMutableArray arrayWithArray:_data.tags];

    
    if (_data.freePostage.allKeys.count > 0)
    {
         NSString *freePos = [NSString stringWithFormat:@"满%@%@/%@ %@包邮",freePostage[@"firstCurrencyName"],[self moneyWithString:freePostage[@"firstThreshold"]],freePostage[@"secondCurrencyName"],[self moneyWithString:freePostage[@"secondThreshold"]]];
         [tagArray addObject:freePos];
    }
    
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
    
    [_tagView removeFromSuperview];
    
    _tagView = [[TagView alloc] initWithFrame:CGRectMake(5, 170, G_SCREEN_WIDTH-10, 0)];
    [self.contentView addSubview:_tagView];
    
    _tagView.arr = (NSArray *)tagArray;
    
    if (_data.endTime > 0)
    {
        NSString *timeString = [self countTimer:_data.endTime];

        _timeLabel.text = timeString;
        CGFloat width = [timeString boundingRectWithSize:CGSizeMake( G_SCREEN_WIDTH-150, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width+10;
        _timeLabel.hidden = NO;
        _timeLabel.frame = CGRectMake(135, height+20, width, 20);

    }
    else
    {
        _timeLabel.hidden = YES;
        _timeLabel.frame = CGRectMake(135, height+20, G_SCREEN_WIDTH-180, 20);
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

- (void)setSaleEndTimeSecond:(NSTimeInterval)saleEndTimeSecond
{
    _saleEndTimeSecond = saleEndTimeSecond;
    NSString *time = [self countTimer:saleEndTimeSecond];
//    CGFloat width = [time boundingRectWithSize:CGSizeMake( G_SCREEN_WIDTH-150, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.width+10;
//    //
//
//    CGRect frame = _timeLabel.frame;
//    frame.size.width = width;
//
//    _timeLabel.frame = frame;
//
    _timeLabel.text = time;
}

- (NSString *)countTimer:(NSTimeInterval )endTime
{
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval createTime = endTime;
    NSTimeInterval endTimeSecond = createTime - currentTime;
    int days = floor(endTimeSecond / 86400);
    endTimeSecond = endTimeSecond-days*86400;
    int hour = endTimeSecond/60/60;
    endTimeSecond = endTimeSecond-hour*60*60;
    int minute = endTimeSecond/(60);
    endTimeSecond = endTimeSecond-minute*60;
    int second = ((int)endTimeSecond % (60));
    
    NSString *tempTime;
    if (days>0)
    {
        tempTime = [NSString stringWithFormat:@"    距活动结束%d天%02d时%02d分%02d秒", days, hour, minute, second];
    }
    else
    {
        tempTime = [NSString stringWithFormat:@"    距活动结束%02d时%02d分%02d秒", hour, minute, second];
    }
    
    return tempTime;
}

- (void)likeAction
{
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
//                [weakSelf.favoriteBtn setImage:[UIImage imageNamed:@"icon-shoucang1"] forState:UIControlStateNormal];
                weakSelf.favoriteBtn.selected = YES;
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}




- (void)shopAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"buyAction" object:_data];
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
