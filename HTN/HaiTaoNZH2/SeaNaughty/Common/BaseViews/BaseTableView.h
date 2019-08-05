//
//  BaseTableView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableView : UITableView


@property (nonatomic , strong) NSString *emptyText;

@property (nonatomic , strong) UIImage *emptyImg;

@property (nonatomic , assign) BOOL showEmptyView;

@property (nonatomic , strong) NSString *emptyFrame;

/**
 空态时，tableview背景色，默认白色
 */
@property (nonatomic , strong) UIColor *emptyBackgroundColor;
/**
 取消选中的cell
 */
- (void)cancelSelectStatus;

@end
