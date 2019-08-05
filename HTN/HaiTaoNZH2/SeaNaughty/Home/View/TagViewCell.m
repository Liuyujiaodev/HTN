//
//  TagViewCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/2/19.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "TagViewCell.h"
#import "TagView.h"

@interface TagViewCell ()

@property (nonatomic, strong) TagView *tagView;

@end

@implementation TagViewCell

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
        
        _tagView = [[TagView alloc] initWithFrame:CGRectMake(15, 10, G_SCREEN_WIDTH, 0)];
        
        [self.contentView addSubview:_tagView];
    }
    return self;
}

- (void)setTagArray:(NSArray *)tagArray
{
    _tagArray = tagArray;
    
    for (UIView *subView in _tagView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    _tagView.arr = _tagArray;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
