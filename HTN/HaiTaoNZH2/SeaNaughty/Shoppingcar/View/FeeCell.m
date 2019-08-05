//
//  FeeCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "FeeCell.h"

@interface FeeCell ()

//@property (nonatomic, strong) UIView *postageView;
@property (nonatomic, strong) UIView *postageFeeView;
@property (nonatomic, strong) UIView *totalFeeView;
@property (nonatomic, strong) UILabel *postageFeeLabel;
@property (nonatomic, strong) UILabel *totalFeeLabel;
@property (nonatomic, strong) UIView *btnView;

@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *midLabel;
@property (nonatomic, assign) BOOL hasYouhui;
@property (nonatomic, strong) NSMutableArray* bottomBtnArray; //存放了快递按钮的数组
@end

@implementation FeeCell

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
        [self.contentView addSubview:self.postageFeeView];
        [self.contentView addSubview:self.midView];
        [self.contentView addSubview:self.totalFeeView];
//        [self.contentView addSubview:self.youhuiLabel];
//        self.contentView addSubview:self
//        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setModel:(CartModel *)model
{
    _model = model;
    
    NSDictionary *dic = model.common;
    
    NSString *postage = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [dic valueForKey:@"firstShippingFee"],_model.secondCurrencyName,[dic valueForKey:@"secondShippingFee"]];
    
    if ([[dic valueForKey:@"firstShippingFee"] isEqual:@0])
    {
        postage = @"0";
    }
//
    NSString *disc = @"0";
    NSNumber *discount = [dic valueForKey:@"_firstDiscountAmount"];
    if ([discount floatValue] != 0)
    {
        _midView.hidden = NO;
        disc = [NSString stringWithFormat:@"-%@ %@/%@ %@", _model.firstCurrencyName, [dic valueForKey:@"_firstDiscountAmount"],_model.secondCurrencyName,[dic valueForKey:@"_secondDiscountAmount"]];
        _midLabel.text = disc;
        _hasYouhui = YES;
    }
    else
    {
        _midView.hidden = YES;
        _hasYouhui = NO;
    }
    
    NSString *total = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [dic valueForKey:@"firstTotalAmount"],_model.secondCurrencyName,[dic valueForKey:@"secondTotalAmount"]];
    
    if (!_model.firstCurrencyName)
    {
        postage = @"0";
        total = @"0";
    }
    
    if ([_model.checked isEqualToString:@"0"])
    {
        BOOL showMoney = NO;
        for (ProductModel *pp in _model.orderItems)
        {
            if ([pp.checked isEqualToString:@"1"])
            {
                showMoney = YES;
            }
        }
        if (!showMoney)
        {
            postage = @"0";
            total = @"0";
        }
    }
    
    _postageFeeLabel.text = postage;
    _totalFeeLabel.text = total;
    
}

- (void)setShowBtn:(BOOL)showBtn
{
    self.btnView.hidden = !showBtn;
    if (showBtn)
    {
        if (_hasYouhui)
        {
            self.postageFeeView.frame = CGRectMake(0, 65, G_SCREEN_WIDTH, 20);
            self.midView.frame = CGRectMake(0, 90, G_SCREEN_WIDTH, 20);
            self.totalFeeView.frame = CGRectMake(0, 115, G_SCREEN_WIDTH, 20);
        }
        else
        {
            self.postageFeeView.frame = CGRectMake(0, 85, G_SCREEN_WIDTH, 20);
            self.midView.frame = CGRectMake(0, 90, G_SCREEN_WIDTH, 20);
            self.totalFeeView.frame = CGRectMake(0, 115, G_SCREEN_WIDTH, 20);
        }
       
    }
    else
    {
        if (_hasYouhui)
        {
            self.postageFeeView.frame = CGRectMake(0, 45, G_SCREEN_WIDTH, 20);
            self.midView.frame = CGRectMake(0, 65, G_SCREEN_WIDTH, 20);
            self.totalFeeView.frame = CGRectMake(0, 85, G_SCREEN_WIDTH, 20);
        }
        else
        {
            self.postageFeeView.frame = CGRectMake(0, 12, G_SCREEN_WIDTH, 20);
//            self.midView.frame = CGRectMake(0, 25, G_SCREEN_WIDTH, 20);
            self.totalFeeView.frame = CGRectMake(0, 38, G_SCREEN_WIDTH, 20);
        }
        
    }

}

