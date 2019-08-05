//
//  OnLineCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnLineCellDelegate <NSObject>

- (void)onLineCellSelectedIndex:(NSInteger)index;

@end

@interface OnLineCell : UITableViewCell

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) id <OnLineCellDelegate> delegate;
@property (nonatomic, strong) NSString *walletSum;
@property (nonatomic, assign) BOOL showAlert;

@end
