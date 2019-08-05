//
//  VoucherDetailCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/29.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "VoucherDetailCell.h"

@interface VoucherDetailCell ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *needLabel;
@property (nonatomic, strong) UILabel *useLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *countImageView;
@property (nonatomic, strong) UILabel *superLabel;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation VoucherDetailCell

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
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 160)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH-30, 80)];
        _topView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_topView];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, G_SCREEN_WIDTH-30, 30)];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.font = [UIFont systemFontOfSize:18];
        _moneyLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_moneyLabel];
        
        _needLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, G_SCREEN_WIDTH-30, 20)];
        _needLabel.textAlignment = NSTextAlignmentCenter;
        _needLabel.font = [UIFont systemFontOfSize:12];
        _needLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_needLabel];
        
        _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-50, 15, 15, 15)];
        _selectImage.image = [UIImage imageNamed:@"select"];
        [self.contentView addSubview:_selectImage];
        
        _useLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 93, G_SCREEN_WIDTH-60, 16)];
        _useLabel.font = [UIFont systemFontOfSize:12];
        _useLabel.textColor = LightGrayColor;
        _useLabel.numberOfLines = 2;
        [_bgView addSubview:_useLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 109, G_SCREEN_WIDTH-60, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = TextColor;
        [_bgView addSubview:_timeLabel];
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 133, G_SCREEN_WIDTH-60, 16)];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.textColor = TextColor;
        _descriptionLabel.numberOfLines = 2;
        [_bgView addSubview:_descriptionLabel];
        
        
        
        _countImageView = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-60, 0, 30, 30)];
        _countImageView.image = [UIImage imageNamed:@"sanjiaoxing.png"];
        [_bgView addSubview:_countImageView];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-50, 0, 20, 20)];
        _countLabel.font = [UIFont systemFontOfSize:12];
        _countLabel.textColor = RGBCOLOR(234, 100, 123);
        
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [_bgView addSubview:_countLabel];
        
        _superLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 20)];
        _superLabel.font = [UIFont italicSystemFontOfSize:15];
        _superLabel.textColor = MainColor;
        _superLabel.text = @"Super";
        _superLabel.hidden = YES;
        [_bgView addSubview:_superLabel];
        
    }
    return self;
}

