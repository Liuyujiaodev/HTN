//
//  SkuHeaderView.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/24.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "SkuHeaderView.h"
#import <Masonry.h>

@implementation SkuHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:bgView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, frame.size.height)];
        [bgView addSubview:_label];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = LightGrayColor;
    }
    return self;
}

@end
