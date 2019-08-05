//
//  PayTypeCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "FifthCell.h"

@interface FifthCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation FifthCell

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
        
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
        leftLable.text = @"支付方式";
        leftLable.textColor = TextColor;
        leftLable.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:leftLable];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-115, 12, 100, 20)];
        _label.textAlignment = NSTextAlignmentRight;
        _label.textColor = TextColor;
        _label.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)setModel:(OrderModel *)model
{
//    _mod
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
