//
//  CategoryCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell ()

@property (nonatomic, strong) UIView *leftView;

@end

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
//        self.selectedBackgroundView
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_nameLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 3, 20)];
        _leftView.backgroundColor = MainColor;
        _leftView.hidden = YES;
        [self.contentView addSubview:_leftView];
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected)
    {
        _nameLabel.textColor = [UIColor orangeColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _leftView.hidden = NO;
    }
    else
    {
        _nameLabel.textColor = [UIColor grayColor];
        _nameLabel.font = [UIFont systemFontOfSize:11];
        _leftView.hidden = YES;
    }
    
}

@end
