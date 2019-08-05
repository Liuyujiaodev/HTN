//
//  OffLineCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankModel.h"

@protocol OffLineCellDelegate <NSObject>

- (void)offLineSelected:(BankModel *)bankModel;

@end

@interface OffLineCell : UITableViewCell

@property (nonatomic, strong) BankModel *model;
//@property (nonatomic, strong) NSArray *bankArray;
@property (nonatomic, weak) id <OffLineCellDelegate> delegate;

@end
