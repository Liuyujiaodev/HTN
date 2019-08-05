//
//  OrderBottomCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "OrderBottomCell.h"

@interface OrderBottomCell ()

@end

@implementation OrderBottomCell

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
        
        _memoText = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 36)];
        _memoText.placeholder = @"备注";
        _memoText.textColor = TextColor;
        [_memoText addTarget:self action:@selector(xxx) forControlEvents:UIControlEventEditingChanged];
        _memoText.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_memoText];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [self.contentView addSubview:lineView];
        
        _feeView = [[TotalFeeView alloc] init];
        _feeView.frame = CGRectMake(0, 37, G_SCREEN_WIDTH, 70);
        _feeView.backgroundColor = [UIColor whiteColor];
        _feeView.isConfirm = YES;
        [self.contentView addSubview:_feeView];
    }
    return self;
}

- (void)setModel:(CartModel *)model
{
    _model = model;
    _feeView.cartModel = _model;
    _memoText.text = _model.memo;
}

- (void)xxx
{
    _model.memo = _memoText.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
