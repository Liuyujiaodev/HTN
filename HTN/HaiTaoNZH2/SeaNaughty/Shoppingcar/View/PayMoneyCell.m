//
//  PayMoneyCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "PayMoneyCell.h"

@interface PayMoneyCell ()
@property (nonatomic, strong) UILabel *moneyLabel;
@end

@implementation PayMoneyCell

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
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 49)];
        topView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:topView];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 49)];
        leftLabel.text = @"总金额";
        leftLabel.font = [UIFont systemFontOfSize:15];
        leftLabel.textColor = TitleColor;
        [topView addSubview:leftLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 0, 300, 49)];
        _moneyLabel.textColor = MainColor;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [UIFont systemFontOfSize:13];
        [topView addSubview:_moneyLabel];
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, G_SCREEN_WIDTH, 31)];
        botView.backgroundColor = [UIColor colorFromHexString:@"#FFFDF0"];
        [self.contentView addSubview:botView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-315, 0, 300, 31)];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = TextColor;
        label.font = [UIFont systemFontOfSize:10];
        label.text = @"因汇率实时变化，实际金额以支付时为准";
        [botView addSubview:label];
        
        
    }
    return self;
}

- (void)setTotalFee:(NSString *)totalFee
{
    _totalFee = totalFee;
    
    _moneyLabel.text = _totalFee;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
