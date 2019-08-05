//
//  CartProductCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CartProductCell.h"
#import <Masonry.h>

@interface CartProductCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *secondPriceLabel;
@property (nonatomic, strong) UILabel *postageLabel;
@property (nonatomic, strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *skuLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UITextField *numText;
@property (nonatomic, assign) int countNum;

@end

@implementation CartProductCell

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
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 45, 30, 30)];
//        _leftBtn.backgroundColor = MainColor;
        [_leftBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_leftBtn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftBtn];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 80, 100)];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_logoImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, G_SCREEN_WIDTH-170, 40)];
        _nameLabel.numberOfLines = 3;
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.textColor = TitleColor;
        [self.contentView addSubview:_nameLabel];
        
        _delBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-31, 10, 16, 16)];
        [_delBtn setImage:[UIImage imageNamed:@"del-icon"] forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_delBtn];
        
        _postageLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 45, G_SCREEN_WIDTH-170, 15)];
        _postageLabel.textColor = TextColor;
        _postageLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_postageLabel];
        
        _skuLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 60,  G_SCREEN_WIDTH-170, 15)];
        _skuLabel.font = [UIFont systemFontOfSize:10];
        _skuLabel.textColor = LightGrayColor;
        [self.contentView addSubview:_skuLabel];
        
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 75, G_SCREEN_WIDTH-170, 15)];
        _weightLabel.font = [UIFont systemFontOfSize:10];
        _weightLabel.textColor = LightGrayColor;
        [self.contentView addSubview:_weightLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 90, G_SCREEN_WIDTH-170, 15)];
        _priceLabel.textColor = MainColor;
        _priceLabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_priceLabel];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-100, 90, 85, 15)];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.font = [UIFont systemFontOfSize:10];
        _numLabel.textColor = TextColor;
        [self.contentView addSubview:_numLabel];
        
        [self.contentView addSubview:self.btnView];
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 119, G_SCREEN_WIDTH, 1)];
//        lineView.backgroundColor = LineColor;
//        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setModel:(ProductModel *)model
{
    _model = model;
    
    if ([_model.checked isEqualToString:@"1"])
    {
        _leftBtn.selected = YES;
//        _leftBtn.backgroundColor = MainColor;
        
        
        
        if (self.model.prefixName && model.firstPrice) {
            
            _nameLabel.text = [NSString stringWithFormat:@"%@\n%@",_model.prefixName,_model.name];
            [self setupAttributeString:_nameLabel.text highlightText:_model.prefixName];
            
        } else {
            _nameLabel.text = _model.name;
        }
        
        
    }
    else
    {
        _leftBtn.selected = NO;
//        _leftBtn.backgroundColor = LineColor;
        
        _nameLabel.text = _model.name;
        
    }
    
    _model.firstCurrencyName = @"NZD $";
    _model.secondCurrencyName = @"¥";
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl]];
    
    _countNum = [_model.quantity intValue];
    
    _numText.text = _model.quantity;
    
    
    _skuLabel.text = [NSString stringWithFormat:@"sku:%@",_model.sku];
    _weightLabel.text = [NSString stringWithFormat:@"重量:%@g",_model.weight];
    
    if (!_model.weight)
    {
        _weightLabel.text = [NSString stringWithFormat:@"重量:0g"];
    }
    
    NSString *tempString = @"";
    
    if ([_model.shopName isEqualToString:@"中国快快仓"] || [_model.shopName isEqualToString:@"全球精选仓"])
    {
        if (_model.unitFirstPrice)
        {
            _priceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_model.firstCurrencyName,[self moneyWithString:_model.unitFirstPrice],_model.secondCurrencyName,[self moneyWithString:_model.unitSecondPrice]];
        }
        else
        {
            _priceLabel.text = [NSString stringWithFormat:@"%@ 0/%@ 0",_model.firstCurrencyName,_model.secondCurrencyName];
        }
    }
    else
    {
        tempString = @"直邮价 ";
        _priceLabel.text = [NSString stringWithFormat:@"直邮价%@ %@/%@ %@",_model.firstCurrencyName,[self moneyWithString:_model.unitFirstPrice],_model.secondCurrencyName,[self moneyWithString:_model.unitSecondPrice]];
    }
    
    
    if ([_model.freePostage isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *freePostage = _model.freePostage;
        
        NSString *freePos = [NSString stringWithFormat:@"满%@%@/%@ %@包邮",_model.firstCurrencyName,[self moneyWithString:freePostage[@"firstThreshold"]],_model.secondCurrencyName,[self moneyWithString:freePostage[@"secondThreshold"]]];
        _postageLabel.text = freePos;
    }
    else
    {
        _postageLabel.text = @"";
    }
    
    
    
    if ([_model.giftSale isEqualToString:@"1"] || [_model.giftSale integerValue] == 1)
    {
#pragma mark - 换购商品
        self.btnView.hidden = YES;
        _numLabel.text = _model.quantity;
//
        _leftBtn.hidden = NO;
        if (_model.firstPrice)
        {
            _priceLabel.text = [NSString stringWithFormat:@"%@ %@/%@ %@",_model.firstCurrencyName,[self moneyWithString:_model.firstPrice],_model.secondCurrencyName,[self moneyWithString:_model.secondPrice]];
            _priceLabel.textColor = MainColor;
        }
        else
        {
//            _priceLabel.text = @"赠品 直邮价 0";
            _leftBtn.hidden = YES;
//            _priceLabel.text = [NSString stringWithFormat:@"赠品 %@0", tempString];
            _priceLabel.text = [NSString stringWithFormat:@"赠品"];
            _priceLabel.textColor = [UIColor redColor];
        }
        
       
    }
    else if ([_model.buyFree isEqualToString:@"1"])
    {
#pragma mark - 满赠商品
        self.btnView.hidden = YES;
        _leftBtn.hidden = YES;
        _numLabel.text = _model.quantity;
//        _priceLabel.text = @"赠品 直邮价 0";
//        _priceLabel.text = [NSString stringWithFormat:@"赠品 %@0", tempString];
        _priceLabel.text = [NSString stringWithFormat:@"赠品"];
        _priceLabel.textColor = [UIColor redColor];
    }
    else
    {
#pragma mark - 普通商品
        self.btnView.hidden = NO;
        _leftBtn.hidden = NO;
        _numLabel.text = @"";
        _priceLabel.textColor = MainColor;
    }
    
   
    _btnView.frame = CGRectMake(G_SCREEN_WIDTH-85, 90, 70, 20);
    
    if (_model.status && _model.status.length > 0 && ![_model.status isEqualToString:@"1"])
    {
        if ([_model.status isEqualToString:@"2"])
        {
//            _priceLabel.text = @"已下架";
            _priceLabel.text = [NSString stringWithFormat:@"%@已下架", tempString];
        }
    }
    else if (_model.stockStatus && [_model.stockStatus isEqualToString:@"0"])
    {
        
        if (_model.unitFirstPrice && _model.unitFirstPrice.length > 0)
        {
//            _priceLabel.text = @"直邮价 库存不足";
            _priceLabel.text = [NSString stringWithFormat:@"%@库存不足", tempString];
        }
        else
        {
//            _priceLabel.text = @"直邮价 库存不足，请修改数量或删除";
            _priceLabel.text = [NSString stringWithFormat:@"%@库存不足，请修改数量或删除", tempString];
            _btnView.frame = CGRectMake(G_SCREEN_WIDTH-85, 105, 70, 20);
        }
    }
    
    _delBtn.hidden = NO;
    
    
    if ([_model.stock isEqualToString:@"售罄"])
    {
        _priceLabel.text = @"直邮价 售罄";
    }
    
    if (_model.isAdd)
    {
        _postageLabel.hidden = YES;
        _leftBtn.hidden = YES;
        if (_model.stockStatus && [_model.stockStatus isEqualToString:@"0"])
        {
            _priceLabel.text = @"赠品已无货，不补发";
            _delBtn.hidden = YES;
            _numLabel.text = @"";
            _priceLabel.textColor = [UIColor redColor];
        }
        else if (_model.stockStatus && [_model.stockStatus isEqualToString:@"1"])
        {
            //            _priceLabel.text = @"赠品 直邮价:0";
//            _priceLabel.text = [NSString stringWithFormat:@"赠品 %@0", tempString];
            _priceLabel.text = [NSString stringWithFormat:@"赠品"];
            _numLabel.text = _model.quantity;
            _delBtn.hidden = NO;
            _priceLabel.textColor = [UIColor redColor];
        }
        else if ([_model.status isEqualToString:@"2"])
        {
            _priceLabel.text = @"赠品已无货，不补发";
            _delBtn.hidden = YES;
            _numLabel.text = @"";
            _priceLabel.textColor = [UIColor redColor];
        }
    }
    
    
    _priceLabel.preferredMaxLayoutWidth = G_SCREEN_WIDTH-215;
    _priceLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _priceLabel.numberOfLines = 0;
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(G_SCREEN_WIDTH-215);
        make.left.mas_equalTo(130);
        make.top.mas_equalTo(90);
    }];
    
}