- (void)setModel:(VoucherModel *)model
{
    _model = model;
    
    
    _topView.backgroundColor = RGBCOLOR(234, 100, 123);
    
    _countLabel.text = model.count;
    _superLabel.textColor = MainColor;
    
    if ([_model.count isEqualToString:@"1"])
    {
        _countLabel.hidden = YES;
        _countImageView.hidden = YES;
    }
    else
    {
        
        if ([_model.isValid isEqualToString:@"0"])
        {
            _countImageView.image = [UIImage imageNamed:@"sanjiaoxing1.png"];
            _countLabel.textColor = TitleColor;
            _superLabel.textColor = LightGrayColor;
        }
        else
        {
            _countImageView.image = [UIImage imageNamed:@"sanjiaoxing.png"];
            _countLabel.textColor = RGBCOLOR(234, 100, 123);
        }
        
        _countLabel.hidden = NO;
        _countImageView.hidden = NO;
    }
    
    NSString *string1 = [NSString stringWithFormat:@"$%@", [self moneyWithString:_model.firstAmount]];
    NSMutableAttributedString *mutableString1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [mutableString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
    _moneyLabel.attributedText = mutableString1;
    
    
    NSDictionary *dic = _model.superimposed;
    NSArray *aray = dic[@"data"];
    
   
    NSString *stringZero = @"0";
    if([_model.firstMinProductAmount isEqualToString:stringZero]|| _model.firstMinProductAmount == nil){
        if ([aray containsObject:@1])
        {
            _needLabel.text = [NSString stringWithFormat:@"【无金额门槛】【可叠加】"];
            _superLabel.hidden = NO;
            
        }
        else
        {
             _needLabel.text = [NSString stringWithFormat:@"【无金额门槛】"];
            _superLabel.hidden = YES;
        }
    }else{
        if ([aray containsObject:@1])
        {
            _needLabel.text = [NSString stringWithFormat:@"【满%@%@立减】【可叠加】", _model.firstCurrencyName, [self moneyWithString:_model.firstMinProductAmount]];
            _superLabel.hidden = NO;
            
        }
        else
        {
            _needLabel.text = [NSString stringWithFormat:@"【满%@%@立减】", _model.firstCurrencyName, [self moneyWithString:_model.firstMinProductAmount]];
            _superLabel.hidden = YES;
        }
    }
    
    
    
    
//    NSString *shop = _model.shopName.count > 0 ? [_model.shopName componentsJoinedByString:@","] : @"";
//    NSString *brand = _model.brandName.count > 0 ? [_model.brandName componentsJoinedByString:@","] : @"";
//    NSString *product = _model.productName.count > 0 ? [_model.productName componentsJoinedByString:@","] : @"";
//
//    if (brand.length > 0 || product.length >0)
//    {
//        if (shop.length > 0)
//        {
//           shop = [shop stringByAppendingString:@","];
//        }
//    }
//
//    if (product.length > 0 && brand.length > 0)
//    {
//        brand = [brand stringByAppendingString:@","];
//    }
//
//    NSString *string2 = [NSString stringWithFormat:@"适用范围:仅限%@ %@ %@使用",shop,brand,product];
    
    NSMutableAttributedString *mutableString2 = [[NSMutableAttributedString alloc] initWithString:_model.useCondition];
    [mutableString2 addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(0, 5)];
    _useLabel.attributedText = mutableString2;
    
    if (_model.startTime.length==0 && _model.endTime.length==0)
    {
        _timeLabel.text = [NSString stringWithFormat:@"有效期限:无时间限制"];
    }
    else if (_model.endTime.length == 0)
    {
        _timeLabel.text = [NSString stringWithFormat:@"有效期限:无时间限制"];
    }
    else
    {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model.endTime longLongValue]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSString *timeString = [formatter stringFromDate:date];
        //
        if(_model.startTime.length==0){
            _timeLabel.text = [NSString stringWithFormat:@"有效期限:%@ 到期",timeString];
        }else{
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[_model.startTime longLongValue]];
            [formatter setDateFormat:@"yyyy.MM.dd"];
            NSString *startTimeString = [formatter stringFromDate:startDate];
            _timeLabel.text = [NSString stringWithFormat:@"有效期限:%@ - %@ ",startTimeString,timeString];
            
        }
        
    }
    
    
    NSString *descriptionString = [NSString stringWithFormat:@"%@", _model.descriptionString];
    
    _descriptionLabel.text = descriptionString;
    
    CGFloat height = [_model.useCondition boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-60, 32) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+4;
    
    CGFloat height1 = [descriptionString boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-60, 32) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+4;
    
    _useLabel.frame = CGRectMake(15, 90, G_SCREEN_WIDTH-60, height);
    _timeLabel.frame = CGRectMake(15, height+90, G_SCREEN_WIDTH-60, 16);
    
    _descriptionLabel.frame = CGRectMake(15, 106+height, G_SCREEN_WIDTH-60, height1);
    
    if (_model.hasSelect)
    {
        _selectImage.hidden = NO;
    }
    else
        _selectImage.hidden = YES;
    
    
    if (_model.isPFree)
    {
        _topView.backgroundColor = RGBCOLOR(72, 151, 220);
        _needLabel.text = [NSString stringWithFormat:@"【满%@%@运费优惠】", _model.firstCurrencyName, [self moneyWithString:model.firstMinProductAmount]];
        _timeLabel.text = @"有效日期:包邮活动时间内";
        _descriptionLabel.text = @"其他说明:运费优惠";
    }
    
    _bgView.frame = CGRectMake(15, 0, G_SCREEN_WIDTH-30, _model.height);
    
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
