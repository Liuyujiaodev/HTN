//
//  ListChildrenView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@protocol ListChildrenViewDelegate <NSObject>

- (void)listChildrenViewDidClickedModel:(ChildrenModel *)model andCategoryModel:(CategoryModel *)category;

@end

@interface ListChildrenView : UICollectionView

@property (nonatomic, assign) NSInteger perNum; //每行数量

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) CategoryModel *model;

@property (nonatomic, assign) BOOL hasTopImage;

@property (nonatomic, strong) NSString *topImageName;

@property (nonatomic, weak) id <ListChildrenViewDelegate> childrenDelegate;

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array;

@end
