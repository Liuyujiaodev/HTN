

//
//  AlertCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "AlertCell.h"

@implementation AlertCell

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
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 40)];
        label.numberOfLines = 2;
        label.text = @"支付遇到任何问题，请联系公众号客服，热心的客服妹子一定会帮您解决的。";
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = LightGrayColor;
        [view addSubview:label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
