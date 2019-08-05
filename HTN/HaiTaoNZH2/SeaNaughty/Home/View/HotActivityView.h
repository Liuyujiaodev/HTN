//
//  HotActivityView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/29.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface HotActivityView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *subTitleColor;
@property (nonatomic, strong) ActivityModel *model;
- (instancetype)initWithFrame:(CGRect)frame;

//- (void)updateHotActiviyView:()

@end