- (void)setCouriers:(NSArray<CouriersModel *> *)couriers {
    CouriersModel* cgModel;
    CouriersModel* ydtModel;
    CouriersModel* ftdModel;

    for (CouriersModel* model in couriers) {
        NSString* couriersId = [NSString stringWithFormat:@"%ld", model.couriersId];
        
        if ([couriersId isEqualToString:@"2"]) {
            cgModel = model;
        } else if ([couriersId isEqualToString:@"1000011"]) {
            ydtModel = model;
        } else if ([couriersId isEqualToString:@"1"]) {
            ftdModel = model;
        }
        if (cgModel && ydtModel && ftdModel) {
            break;
        }
    }
    NSArray* modelArray = @[cgModel, ydtModel, ftdModel];
    for (UIButton* btn in self.bottomBtnArray) {
        NSInteger i = [self.bottomBtnArray indexOfObject:btn];
        CouriersModel* model = [modelArray objectAtIndex:i];
        NSString* btnTitle = [NSString stringWithFormat:@"%@(每公斤%@%@/%@%@)", model.name, [model.price stringWithKey:@"firstCurrencyName"], [model.price stringWithKey:@"firstPrice"], [model.price stringWithKey:@"secondCurrencyName"], [model.price stringWithKey:@"secondPrice"]];
        CGFloat width = [YBIBUtilities calculateSingleStringSizeWithString:btnTitle andFont:btn.titleLabel.font].width + 20;

        btn.frame = CGRectMake(G_SCREEN_WIDTH-width, i*20, width, 20);
        
        [btn setTitle:btnTitle forState:UIControlStateNormal];
    }
}

- (UIView *)postageFeeView
{
    if (!_postageFeeView)
    {
        _postageFeeView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, G_SCREEN_WIDTH, 20)];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH, 20)];
        leftLabel.text = @"运费:";
        leftLabel.font = [UIFont systemFontOfSize:11];
        leftLabel.textColor = TextColor;
        [_postageFeeView addSubview:leftLabel];
        
        _postageFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-333, 0, 300, 20)];
        _postageFeeLabel.textColor = TextColor;
        _postageFeeLabel.textAlignment = NSTextAlignmentRight;
        _postageFeeLabel.font = [UIFont systemFontOfSize:11];
        [_postageFeeView addSubview:_postageFeeLabel];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-30, 3, 14, 14)];
        [btn setImage:[UIImage imageNamed:@"q-icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
        [_postageFeeView addSubview:btn];
        
    }
    return _postageFeeView;
}

- (UIView *)midView
{
    if (!_midView)
    {
        _midView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, G_SCREEN_WIDTH, 20)];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH, 20)];
        leftLabel.text = @"已优惠:";
        leftLabel.font = [UIFont systemFontOfSize:11];
        leftLabel.textColor = TextColor;
        [_midView addSubview:leftLabel];
        
        _midLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 0, 300, 20)];
        _midLabel.textColor = TextColor;
        _midLabel.textAlignment = NSTextAlignmentRight;
        _midLabel.font = [UIFont systemFontOfSize:11];
        [_midView addSubview:_midLabel];
    }
    return _midView;
}

- (UIView *)totalFeeView
{
    if (!_totalFeeView)
    {
        _totalFeeView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, G_SCREEN_WIDTH, 20)];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH, 20)];
        leftLabel.text = @"合计（含运费）:";
        leftLabel.font = [UIFont systemFontOfSize:11];
        leftLabel.textColor = TextColor;
        [_totalFeeView addSubview:leftLabel];
        
        _totalFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 0, 300, 20)];
        _totalFeeLabel.textColor = MainColor;
        _totalFeeLabel.textAlignment = NSTextAlignmentRight;
        _totalFeeLabel.font = [UIFont systemFontOfSize:11];
        [_totalFeeView addSubview:_totalFeeLabel];
        
    }
    return _totalFeeView;
}

- (UIView *)btnView
{
    if (!_btnView)
    {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, G_SCREEN_WIDTH, 60)];
        [self.contentView addSubview:_btnView];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 20)];
        leftLabel.text = @"选择快递:";
        leftLabel.font = [UIFont systemFontOfSize:11];
        leftLabel.textColor = TextColor;
        [_btnView addSubview:leftLabel];
        
        NSArray *array = @[@"程光",@"易达通",@"富腾达"];
        [self.bottomBtnArray removeAllObjects];
        for (int i=0; i<3; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-200+i*60, i*20, 60, 20)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(postageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"快递未选择"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"快递选择"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.bottomBtnArray addObject:btn];
            [_btnView addSubview:btn];
            if (i==0)
            {
                btn.selected = YES;
            }
        }
    }
    return _btnView;
}

- (void)postageBtnAction:(UIButton *)btn
{
    [self.btnView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *temp = obj;
            temp.selected = NO;
        }
    }];
    btn.selected = YES;
    _model.postageName = btn.titleLabel.text;
    
    self.block(_model);
}

- (void)detailAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextAlert" object:_model];
}

- (void)feeCellHandleAction:(FeeCellBlock)block
{
    _block = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSMutableArray*)bottomBtnArray {
    if (!_bottomBtnArray) {
        _bottomBtnArray = [NSMutableArray array];
    }
    return _bottomBtnArray;
}
@end
