//
//  CategoryCollectionView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/14.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildrenModel.h"

@protocol SubCategoryDelegate <NSObject>

- (void)categoryCollectionSelectedModel:(ChildrenModel *)model;

@end

@interface CategoryCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) ChildrenModel *selectedModel;
@property (nonatomic, weak) id <SubCategoryDelegate> subDelegate;

- (instancetype)initWithFrame:(CGRect)frame;


@end
