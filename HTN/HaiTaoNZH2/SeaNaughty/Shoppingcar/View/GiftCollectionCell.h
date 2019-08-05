//
//  GiftCollectionCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/27.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface GiftCollectionCell : UICollectionViewCell

@property (nonatomic, strong) ProductModel *model;
@property (nonatomic, assign) CGFloat needMoney;

@end
