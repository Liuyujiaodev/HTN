//
//  SkuCountCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/26.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkuCollectionView.h"

@protocol SkuCountDelegate <NSObject>

- (void)postProductSku:(NSDictionary *)sku selectArray:(NSArray *)selectArray;
- (void)postProductCount:(int)count;

@end

@interface SkuCountCell : UITableViewCell

@property (nonatomic, weak) id <SkuCountDelegate> delegate;
@property (nonatomic, strong) NSArray *sourceArray;
@property (nonatomic, strong) NSArray *skuData;
@property (nonatomic, strong) NSArray *selectArray;
@property (nonatomic, assign) CGFloat skuHeight;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) int countNum;
@property (nonatomic, strong) SkuCollectionView *skuView;
@property (nonatomic, strong) UILabel *testlabel;
@end
