//
//  NewAddressCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/29.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "NewAddressCell.h"

@interface NewAddressCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation NewAddressCell

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
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 44)];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = TextColor;
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)setModel:(CommonModel *)model
{
    _label.text = model.areaName;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
