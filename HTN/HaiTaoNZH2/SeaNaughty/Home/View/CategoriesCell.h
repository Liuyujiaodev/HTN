//
//  CategoriesCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@protocol CategoryCellSelectDelegate <NSObject>

- (void)categoryCellDidselectedShops;
- (void)categoryCellDidselectedModel:(ActivityModel *)model;

@end

@interface CategoriesCell : UITableViewCell

@property (nonatomic, strong) NSArray *categoriesArray;
@property (nonatomic, weak) id<CategoryCellSelectDelegate> delegate;

@end
