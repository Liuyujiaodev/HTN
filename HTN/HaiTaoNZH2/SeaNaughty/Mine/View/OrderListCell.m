//
//  OrderListCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/8.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OrderListCell.h"
#import <YYText.h>
#import <Masonry.h>
#import "WuliuViewController.h"

@interface OrderListCell ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *idCardLabel;
@property (nonatomic, strong) UILabel *expressLabel;
@property (nonatomic, strong) UILabel *shippingNumberLabel;
@property (nonatomic, strong) UILabel *totalFeeLabel;
@property (nonatomic, strong) UILabel *shippingFeeLabel;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UILabel *leftLabel1;
@property (nonatomic, strong) UILabel *leftLabel2;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) NSArray *statusArray;
@property (nonatomic, assign) CGFloat cellHight;
@property (nonatomic, strong) YYLabel *yylabel1;
@property (nonatomic, strong) YYLabel *yylabel2;
@property (nonatomic, strong) YYLabel *yylabel3;
@property (nonatomic, strong) YYLabel *yylabel4;
@property (nonatomic, strong) YYLabel *yylabel5;
@property (nonatomic, strong) YYLabel *yylabel6;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UIImageView *miandanImage;
@property (nonatomic, strong) UILabel *memoLabel;
@property (nonatomic, strong) UIView *memoLineView;

@end

@implementation OrderListCell

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
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 8)];
        topView.backgroundColor = LineColor;
        [self.contentView addSubview:topView];
        
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 16, 16)];
        [_leftBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_leftBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.hidden = YES;
        [self.contentView addSubview:_leftBtn];
        
        _memoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH, 0)];
        [self.contentView addSubview:_memoLabel];
        _memoLabel.textColor = LightGrayColor;
        _memoLabel.font = [UIFont systemFontOfSize:13];
        
        _memoLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        _memoLineView.backgroundColor = LineColor;
        _memoLineView.hidden = YES;
        [self.contentView addSubview:_memoLineView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, G_SCREEN_WIDTH-60, 20)];
        _numLabel.textColor = TitleColor;
        _numLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_numLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-150, 18, 135, 20)];
        _statusLabel.textColor = MainColor;
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_statusLabel];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 46, G_SCREEN_WIDTH-30, 100)];
        _bgView.backgroundColor = [UIColor colorFromHexString:@"#FAFAFA"];
        _bgView.layer.cornerRadius = 5;
        [self.contentView addSubview:_bgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, G_SCREEN_WIDTH-50, 30)];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = LightGrayColor;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_nameLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, G_SCREEN_WIDTH-50, 30)];
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = LightGrayColor;
        _addressLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_addressLabel];
        
        _idCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, G_SCREEN_WIDTH-50, 20)];
        _idCardLabel.textColor = LightGrayColor;
        _idCardLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_idCardLabel];
        
        _leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 166, 100, 15)];
        _leftLabel1.textColor = LightGrayColor;
        _leftLabel1.text = @"合计：";
        _leftLabel1.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_leftLabel1];
        
        _totalFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 166, 300, 15)];
        _totalFeeLabel.textColor = MainColor;
        _totalFeeLabel.font = [UIFont systemFontOfSize:12];
        _totalFeeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_totalFeeLabel];
        
        _leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 184, 100, 15)];
        _leftLabel2.textColor = LightGrayColor;
        _leftLabel2.text = @"含运费：";
        _leftLabel2.font = [UIFont systemFontOfSize:12];
        _leftLabel2.hidden = YES;
        [self.contentView addSubview:_leftLabel2];
        
        _shippingFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 184, 300, 15)];
        _shippingFeeLabel.textColor = LightGrayColor;
        _shippingFeeLabel.font = [UIFont systemFontOfSize:12];
        _shippingFeeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_shippingFeeLabel];
        
        
        _expressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 166, G_SCREEN_WIDTH-30, 15)];
        _expressLabel.textColor = LightGrayColor;
        _expressLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_expressLabel];
        
        _shippingNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 184, 90, 15)];
        _shippingNumberLabel.textColor = LightGrayColor;
        _shippingNumberLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_shippingNumberLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, G_SCREEN_WIDTH, 1)];
        _lineView.backgroundColor = LineColor;
        _lineView.hidden = YES;
        [self.contentView addSubview:_lineView];
        
        
        _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 200, G_SCREEN_WIDTH, 1)];
        _lineView1.backgroundColor = LineColor;
        [self.contentView addSubview:_lineView1];
        
        for (int i=4; i>0; i--)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-90*i, 200, 80, 30)];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.layer.cornerRadius = 2;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = LightGrayColor.CGColor;
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            
            [self.contentView addSubview:btn];
            btn.tag = 900+i;
            btn.hidden = YES;
            [btn addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _btn1 = [self.contentView viewWithTag:901];
        _btn2 = [self.contentView viewWithTag:902];
        _btn3 = [self.contentView viewWithTag:903];
        _btn4 = [self.contentView viewWithTag:904];
        
        _btnArray = [[NSMutableArray alloc] init];
        
        
        _yylabel1 = [self addYYLabel];
        [self.contentView addSubview:_yylabel1];
        
        [_yylabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(_shippingNumberLabel);
            make.left.equalTo(_shippingNumberLabel.mas_right);
        }];
        
        _yylabel2 = [self addYYLabel];
        [self.contentView addSubview:_yylabel2];
        
        [_yylabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_shippingNumberLabel);
