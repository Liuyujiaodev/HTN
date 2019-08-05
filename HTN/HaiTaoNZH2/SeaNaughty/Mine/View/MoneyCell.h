//
//  MoneyCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/6.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyModel.h"

@interface MoneyCell : UITableViewCell

@property (nonatomic, strong) MoneyModel *model;
@property (nonatomic, assign) BOOL showLine;

@end
