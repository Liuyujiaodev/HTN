//
//  DeliverCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeliverCellBlock)(NSDictionary *dic);

@protocol DeliverCellDelegate <NSObject>

- (void)deliverCellDidSelected;

- (void)presentAddressVC;

@end

@interface DeliverCell : UITableViewCell

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UITextField *addressText;
@property (nonatomic, weak) id <DeliverCellDelegate> delegate;
@property (nonatomic, copy) DeliverCellBlock block;

- (void)handlerButtonAction:(DeliverCellBlock)block;

@end
