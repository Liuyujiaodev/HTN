//
//  LeftTableView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryListModel.h"

@class LeftTableView;

@protocol LeftTableViewDelegate <NSObject>

- (void)leftTableView:(LeftTableView *)tableView didSelectCategoryName:(CategoryModel *)model;

@end

@interface LeftTableView : UITableView

@property (nonatomic, weak) id<LeftTableViewDelegate> leftTableViewDelegate;

- (void)updateCategories:(CategoryListModel *)list;

- (void)selectedAtIndex:(int)index;

- (void)selectedWithName:(NSString *)name;

@end
