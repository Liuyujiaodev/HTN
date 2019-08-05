//
//  OnLineCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OnLineCell.h"

@interface OnLineCell ()

@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UIButton *btnn1;
@property (nonatomic, strong) UIButton *aliBtn;
@property (nonatomic, strong) UIImageView *yueimageView;

@end

@implementation OnLineCell

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
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, G_SCREEN_WIDTH-24, 177)];
        bgView.backgroundColor = [UIColor colorFromHexString:@"#FCFCFC"];
        [self.contentView addSubview:bgView];
        
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 22, 30, 30)];
        imageView1.image = [UIImage imageNamed:@"wechat"];
        [bgView addSubview:imageView1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 22, 200, 30)];
        label1.text = @"微信支付（人民币）";
        label1.textColor = TextColor;
        label1.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:label1];
        
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-60, 29.5, 15, 15)];
        [_btn1 setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
//        [_btn1 setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        _btn1.enabled = NO;
//        _btn1.selected = YES;
        [self.contentView addSubview:_btn1];
        
        UIImageView *aliImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 72, 30, 30)];
        aliImageView.image = [UIImage imageNamed:@"alipay"];
        [bgView addSubview:aliImageView];
        UILabel *alipayLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 72, 200, 30)];
        alipayLabel.text = @"支付宝支付（人民币）";
        alipayLabel.textColor = TextColor;
        alipayLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:alipayLabel];
        _aliBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-60, 79.5, 15, 15)];
        [_aliBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        _aliBtn.enabled = NO;
        [self.contentView addSubview:_aliBtn];
        
        
        UIButton *btnn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, G_SCREEN_WIDTH-20, 40)];
        [btnn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnn];
        
        UIButton *btnnn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, G_SCREEN_WIDTH-20, 40)];
        [btnnn addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnnn];
        
        
        _yueimageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 122, 30, 30)];
        _yueimageView.image = [UIImage imageNamed:@"pay_fill"];
        [bgView addSubview:_yueimageView];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 122, G_SCREEN_WIDTH-100, 30)];
        _label2.text = @"余额支付（当前余额:0）";
        _label2.textColor = TextColor;
        _label2.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:_label2];
        
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(8, 160, 300, 13)];
        _label3.text = @"当前余额不足，请选择其他付款方式";
        _label3.hidden = YES;
        _label3.textColor = MainColor;
        _label3.font = [UIFont systemFontOfSize:10];
        [bgView addSubview:_label3];
        
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-60, 129.5, 15, 15)];
        [_btn2 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
//        [_btn2 setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
//        [_btn2 addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn2];
        _btn2.enabled = NO;
        
        _btnn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 120, G_SCREEN_WIDTH-20, 40)];
        [_btnn1 addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnn1];
        
    }
    return self;
}

- (void)setWalletSum:(NSString *)walletSum
{
    if ([walletSum isKindOfClass:[NSNumber class]])
    {
        _walletSum = [NSString stringWithFormat:@"%@", walletSum];
    }
    else
        _walletSum = walletSum;
    
    NSString *temp = @"";
    if ([_walletSum containsString:@"人民币"])
    {
        temp = @"人民币";
    }
    else if ([_walletSum containsString:@"纽币"])
    {
        temp = @"纽币";
    }
    else
    {
        temp = @"";
    }
    
    if ([_walletSum containsString:@"null"] || [_walletSum isEqualToString:@"0"])
    {
        _label2.text = [NSString stringWithFormat:@"余额支付（当前余额:0）"];
    }
    else
    {
        NSString *pureNumbers = [[walletSum  componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:[pureNumbers floatValue]];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        
        _label2.text = [NSString stringWithFormat:@"余额支付（当前余额:%@%@）", roundedOunces,temp];
    }
    
    
}

- (void)setShowAlert:(BOOL)showAlert
{
    _showAlert = showAlert;
    _label3.hidden = !_showAlert;
    
    if (_showAlert)
    {
        _btnn1.enabled = NO;
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if (_selectIndex == 0)
    {
        [_btn1 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_aliBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        
    }
    else if (_selectIndex == 1)
    {
        [_btn1 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_aliBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    }
    else if (_selectIndex == 2)
    {
        [_btn1 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_aliBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    }
    else if (_selectIndex == 3)
    {
        [_btn1 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_btn2 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_aliBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
}

- (void)btnAction:(UIButton *)btn
{
    [_btn1 setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [_btn2 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    [_aliBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    _btn1.selected = YES;
    _btn2.selected = NO;
    _aliBtn.selected = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(onLineCellSelectedIndex:)])
    {
        [_delegate onLineCellSelectedIndex:1];
    }
}

- (void)btnAction1:(UIButton *)btn
{
    [_btn2 setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    [_aliBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(onLineCellSelectedIndex:)])
    {
        [_delegate onLineCellSelectedIndex:2];
    }
}

- (void)btnAction2:(UIButton *)btn
{
    [_btn2 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    [_btn1 setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    [_aliBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(onLineCellSelectedIndex:)])
    {
        [_delegate onLineCellSelectedIndex:3];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
