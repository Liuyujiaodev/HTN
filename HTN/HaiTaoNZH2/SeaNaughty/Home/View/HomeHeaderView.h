//
//  HomeHeaderView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface HomeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) ActivityModel *model;

- (void)updateTitle:(NSString *)title imageName:(NSString *)imageName needHiddenRight:(BOOL)hidden;

@end
