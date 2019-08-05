//
//  MineTableViewCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftLogo;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, assign) BOOL hideArrow;
@property (nonatomic, assign) BOOL showUpdate;

@end
