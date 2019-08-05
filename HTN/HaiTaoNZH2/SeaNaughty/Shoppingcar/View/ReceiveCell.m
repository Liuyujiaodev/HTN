//
//  ConsigneeCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ReceiveCell.h"

@interface ReceiveCell () <UITextFieldDelegate>


@property (nonatomic, strong) NSMutableDictionary *param;

@end

@implementation ReceiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _param = [[NSMutableDictionary alloc] init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 18)];
        titleLabel.text = @"收货人信息";
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.textColor = TitleColor;
        [self.contentView addSubview:titleLabel];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-95, 10, 80, 18)];
        [rightBtn setTitle:@"常用收货人 >" forState:UIControlStateNormal];
        [rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightBtn addTarget:self action:@selector(goToRecent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, G_SCREEN_WIDTH-30, 195)];
        grayView.backgroundColor = [UIColor colorFromHexString:@"#FBFBFB"];
        grayView.layer.cornerRadius = 5;
        [self.contentView addSubview:grayView];
        
        NSArray *array = @[@"姓名:",@"电话:",@"区域:",@"地址:",@"身份证:"];
        for (int i=0; i<5; i++)
        {
            UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 39*i, 100, 38)];
            leftLabel.text = array[i];
            leftLabel.textColor = TextColor;
            leftLabel.font = [UIFont systemFontOfSize:11];
            [grayView addSubview:leftLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 39*(i+1)-1, G_SCREEN_WIDTH-60, 1)];
            lineView.backgroundColor = LineColor;
            [grayView addSubview:lineView];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(115, 39*i, G_SCREEN_WIDTH-160, 38)];
            textField.placeholder = @"必填";
            textField.textColor = TextColor;
            textField.font = [UIFont systemFontOfSize:11];
            textField.textAlignment = NSTextAlignmentRight;
            [grayView addSubview:textField];
//            textField.delegate = self;
            [textField addTarget:self action:@selector(textDidEdit:) forControlEvents:UIControlEventEditingChanged];
            textField.tag = 100+i;
            
            if (i == 2)
            {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(115, 79, G_SCREEN_WIDTH-160, 38)];
                [btn addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
                [grayView addSubview:btn];
                textField.enabled = NO;
            }
            
        }
        
        _nameText = [grayView viewWithTag:100];
        _phoneText = [grayView viewWithTag:101];
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        _proviceText = [grayView viewWithTag:102];
        _addressText = [grayView viewWithTag:103];
        _idCardText = [grayView viewWithTag:104];
        _idCardText.keyboardType = UIKeyboardTypePhonePad;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-165, 250, 150, 20)];
        [btn setTitle:@"   保存收货信息" forState:UIControlStateNormal];
        [btn setTitleColor:TextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setImage:[UIImage imageNamed:@"对号"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"框"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        _nameText.placeholder = @"(姓名务必与收件人身份证一致)必填";
        _proviceText.placeholder = @"(省、市、区/县)选填";
        
    }
    return self;
}

- (void)textDidEdit:(UITextField *)textField
{
    if (_nameText.text.length>0)
    {
        [_param setObject:_nameText.text forKey:@"receiveName"];
    }
    
    if (_phoneText.text.length > 0)
    {
        
        [_param setObject:_phoneText.text forKey:@"receivePhone"];

    }
    
    if (_addressText.text.length > 0)
    {
        [_param setObject:_addressText.text forKey:@"receiveAddress"];
    }
    
    if (_idCardText.text.length > 0)
    {
        
        [_param setObject:_idCardText.text forKey:@"receiveIdCard"];
      
    }
    
    self.block(_param);
}



- (void)saveAction:(UIButton *)btn
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    btn.selected = !btn.selected;
    
    if (btn.selected)
    {
        self.block(@{@"save":@"save"});
    }
    else
        self.block(@{@"unsave":@"unsave"});
    
}

- (void)handlerButtonAction:(ReceiveCellBlock)block
{
    self.block = block;
}

- (void)setMustHaveId:(BOOL)mustHaveId
{
    _mustHaveId = mustHaveId;
    
    if (!_mustHaveId)
    {
        _idCardText.placeholder = @"选填";
    }
    else
    {
        _idCardText.placeholder = @"必填";
    }
}

- (void)goToRecent
{
    if (_delegate && [_delegate respondsToSelector:@selector(receiveCellDidSelected)])
    {
        [_delegate receiveCellDidSelected];
    }
}

- (void)addressAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(presentAddressVC)])
    {
        [_delegate presentAddressVC];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