//            make.left.equalTo(_yylabel1.mas_right).offset(8);
            make.top.mas_equalTo(_yylabel1.mas_bottom);
            make.left.equalTo(_yylabel1);
        }];
        
        
        _yylabel3 = [self addYYLabel];
        [self.contentView addSubview:_yylabel3];
        
        [_yylabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.height.equalTo(_shippingNumberLabel);
//            make.left.equalTo(_yylabel2.mas_right).offset(8);
            make.height.equalTo(_shippingNumberLabel);
            //            make.left.equalTo(_yylabel1.mas_right).offset(8);
            make.top.mas_equalTo(_yylabel2.mas_bottom);
            make.left.equalTo(_yylabel1);
        }];
        
        _yylabel4 = [self addYYLabel];
        [self.contentView addSubview:_yylabel4];
        
        [_yylabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_shippingNumberLabel);
            //            make.left.equalTo(_yylabel1.mas_right).offset(8);
            make.top.mas_equalTo(_yylabel3.mas_bottom);
            make.left.equalTo(_yylabel1);
        }];
        
        _yylabel5 = [self addYYLabel];
        [self.contentView addSubview:_yylabel5];
        
        [_yylabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_shippingNumberLabel);
            //            make.left.equalTo(_yylabel1.mas_right).offset(8);
            make.top.mas_equalTo(_yylabel4.mas_bottom);
            make.left.equalTo(_yylabel1);
        }];
        
        _yylabel6 = [self addYYLabel];
        [self.contentView addSubview:_yylabel6];
        
        [_yylabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(_shippingNumberLabel);
            //            make.left.equalTo(_yylabel1.mas_right).offset(8);
            make.top.mas_equalTo(_yylabel5.mas_bottom);
            make.left.equalTo(_yylabel1);
        }];
        
        
        _miandanImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _miandanImage.image = [UIImage imageNamed:@"免单"];
        [self.contentView addSubview:_miandanImage];
        
    }
    return self;
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    _numLabel.text = [NSString stringWithFormat:@"订单编号 : %@", _model.orderNumber];
    _statusLabel.text = self.statusArray[_model.status-1];
    
    if (_model.status == 3 && _model.isPay)
    {
        _statusLabel.text = @"已支付";
    }
    else if (_model.status == 3 && !_model.isPay && [[[NSUserDefaults standardUserDefaults] valueForKey:@""] isEqualToString:@"1"])
    {
        _statusLabel.text = @"待确认";
    }
    
    
    
    NSString *name = [NSString stringWithFormat:@"收件人：%@        电话：%@", _model.receiveName, _model.receivePhone];
    
    CGFloat height1 = [name boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+5;
    
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:name];
    [nameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 3)];
    [nameStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(12+_model.receiveName.length, 2)];
    _nameLabel.attributedText = nameStr;
    _nameLabel.frame = CGRectMake(10, 6, G_SCREEN_WIDTH-50, height1);
    
    NSString *receive = @"";
    if (_model.receiveArea)
    {
        receive = _model.receiveArea;
    }
    
   
    
    NSString *address = [NSString stringWithFormat:@"地址：%@ %@ %@ %@", _model.receiveProvince, _model.receiveCity, receive, _model.receiveAddress];
    
    CGFloat height2 = [address boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.height+5;
    
    NSMutableAttributedString *addressStr = [[NSMutableAttributedString alloc] initWithString:address];
    [addressStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 2)];
    
    _addressLabel.attributedText = addressStr;
    _addressLabel.frame = CGRectMake(10, 8+height1, G_SCREEN_WIDTH-50, height2);
    
    CGFloat tempHeight1 = height1+height2;
    CGFloat bgViewBottom ;
    if (_model.receiveIdCard.length > 0)
    {
        NSString *idStr = [NSString stringWithFormat:@"身份证号：%@", _model.receiveIdCard];
        NSMutableAttributedString *idString = [[NSMutableAttributedString alloc] initWithString:idStr];
        [idString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
        _idCardLabel.attributedText = idString;
        _idCardLabel.frame = CGRectMake(10, 12+tempHeight1, G_SCREEN_WIDTH, 20);
        _bgView.frame = CGRectMake(15, 42, G_SCREEN_WIDTH-30, tempHeight1+36);
        bgViewBottom = tempHeight1 + 80;
    }
    else
    {
        _idCardLabel.text = @"";
        _bgView.frame = CGRectMake(15, 42, G_SCREEN_WIDTH-30, tempHeight1+18);
        bgViewBottom = tempHeight1 + 60;
    }
   
    
    NSString *totalFee = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [self moneyWithString:_model.firstAmount], _model.secondCurrencyName, [self moneyWithString:_model.secondAmount]];
    
    NSString *shipFee = @"";
    
   
    
    CGFloat lineBottom;
    
    if (_model.shippingNumber.length > 0)
    {
        _expressLabel.hidden = NO;
        _shippingNumberLabel.hidden = NO;
        NSString *courier = [NSString stringWithFormat:@"快递公司：%@", _model.courierName];
        NSMutableAttributedString *courierStr = [[NSMutableAttributedString alloc] initWithString:courier];
        [courierStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
        
        _expressLabel.attributedText = courierStr;
        _expressLabel.frame = CGRectMake(15, 6+bgViewBottom, G_SCREEN_WIDTH-30, 15);
 
        NSString *shippingNum = [NSString stringWithFormat:@"快递单号："];
        NSMutableAttributedString *shippingNumStr = [[NSMutableAttributedString alloc] initWithString:shippingNum];
        [shippingNumStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 4)];
        
        _shippingNumberLabel.attributedText = shippingNumStr;
        _shippingNumberLabel.frame = CGRectMake(15, bgViewBottom+22, 60, 15);
        
    
        
        NSArray *array = [_model.shippingNumber componentsSeparatedByString:@","];
        
       
        
        for (int i=0; i<array.count; i++)
        {
            NSString *wuliuNum = array[i];
            NSMutableAttributedString *strr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  物流追踪", wuliuNum]];
            
            [strr addAttribute:NSForegroundColorAttributeName value:TextColor range:NSMakeRange(0, wuliuNum.length)];
            
            [strr yy_setTextHighlightRange:NSMakeRange(wuliuNum.length, 6) color:[UIColor colorFromHexString:@"#0EA5EA"] backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                WuliuViewController *vc = [[WuliuViewController alloc] init];
                vc.shippingNumber = wuliuNum;
                vc.courierCode = _model.courierCode;
                vc.courierName = _model.courierName;
                vc.website = _model.website;
                [self.fatherVC.navigationController pushViewController:vc animated:YES];
                
            }];
            
            if (i == 0)
            {
                _yylabel1.attributedText = strr;
            }
            else if (i == 1)
            {
                _yylabel2.attributedText = strr;
            }
            else if (i == 2)
            {
                _yylabel3.attributedText = strr;
            }
            else if (i == 3)
            {
                _yylabel4.attributedText = strr;
            }
            else if (i==4)
            {
                _yylabel5.attributedText = strr;
            }
            else if (i==5)
            {
                _yylabel6.attributedText = strr;
            }
            
            [_yylabel1 needsUpdateConstraints];
            [_yylabel2 needsUpdateConstraints];
            [_yylabel3 needsUpdateConstraints];
            [_yylabel4 needsUpdateConstraints];
            
            [_yylabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_shippingNumberLabel.mas_right);
            }];
            
            [_yylabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_yylabel1.mas_bottom);
            }];
            
           
            
            [_yylabel3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_yylabel2.mas_bottom);
            }];
            
            [_yylabel4 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_yylabel3.mas_bottom);
            }];
            
            [_yylabel5 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_yylabel4.mas_bottom);
            }];
            
            [_yylabel6 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_yylabel5.mas_bottom);
            }];
            
        }
        
        if (array.count == 1)
        {
            _yylabel2.text = @"";
            _yylabel3.text = @"";
            _yylabel4.text = @"";
            _yylabel5.text = @"";
            _yylabel6.text = @"";
        }
        
        if (array.count == 2)
        {
            _yylabel3.text = @"";
            _yylabel4.text = @"";
            _yylabel5.text = @"";
            _yylabel6.text = @"";
        }
        
        if (array.count == 3)
        {
            _yylabel4.text = @"";
            _yylabel5.text = @"";
            _yylabel6.text = @"";
        }
        if (array.count == 4)
        {
            _yylabel5.text = @"";
            _yylabel6.text = @"";
        }
        
        if (array.count == 5)
        {
            _yylabel6.text = @"";
        }
        
        _lineView.hidden = NO;
        _lineView.frame = CGRectMake(0, 22+bgViewBottom+array.count*20, G_SCREEN_WIDTH, 1);
        
        lineBottom = 30+bgViewBottom+array.count*20;
       
    }
    else
    {
        _expressLabel.hidden = YES;
        _shippingNumberLabel.hidden = YES;
        _lineView.hidden = YES;
        _yylabel1.text = @"";
        _yylabel2.text = @"";
        _yylabel3.text = @"";
        _yylabel4.text = @"";
        _yylabel5.text = @"";
        _yylabel6.text = @"";
        lineBottom = bgViewBottom+10;
    }
    

    
    if (_model.customerComment && _model.customerComment.length > 0)
    {
        _memoLabel.text = [NSString stringWithFormat:@"备注：%@", _model.customerComment];
        _memoLabel.frame = CGRectMake(15, lineBottom-5, G_SCREEN_WIDTH-30, 15);
        _memoLineView.frame = CGRectMake(0, lineBottom+13, G_SCREEN_WIDTH, 1);
        _memoLabel.hidden = NO;
        _memoLineView.hidden = NO;
        lineBottom = lineBottom + 17;
    }
    else
    {
        _memoLineView.hidden = YES;
        _memoLabel.text = @"";
        _memoLabel.hidden = YES;
    }
    
    
    _leftLabel1.frame = CGRectMake(15, lineBottom, 100, 15);
    _leftLabel2.frame = CGRectMake(15, lineBottom+18, 100, 15);
    
    _totalFeeLabel.frame = CGRectMake(G_SCREEN_WIDTH-315, lineBottom, 300, 15);
    _shippingFeeLabel.frame = CGRectMake(G_SCREEN_WIDTH-315, lineBottom+18, 300, 15);
    
    
    
    if (_model.firstShippingFeeAmount.length > 0)
    {
        _leftLabel2.hidden = NO;
        shipFee = [NSString stringWithFormat:@"%@ %@/%@ %@", _model.firstCurrencyName, [self moneyWithString:_model.firstShippingFeeAmount], _model.secondCurrencyName, [self moneyWithString:_model.secondShippingFeeAmount]];
        _lineView1.frame = CGRectMake(0, lineBottom+40, G_SCREEN_WIDTH, 1);
//        _cellHight = lineBottom+62;
        _btn2.frame = CGRectMake(G_SCREEN_WIDTH-160, lineBottom+50, 70, 20);
        _btn1.frame = CGRectMake(G_SCREEN_WIDTH-80, lineBottom+50, 70, 20);
        _btn3.frame = CGRectMake(G_SCREEN_WIDTH-240, lineBottom+50, 70, 20);
        _btn4.frame = CGRectMake(G_SCREEN_WIDTH-320, lineBottom+50, 70, 20);
    }
    else
    {
        _leftLabel2.hidden = YES;
        _lineView1.frame = CGRectMake(0, lineBottom+23, G_SCREEN_WIDTH, 1);
        _btn2.frame = CGRectMake(G_SCREEN_WIDTH-160, lineBottom+33, 70, 20);
        _btn1.frame = CGRectMake(G_SCREEN_WIDTH-80, lineBottom+33, 70, 20);
        _btn3.frame = CGRectMake(G_SCREEN_WIDTH-240, lineBottom+33, 70, 20);
        _btn4.frame = CGRectMake(G_SCREEN_WIDTH-320, lineBottom+33, 70, 20);
    }
    _totalFeeLabel.text = totalFee;
    _shippingFeeLabel.text = shipFee;
    if ([_model.totalAmount floatValue] == 0)
    {
        _totalFeeLabel.hidden = YES;
        _shippingFeeLabel.hidden = YES;
        _miandanImage.hidden = NO;
        _miandanImage.frame = CGRectMake(G_SCREEN_WIDTH-60, lineBottom, 40, 30);
    }
    else
    {
        _miandanImage.hidden = YES;
        _totalFeeLabel.hidden = NO;
        _shippingFeeLabel.hidden = NO;
    }
    
    [_btnArray removeAllObjects];
    _btn1.hidden = YES;
    _btn2.hidden = YES;
    _btn3.hidden = YES;
    _btn4.hidden = YES;
    
    if (_model.shipPhotoUrl && _model.shipPhotoUrl.length > 0)
    {
        [_btnArray addObject:@"实拍照片"];
    }
    
    if (_model.shipImgUrl && _model.shipImgUrl.length > 0)
    {
        [_btnArray addObject:@"面单照片"];
    }
    
    
    
    
    if (_model.status == 3 && !_model.isPay)
    {
        _leftBtn.hidden = NO;
        _numLabel.frame = CGRectMake(40, 18, 300, 20);
        [_btnArray addObjectsFromArray:@[@"联系客服",@"去付款"]];
    }
    else if (_model.status == 3 && _model.isPay)
    {
        _leftBtn.hidden = NO;
        _numLabel.frame = CGRectMake(40, 18, 300, 20);
        [_btnArray addObject:@"联系客服"];
    }
    else
    {
        _leftBtn.hidden = YES;
        _numLabel.frame = CGRectMake(15, 18, 300, 20);
        
        if (_model.status == 6 || _model.status == 8)
        {
//            [_btn1 setTitle:@"删除" forState:UIControlStateNormal];
//            [_btn2 setTitle:@"联系客服" forState:UIControlStateNormal];
            [_btnArray addObjectsFromArray:@[@"联系客服",@"删除"]];
        }
        else if (_model.status == 4 || _model.status == 7 || _model.status == 5)
        {
//            _btn1.hidden = YES;
//            [_btn2 setTitle:@"联系客服" forState:UIControlStateNormal];
            [_btnArray addObjectsFromArray:@[@"联系客服"]];
        }
        else if (_model.status == 9 || _model.status == 10)
        {
//            _btn1.hidden = YES;
//            [_btn2 setTitle:@"联系客服" forState:UIControlStateNormal];
            [_btnArray addObjectsFromArray:@[@"联系客服"]];
        }
    }
    
    
    for (int i=(int)_btnArray.count; i>0; i--)
    {
        UIButton *btn = [self.contentView viewWithTag:900+i];
        btn.hidden = NO;
        
        [btn setTitle:_btnArray[i-1] forState:UIControlStateNormal];
        
        if ([_btnArray[i-1] isEqualToString:@"去付款"])
        {
            [btn setTitleColor:MainColor forState:UIControlStateNormal];
            btn.layer.borderColor = MainColor.CGColor;
        }
        else
        {
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            btn.layer.borderColor = LightGrayColor.CGColor;
        }
    }
    
    _leftBtn.selected = _model.orderSelected;
    
}

- (void)btnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    _model.orderSelected = btn.selected;

    self.block(_model);
}




- (void)handlerButtonAction:(OrderListCellBlock)block
{
    self.block = block;
}

- (void)btnAction1:(UIButton *)btn
{
    _model.btnName = btn.titleLabel.text;
    self.block(_model);
}


- (YYLabel *)addYYLabel
{
    YYLabel *label = [YYLabel new];
    label.textColor = LightGrayColor;
    label.preferredMaxLayoutWidth = G_SCREEN_WIDTH-100;
    label.font = [UIFont systemFontOfSize:11];
    label.numberOfLines = 0;
    return label;
}

- (NSArray *)statusArray
{
    if (!_statusArray)
    {
        _statusArray = [NSArray arrayWithObjects: @"草稿",@"预定",@"未支付",@"待发货",@"已发货",@"已取消",@"备货中",@"已确认收货",@"已发货",@"已发货", nil];
    }
    return _statusArray;
}


- (NSString *)moneyWithString:(NSString *)str
{
    CGFloat price = [str floatValue];
    if (str.length > 8)
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
