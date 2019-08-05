//
//  MoneyCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/6.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "MoneyCell.h"

@implementation MoneyCell
{
    UILabel *_label1;
    UILabel *_label2;
    UILabel *_label3;
    UIView  *_lineView;
}

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
        
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, G_SCREEN_WIDTH-50, 20)];
        _label1.textColor = TitleColor;
        _label1.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label1];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 33, G_SCREEN_WIDTH-100, 20)];
        _label2.textColor = LightGrayColor;
        _label2.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_label2];
        
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 22, 300, 20)];
        _label3.textColor = TextColor;
        _label3.font = [UIFont systemFontOfSize:13];
        _label3.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_label3];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 1)];
        _lineView.backgroundColor = LineColor;
        [self.contentView addSubview:_lineView];
    }
    return self;
}

//"amountChanged": "-41.99纽币",
//"currencyId": 1,
//"changeTime": 1539246898,
//"type": "订单消费",
//"currencyCode": "NZD",
//"currencyName": "纽币",
//"orderNumber": "EWR201810111634373887"

- (void)setModel:(MoneyModel *)model
{
    _model = model;
    
//    NSString *tempString =
    
    _label1.text = [NSString stringWithFormat:@"%@ %@", _model.orderNumber.length > 0 ? _model.orderNumber : @"", _model.type];
    

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_model.changeTime longLongValue]];
    NSString *timeString = [formatter stringFromDate:confromTimesp];
    
    _label2.text = timeString;
    NSString *temp = _model.amountChanged;
    if (![temp containsString:@"-"])
    {
        temp = [NSString stringWithFormat:@"+%@",temp];
    }
    
    NSString *codeString = @"";
    if ([temp containsString:@"人民币"])
    {
        codeString = @"人民币";
    }
    else if ([temp containsString:@"纽币"])
    {
        codeString = @"纽币";
    }
    
     _label3.text = temp;
    
    if (_model.amountChanged.length > 9)
    {
        float price = [temp floatValue];
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        _label3.text = [NSString stringWithFormat:@"%@%@",roundedOunces, codeString];
    }
   
    
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    _lineView.hidden = !_showLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
