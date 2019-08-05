//
//  SkuCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/24.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "SkuCell.h"

@implementation SkuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _properLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _properLabel.preferredMaxLayoutWidth = frame.size.width-8;
        _properLabel.textColor = TitleColor;
        _properLabel.textAlignment = NSTextAlignmentCenter;
        _properLabel.font = [UIFont systemFontOfSize:12];
        _properLabel.layer.borderWidth = 0.8;
        _properLabel.layer.cornerRadius = 2;
        _properLabel.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_properLabel];
    }
    return self;
}

- (void)setSkuType:(SkuType)skuType
{
    if (skuType == SkuTypeNormal)
    {
        _properLabel.textColor = TitleColor;
        _properLabel.backgroundColor = [UIColor whiteColor];
        _properLabel.layer.borderColor = TextColor.CGColor;
    }
    else if (skuType == SkuTypeSelected)
    {
        _properLabel.textColor = [UIColor whiteColor];
        _properLabel.backgroundColor = MainColor;
        _properLabel.layer.borderColor = MainColor.CGColor;
    }
    else if (skuType == SkuTypeStocked)
    {
        _properLabel.textColor = LightGrayColor;
        _properLabel.backgroundColor = [UIColor whiteColor];
        _properLabel.layer.borderColor = LightGrayColor.CGColor;
    }
}

@end
