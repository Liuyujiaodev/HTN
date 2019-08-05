//
//  CenterBtn.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/19.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CenterBtn.h"
#import <Masonry.h>

@implementation CenterBtn

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
//    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.mas_equalTo(self).offset(-5);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
    
//    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.mas_equalTo(self).offset(11);
//        make.width.mas_equalTo(48);
//        make.height.mas_equalTo(15);
//    }];
    
    self.titleLabel.frame = CGRectMake(0, 33, 48, 15);
    self.imageView.frame = CGRectMake(14, 8, 20, 20);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    

}

@end
