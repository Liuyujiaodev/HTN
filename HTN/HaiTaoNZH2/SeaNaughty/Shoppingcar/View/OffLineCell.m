//
//  OffLineCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OffLineCell.h"

@interface OffLineCell ()

@property (nonatomic, strong) UILabel *currencyNamelabel;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *remarkLabel;
@property (nonatomic, strong) UILabel *accountNameLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation OffLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, G_SCREEN_WIDTH-24, 160)];
        _bgView.backgroundColor = [UIColor colorFromHexString:@"#FCFCFC"];
        [self.contentView addSubview:_bgView];
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 20, 25, 25)];
        leftImageView.image = [UIImage imageNamed:@"转账"];
        [_bgView addSubview:leftImageView];
        
        _currencyNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, G_SCREEN_WIDTH-60, 25)];
        _currencyNamelabel.font = [UIFont systemFontOfSize:13];
        _currencyNamelabel.textColor = [UIColor colorFromHexString:@"#616161"];
        [_bgView addSubview:_currencyNamelabel];
        
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-60, 25, 15, 15)];
        [_btn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        _btn.enabled = NO;
        [self.contentView addSubview:_btn];
        
        UIButton *btnn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, 0, 100, 100)];
        [btnn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnn];
        
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 60, G_SCREEN_WIDTH-40, 15)];
        _accountLabel.font = [UIFont systemFontOfSize:11];
        _accountLabel.textColor = LightGrayColor;
        [_bgView addSubview:_accountLabel];
        
        _bankNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 75, G_SCREEN_WIDTH-40, 15)];
        _bankNameLabel.font = [UIFont systemFontOfSize:11];
        _bankNameLabel.textColor = LightGrayColor;
        [_bgView addSubview:_bankNameLabel];
        
        _accountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 90, G_SCREEN_WIDTH-40, 15)];
        _accountNameLabel.font = [UIFont systemFontOfSize:11];
        _accountNameLabel.textColor = LightGrayColor;
        [_bgView addSubview:_accountNameLabel];
        
        
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 105, G_SCREEN_WIDTH-40, 55)];
        _remarkLabel.font = [UIFont systemFontOfSize:11];
        _remarkLabel.textColor = LightGrayColor;
        _remarkLabel.numberOfLines = 0;
        [_bgView addSubview:_remarkLabel];
    }
    return self;
}

- (void)setModel:(BankModel *)model
{
    _model = model;
    
    _currencyNamelabel.text = [NSString stringWithFormat:@"银行转账（%@）", _model.currencyName];
    
    _accountLabel.text = [NSString stringWithFormat:@"账号：%@", _model.account];
    
    _bankNameLabel.text = [NSString stringWithFormat:@"银行名称：%@", _model.bankName];
    
    _accountNameLabel.text = [NSString stringWithFormat:@"账户名称：%@", _model.accountName];
    
    NSString *remark = _model.remark;
    
    CGFloat height = [remark boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height+2;
    _remarkLabel.frame = CGRectMake(8, 105, G_SCREEN_WIDTH-40, height);
    
    _bgView.frame = CGRectMake(12, 0, G_SCREEN_WIDTH-24, height+120);
    
    _remarkLabel.text = remark;
    
    _btn.selected = _model.checked;
    
    if (!_model.checked)
    {
        [_btn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
    
    _btn.enabled = NO;
    
}

- (void)btnAction
{
    _btn.selected = !_btn.selected;

    _model.checked = _btn.selected;

    _btn.selected = _model.checked;

    if (!_model.checked)
    {
        [_btn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
    }
    else
    {
        [_btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }

    if (_delegate && [_delegate respondsToSelector:@selector(offLineSelected:)])
    {
        [_delegate offLineSelected:_model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
