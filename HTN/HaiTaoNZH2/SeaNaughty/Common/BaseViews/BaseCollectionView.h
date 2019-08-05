//
//  BaseCollectionView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/25.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionView : UICollectionView

@property (nonatomic , strong) NSString *emptyText;

@property (nonatomic , strong) UIImage *emptyImg;

@property (nonatomic , assign) BOOL showEmptyView;

@property (nonatomic , strong) NSString *emptyFrame;

@property (nonatomic , strong) NSString *align;

/**
 空态时，tableview背景色，默认白色
 */
@property (nonatomic , strong) UIColor *emptyBackgroundColor;
/**
 取消选中的cell
 */

@end
