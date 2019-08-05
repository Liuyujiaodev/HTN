//
//  SecondSectionCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/15.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "SecondSectionCell.h"
#import <YYLabel.h>

@interface SecondSectionCell ()

@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *phoneLabel;
@property (nonatomic, strong) YYLabel *addressLabel;
@property (nonatomic, strong) YYLabel *idLabel;
@property (nonatomic, strong) UIView *sendView;
@property (nonatomic, strong) YYLabel *sendNameLabel;
@property (nonatomic, strong) YYLabel *sendPhoneLabel;
@property (nonatomic, strong) YYLabel *sendAddressLabel;

@end

@implementation SecondSectionCell

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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 18, 12)];
        imageView.image = [UIImage imageNamed:@"收货人信息"];
        [self.contentView addSubview:imageView];
        
        _nameLabel = [[YYLabel alloc] initWithFrame:CGRectMake(40, 10, 200, 16)];
        _nameLabel.textColor = TitleColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        MJWeakSelf;
        _nameLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.model.receiveName)
            {
                [SVProgressHUD showSuccessWithStatus:@"姓名复制成功"];
                UIPasteboard * paste = [UIPasteboard generalPasteboard];
                paste.string = weakSelf.model.receiveName;
                [SVProgressHUD dismissWithDelay:0.6];
            }
            
        };
        
        [self.contentView addSubview:_nameLabel];

        _phoneLabel = [[YYLabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 10, 300, 16)];
        _phoneLabel.textColor = TitleColor;
        _phoneLabel.textAlignment = NSTextAlignmentRight;
        _phoneLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_phoneLabel];
        _phoneLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.model.receivePhone)
            {
                [SVProgressHUD showSuccessWithStatus:@"手机号复制成功"];
                UIPasteboard * paste = [UIPasteboard generalPasteboard];
                paste.string = weakSelf.model.receivePhone;
                [SVProgressHUD dismissWithDelay:0.6];
            }
        };
        
        _addressLabel = [[YYLabel alloc] initWithFrame:CGRectMake(35, 36, G_SCREEN_WIDTH-50, 16)];
        _addressLabel.textColor = TextColor;
        _addressLabel.numberOfLines = 0;
        _addressLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_addressLabel];
        _addressLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.model.receiveAddress)
            {
                NSString *str = @"";
                if (weakSelf.model.receiveArea)
                {
                    str = weakSelf.model.receiveArea;
                }
                
                [SVProgressHUD showSuccessWithStatus:@"收货地址复制成功"];
                UIPasteboard * paste = [UIPasteboard generalPasteboard];
                paste.string = [NSString stringWithFormat:@"%@ %@ %@ %@", weakSelf.model.receiveProvince, weakSelf.model.receiveCity, str, weakSelf.model.receiveAddress];
                [SVProgressHUD dismissWithDelay:0.6];
            }
        };
        
        _idLabel = [[YYLabel alloc] initWithFrame:CGRectMake(35, 65, G_SCREEN_WIDTH-50, 16)];
        _idLabel.textColor = TextColor;
        _idLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_idLabel];
        
        _idLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.model.receiveIdCard)
            {
                [SVProgressHUD showSuccessWithStatus:@"身份证号复制成功"];
                UIPasteboard * paste = [UIPasteboard generalPasteboard];
                paste.string = weakSelf.model.receiveIdCard;
                [SVProgressHUD dismissWithDelay:0.6];
            }
        };
        
        [self.contentView addSubview:self.sendView];
        self.sendView.hidden = YES;
    }
    return self;
}


- (void)setModel:(OrderModel *)model
{
    _model = model;
    
    _nameLabel.text = _model.receiveName;
    
    _phoneLabel.text = _model.receivePhone;
    
    NSString *str = @"";
    
    if (_model.receiveArea)
    {
        str = _model.receiveArea;
    }
    
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", _model.receiveProvince, _model.receiveCity, str, _model.receiveAddress];
    
    
    CGFloat height = [_addressLabel.text boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height+3;
    
    _addressLabel.frame = CGRectMake(35, 36, G_SCREEN_WIDTH-50, height);
    
    if (_model.receiveIdCard && _model.receiveIdCard.length > 0)
    {
        _idLabel.frame = CGRectMake(35, 40+height, G_SCREEN_WIDTH-50, 16);
        _idLabel.text = [NSString stringWithFormat:@"身份证号：%@",_model.receiveIdCard];
    }
    
    if (_model.sendName.length>0 || _model.sendPhone.length>0 || _model.sendAddress.length>0)
    {
        _sendView.frame = CGRectMake(0, 64+height, G_SCREEN_WIDTH, 60);
        self.sendView.hidden = NO;
        if (_model.sendName)
        {
            _sendNameLabel.text = _model.sendName;
        }
        
        if (_model.sendAddress)
        {
            _sendAddressLabel.text = _model.sendAddress;
        }
        
        if (_model.sendPhone)
        {
            _sendPhoneLabel.text = _model.sendPhone;
        }
    }
    
}

- (UIView *)sendView
{
    if (!_sendView)
    {
        _sendView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, G_SCREEN_WIDTH, 100)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 16, 16)];
        imageView.image = [UIImage imageNamed:@"send.png"];
        [_sendView addSubview:imageView];
        
        _sendNameLabel = [[YYLabel alloc] initWithFrame:CGRectMake(40, 10, 200, 16)];
        _sendNameLabel.textColor = TitleColor;
        _sendNameLabel.font = [UIFont systemFontOfSize:13];
        [_sendView addSubview:_sendNameLabel];
        
        _sendPhoneLabel = [[YYLabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 10, 300, 16)];
        _sendPhoneLabel.textColor = TitleColor;
        _sendPhoneLabel.textAlignment = NSTextAlignmentRight;
        _sendPhoneLabel.font = [UIFont systemFontOfSize:13];
        [_sendView addSubview:_sendPhoneLabel];
        
        _sendAddressLabel = [[YYLabel alloc] initWithFrame:CGRectMake(35, 36, G_SCREEN_WIDTH-50, 16)];
        _sendAddressLabel.textColor = TextColor;
        _sendAddressLabel.numberOfLines = 0;
        _sendAddressLabel.font = [UIFont systemFontOfSize:13];
        [_sendView addSubview:_sendAddressLabel];
        
    }
    return _sendView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
