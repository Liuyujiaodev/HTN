//
//  TextAlertView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/21.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "TextAlertView.h"

@interface TextAlertView ()

@property (nonatomic, strong) UIImageView *shadowView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *codeImageView;

@property (nonatomic, strong) UILabel *amountWeightLabel;
@property (nonatomic, strong) UILabel *freeWeightLabel;
@property (nonatomic, strong) UILabel *gudingLabel;
@property (nonatomic, strong) UILabel *notFreeWightLabel;
@property (nonatomic, strong) UILabel *payLabel;


@end

@implementation TextAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self addSubview:self.shadowView];
        [self.codeImageView addSubview:self.btn];
        [self addSubview:self.codeImageView];
        self.codeImageView.clipsToBounds = YES;
        self.codeImageView.layer.cornerRadius = 10;
    }
    return self;
}


- (UIImageView *)shadowView
{
    if (!_shadowView)
    {
        _shadowView = [[UIImageView alloc] initWithFrame:G_SCREEN_BOUNDS];
        _shadowView.userInteractionEnabled = YES;
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(hideAlert)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (void)hideAlert
{
    self.hidden = YES;
}

- (UIButton *)btn
{
    if (!_btn)
    {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 140, G_SCREEN_WIDTH-40, 40)];
        _btn.backgroundColor = MainColor;
        [_btn setTitle:@"我已知晓" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.clipsToBounds = YES;
        [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _btn;
}

- (UIView *)codeImageView
{
    if (!_codeImageView)
    {
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, G_SCREEN_WIDTH-40, 160)];
        
        _codeImageView.backgroundColor = [UIColor whiteColor];
        _codeImageView.userInteractionEnabled = YES;
        
        _amountWeightLabel = [self labelWithTop:20 textColor:TextColor];
        
        _freeWeightLabel = [self labelWithTop:40 textColor:TextColor];
        
        _notFreeWightLabel = [self labelWithTop:60 textColor:TextColor];
        
        _gudingLabel = [self labelWithTop:80 textColor:MainColor];
        
        _payLabel = [self labelWithTop:80 textColor:MainColor];
        
        [_codeImageView addSubview:_amountWeightLabel];
        [_codeImageView addSubview:_freeWeightLabel];
        [_codeImageView addSubview:_notFreeWightLabel];
        [_codeImageView addSubview:_gudingLabel];
        [_codeImageView addSubview:_payLabel];
        
    }
    return _codeImageView;
}

- (void)btnAction
{
    self.hidden = YES;
}

- (void)setModel:(CartModel *)model
{
    _model = model;
    
    NSDictionary *weightDic = model.shippingFeeDescription[@"common"];
    NSDictionary *commonDic = model.common;
    
    CartModel *weightModel = [CartModel yy_modelWithDictionary:weightDic];
    
    if (!model.firstCurrencyName || model.firstCurrencyName.length == 0)
    {
        model.firstCurrencyName = @"NZD $";
        model.secondCurrencyName = @"¥";
    }
    
    NSDictionary *moneyDic = model.freePostage;
    
    self.codeImageView.frame = CGRectMake(25, G_SCREEN_HEIGHT/2-80, G_SCREEN_WIDTH-50, 160);
    self.btn.frame = CGRectMake(0, 120, G_SCREEN_WIDTH-50, 40);
    
//    _gudingLabel.hidden = YES;
    
    NSString *money = @"0";
    if ([weightModel.firstNormalTotalFee floatValue] > 0)
    {
        money = [NSString stringWithFormat:@"%@%@/%@%@",moneyDic[@"firstCurrencyName"], weightModel.firstNormalTotalFee, moneyDic[@"secondCurrencyName"], weightModel.secondNormalTotalFee];
    }
    
    _amountWeightLabel.text = [NSString stringWithFormat:@"订单总重量：%@g", weightModel.orderTotalWeight];
    
    _freeWeightLabel.text = [NSString stringWithFormat:@"包邮重量：%@g", weightModel.freeTotalWeight];
    
    _notFreeWightLabel.text = [NSString stringWithFormat:@"不包邮重量：%@g 运费：%@",weightModel.normalTotalWeight,money];
    

    _payLabel.text = [NSString stringWithFormat:@"应付运费：%@%@/%@%@",model.firstCurrencyName, commonDic[@"firstShippingFee"], model.secondCurrencyName, commonDic[@"secondShippingFee"]];
    
    NSString *money1 = [NSString stringWithFormat:@"%@0/%@0",_model.firstCurrencyName, _model.secondCurrencyName];
    if (weightModel.firstFixedTotalFee && [weightModel.firstFixedTotalFee floatValue] > 0)
    {
        money1 = [NSString stringWithFormat:@"%@%@/%@%@",model.firstCurrencyName, weightModel.firstFixedTotalFee, model.secondCurrencyName, weightModel.secondFixedTotalFee];
        _gudingLabel.text = [NSString stringWithFormat:@"固定运费：%@", money1];
        
        _gudingLabel.frame = CGRectMake(12, 80, G_SCREEN_WIDTH-60, 20);
        
        _payLabel.frame = CGRectMake(12, 100, G_SCREEN_WIDTH-60, 20);
        
//        _notFreeWightLabel.frame = CGRectMake(12, 80, G_SCREEN_WIDTH-60, 20);
        
    }
    else
    {
        _gudingLabel.hidden = YES;
         _payLabel.frame = CGRectMake(12, 80, G_SCREEN_WIDTH-60, 20);
    }

    
    
}


- (void)setAllModel:(CartAllModel *)allModel
{
    _allModel = allModel;

    NSDictionary *weightDic = _allModel.shippingFeeDescription[@"common"];
    
    CartModel *weightModel = [CartModel yy_modelWithDictionary:weightDic];
    
    NSDictionary *moneyDic = _allModel.common;
    
    
    self.codeImageView.frame = CGRectMake(20, G_SCREEN_HEIGHT/2-90, G_SCREEN_WIDTH-40, 180);
    self.btn.frame = CGRectMake(0, 140, G_SCREEN_WIDTH-40, 40);
    
    _gudingLabel.hidden = NO;
    
    NSString *money = [NSString stringWithFormat:@"%@0/%@0",_allModel.firstCurrencyName,_allModel.secondCurrencyName];
    if ([weightModel.firstNormalTotalFee floatValue] > 0)
    {
        money = [NSString stringWithFormat:@"%@%@/%@%@",_allModel.firstCurrencyName, weightModel.firstNormalTotalFee, _allModel.secondCurrencyName, weightModel.secondNormalTotalFee];
    }
    
    NSString *money1 = [NSString stringWithFormat:@"%@0/%@0",_allModel.firstCurrencyName, _allModel.secondCurrencyName];
    if ([weightModel.firstFixedTotalFee floatValue] > 0)
    {
        money1 = [NSString stringWithFormat:@"%@%@/%@%@",_allModel.firstCurrencyName, weightModel.firstFixedTotalFee, _allModel.secondCurrencyName, weightModel.secondFixedTotalFee];
    }
    
    _amountWeightLabel.text = [NSString stringWithFormat:@"订单总重量：%@g", weightModel.orderTotalWeight];
    
    _freeWeightLabel.text = [NSString stringWithFormat:@"包邮重量：%@g", weightModel.freeTotalWeight];
    
    _notFreeWightLabel.text = [NSString stringWithFormat:@"不包邮重量：%@g 运费：%@",weightModel.normalTotalWeight,money];
    
    _gudingLabel.text = [NSString stringWithFormat:@"固定运费：%@", money1];
    
    _gudingLabel.frame = CGRectMake(12, 60, G_SCREEN_WIDTH-60, 20);
    
    _notFreeWightLabel.frame = CGRectMake(12, 80, G_SCREEN_WIDTH-56, 20);
    
    _payLabel.frame = CGRectMake(12, 100, G_SCREEN_WIDTH-60, 20);
    
    _payLabel.text = [NSString stringWithFormat:@"应付运费：%@%@/%@%@",_allModel.firstCurrencyName, moneyDic[@"firstShippingFee"], _allModel.secondCurrencyName, moneyDic[@"secondShippingFee"]];
    

}



- (UILabel *)labelWithTop:(CGFloat)top textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, top, G_SCREEN_WIDTH-50, 20)];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:12];
    
    return label;
}

@end
