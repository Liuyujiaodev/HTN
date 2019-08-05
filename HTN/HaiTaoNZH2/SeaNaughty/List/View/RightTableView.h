//
//  RightTableView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryListModel.h"

@class RightTableView;

@protocol RightTableViewDelegate <NSObject>

- (void)rightTableView:(RightTableView *)tableView didSelectCategoryName:(NSString *)name;

@end

@interface RightTableView : UITableView

@property (nonatomic, weak) id<RightTableViewDelegate> rightTableViewDelegate;

@property (nonatomic, strong) CategoryModel *category;
@property (nonatomic, strong) NSArray *children;


@end
