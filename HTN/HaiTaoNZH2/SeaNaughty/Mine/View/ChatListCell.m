//
//  ChatListCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/29.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "ChatListCell.h"

@interface ChatListCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation ChatListCell

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
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 22, 44, 44)];
//        _iconImage.image = [UIImage imageNamed:@"客服助手"];
        [self.contentView addSubview:_iconImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 20, G_SCREEN_WIDTH-130, 22)];
        _titleLabel.text = @"客服助手";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = TitleColor;
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(84, 46.6, G_SCREEN_WIDTH-170, 22)];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        _subTitleLabel.textColor = TextColor;
        [self.contentView addSubview:_subTitleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-88, 24, 75, 40)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor =LightGrayColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 19, 16, 16)];
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.layer.cornerRadius = 8;
        _countLabel.clipsToBounds = YES;
        _countLabel.layer.masksToBounds = YES;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.font = [UIFont systemFontOfSize:9];
        _countLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_countLabel];
    }
    return self;
}

- (void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    
    _iconImage.image = [UIImage imageNamed:_iconName];
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    _titleLabel.text = _titleString;
}

- (void)setSubTitleString:(NSString *)subTitleString
{
    _subTitleString = subTitleString;
    _subTitleLabel.text = _subTitleString;
}

- (void)setTimeString:(NSString *)timeString
{
    _timeString = timeString;
    _timeLabel.text = _timeString;
}

- (void)setMsgCount:(NSInteger)msgCount
{
    _msgCount = msgCount;
    _countLabel.text = [NSString stringWithFormat:@"%i", _msgCount];
    if (_msgCount == 0)
    {
        _countLabel.hidden = YES;
    }
    else
        _countLabel.hidden = NO;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
