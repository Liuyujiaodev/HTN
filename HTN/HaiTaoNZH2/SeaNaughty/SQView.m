//
//  SQView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "SQView.h"
#import <Masonry.h>

@implementation SQView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.8;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        imageView.image = [UIImage imageNamed:@"sq"];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@60);
            make.height.mas_equalTo(@60);
            make.center.mas_equalTo(self);
        }];
        
    }
    return self;
}


@end