- (void)deleteAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除商品？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self deleteProduct];
        
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    
    [_superVC presentViewController:alert animated:YES completion:nil];
}

- (void)deleteProduct
{
    
    if ([_model.buyFree isEqualToString:@"1"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteFrees" object:_model];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [hud showAnimated:YES];
        
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
        [param setObject:_model.productId forKey:@"productId"];
        [param setObject:_model.shopId forKey:@"shopId"];
        
        [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/delete-product" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            [hud hideAnimated:YES];
            if ([[result[@"code"] stringValue] isEqualToString:@"0"])
            {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [SVProgressHUD dismissWithDelay:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADPRODUCT" object:nil];
            }
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}





- (UIView *)btnView
{
    if (!_btnView)
    {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-85, 90, 70, 20)];
        
        UIButton *decreaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [decreaseBtn setTitle:@"-" forState:UIControlStateNormal];
        [decreaseBtn setTitleColor:TextColor forState:UIControlStateNormal];
        decreaseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        decreaseBtn.layer.borderColor = LightGrayColor.CGColor;
        decreaseBtn.layer.borderWidth = 1;
        [decreaseBtn addTarget:self action:@selector(decreaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:decreaseBtn];
        
        UIButton *increaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(55, 0, 15, 15)];
        [increaseBtn setTitle:@"+" forState:UIControlStateNormal];
        [increaseBtn setTitleColor:TextColor forState:UIControlStateNormal];
        increaseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        increaseBtn.layer.borderColor = LightGrayColor.CGColor;
        increaseBtn.layer.borderWidth = 1;
        [increaseBtn addTarget:self action:@selector(increaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:increaseBtn];
        
        _numText = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 30, 15)];
        _numText.layer.borderColor = LightGrayColor.CGColor;
        _numText.layer.borderWidth = 1;
        _numText.font = [UIFont systemFontOfSize:11];
        _numText.keyboardType = UIKeyboardTypeNumberPad;
        _numText.textAlignment = NSTextAlignmentCenter;
        _numText.delegate = self;
        _numText.textColor = TitleColor;
        [_btnView addSubview:_numText];
        
        
        
    }
    return _btnView;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _model.quantity = [NSString stringWithFormat:@"%@", textField.text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatenum" object:_model];
}

- (void)selectAction
{
    _leftBtn.selected = !_leftBtn.selected;
    
    _model.checked = [NSString stringWithFormat:@"%i", _leftBtn.selected];
    
    self.block(_model);
    
}

- (void)handlerButtonAction:(ProductModelBlock)block
{
    self.block = block;
}

- (void)decreaseBtnAction
{
    if (_countNum > 1)
    {
        _countNum --;
        _numText.text = [NSString stringWithFormat:@"%i", _countNum];
    }
    else if(_countNum == 1)
    {
        [SVProgressHUD showWithStatus:@"本产品一件起售"];
        [SVProgressHUD dismissWithDelay:1.2];
    }
    _model.quantity = [NSString stringWithFormat:@"%i", _countNum];
//    [self updateNum:_countNum];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatenum" object:_model];
}

- (void)updateNum:(int)num
{
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
////    NSString *strr = ;
//    [param setObject:[NSString stringWithFormat:@"%i", num] forKey:@"quantity"];
//    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
//    [param setObject:_model.productId forKey:@"productId"];
//    [param setObject:_model.shopId forKey:@"shopId"];
//
//    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/cart/update-qty" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
//
////        [hud hideAnimated:YES];
//
//        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
//        {
//            //            weakSelf.model = [CartAllModel yy_modelWithDictionary:result[@"data"]];
//            //
//            //            weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:weakSelf.model.detail];
//            //
//            //            if (weakSelf.dataArray.count > 0)
//            //            {
//            //                weakSelf.tableView.frame = CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-120-G_TABBAR_HEIGHT);
//            //                weakSelf.bottomView.hidden = NO;
//            //                weakSelf.feeView.model = weakSelf.model;
//            //                [weakSelf.numBtn setTitle:[NSString stringWithFormat:@"结算(%@)", weakSelf.model.checkedCount] forState:UIControlStateNormal];
//            //            }
//            //            [weakSelf.tableView reloadData];
////            [weakSelf getCartDetail];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatenum" object:_model];
//            _model.quantity = [NSString stringWithFormat:@"%i", _countNum];
//        }
//        else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
////                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
////                hud1.mode = MBProgressHUDModeText;
////                hud1.label.text = result[@"message"];
////                [hud1 hideAnimated:YES afterDelay:1.2];
//                [SVProgressHUD showErrorWithStatus:result[@"message"]];
//                [SVProgressHUD dismissWithDelay:1.2];
//            });
//        }
//
//    } fail:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
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

- (void)increaseBtnAction
{
    _countNum ++;
    _numText.text = [NSString stringWithFormat:@"%i", _countNum];
    _model.quantity = [NSString stringWithFormat:@"%i", _countNum];
//    [self updateNum:_countNum];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updatenum" object:_model];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 富文本部分字体飘灰
- (NSMutableAttributedString *)setupAttributeString:(NSString *)text highlightText:(NSString *)highlightText {
    NSRange hightlightTextRange = [text rangeOfString:highlightText];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    if (hightlightTextRange.length > 0) {
        [attributeStr addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:hightlightTextRange];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:10.0f] range:hightlightTextRange];
        self.nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.nameLabel.attributedText = attributeStr;
        return attributeStr;
    }else {
        return [highlightText copy];
    }
}

@end
