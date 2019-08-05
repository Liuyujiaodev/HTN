//
//  FirstSectionCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/15.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface FirstSectionCell : UITableViewCell

@property (nonatomic, strong) OrderModel *model;
@property (nonatomic, assign) BOOL miandan;

@end
