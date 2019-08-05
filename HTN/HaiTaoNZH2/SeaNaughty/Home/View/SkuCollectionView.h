//
//  SkuCollectionView.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/24.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ORSKUDataFilter.h"

@protocol SkuFilterResultDelegate <NSObject>

- (void)skuFilterResult:(NSDictionary *)sku selectArray:(NSArray *)selectArray;
- (void)postSelectedIndexPaths:(NSArray *)selectedIndexPaths;

@end

@interface SkuCollectionView : UICollectionView 

@property (nonatomic, strong) ORSKUDataFilter *filter;
@property (nonatomic, strong) NSArray *skuData;
@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, weak) id <SkuFilterResultDelegate> skuDelegate;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, assign) CGFloat itemWidth;
@end

