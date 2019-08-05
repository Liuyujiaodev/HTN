//
//  ConsigneeCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReceiveCellBlock)(NSDictionary *dic);

@protocol ReceiveCellDelegate <NSObject>

- (void)receiveCellDidSelected;

- (void)presentAddressVC;

@end

@interface ReceiveCell : UITableViewCell

@property (nonatomic, assign) BOOL mustHaveId;
@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UITextField *addressText;
@property (nonatomic, strong) UITextField *idCardText;
@property (nonatomic, strong) UITextField *proviceText;
@property (nonatomic, weak) id <ReceiveCellDelegate> delegate;
@property (nonatomic, copy) ReceiveCellBlock block;

- (void)handlerButtonAction:(ReceiveCellBlock)block;

@end
