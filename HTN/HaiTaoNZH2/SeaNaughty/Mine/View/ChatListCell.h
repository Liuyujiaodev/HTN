//
//  ChatListCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/29.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatListCell : UITableViewCell

@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *subTitleString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, assign) NSInteger msgCount;

@end

NS_ASSUME_NONNULL_END
