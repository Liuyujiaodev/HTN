//
//  DeliverCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "DeliverCell.h"
@interface DeliverCell ()

@property (nonatomic, strong) NSMutableDictionary *param;

@end

@implementation DeliverCell

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
        NSString *str = @"发货人信息 将出现在快递单发件人位置";
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textColor = LightGrayColor;
        NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:str];
        [astr addAttribute:NSForegroundColorAttributeName value:TitleColor range:NSMakeRange(0, 5)];
        [astr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 5)];
        titleLabel.attributedText = astr;
        [self.contentView addSubview:titleLabel];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-95, 10, 80, 18)];
        [rightBtn setTitle:@"常用发货人 >" forState:UIControlStateNormal];
        [rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightBtn addTarget:self action:@selector(goToRecent) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:rightBtn];
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, G_SCREEN_WIDTH-30, 117)];
        grayView.backgroundColor = [UIColor colorFromHexString:@"#FBFBFB"];
        grayView.layer.cornerRadius = 5;
        [self.contentView addSubview:grayView];
        
        NSArray *array = @[@"姓名:",@"电话:",@"区域:"];
        for (int i=0; i<3; i++)
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
            textField.placeholder = @"选填";
            textField.textColor = TextColor;
            [textField addTarget:self action:@selector(textDidEdit:) forControlEvents:UIControlEventEditingChanged];
            textField.font = [UIFont systemFontOfSize:11];
            textField.textAlignment = NSTextAlignmentRight;
            [grayView addSubview:textField];
//            textField.delegate = self;
            textField.tag = 200+i;
        }
        
        _nameText = [grayView viewWithTag:200];
        _phoneText = [grayView viewWithTag:201];
        _addressText = [grayView viewWithTag:202];
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-165, 170, 150, 20)];
        [btn setTitle:@"   保存发货信息" forState:UIControlStateNormal];
        [btn setTitleColor:TextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setImage:[UIImage imageNamed:@"对号"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"框"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
    return self;
}


- (void)textDidEdit:(UITextField *)textField
{
    
    if (_nameText.text.length>0)
    {
        [_param setObject:_nameText.text forKey:@"sendName"];
    }
    
    if (_phoneText.text.length > 0)
    {
        [_param setObject:_phoneText.text forKey:@"sendPhone"];
    }
    
    if (_addressText.text.length > 0)
    {
        [_param setObject:_addressText.text forKey:@"sendAddress"];
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

- (void)handlerButtonAction:(DeliverCellBlock)block
{
    self.block = block;
}

- (void)goToRecent
{
    if (_delegate && [_delegate respondsToSelector:@selector(deliverCellDidSelected)])
    {
        [_delegate deliverCellDidSelected];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
