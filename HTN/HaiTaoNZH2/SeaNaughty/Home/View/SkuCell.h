//
//  SkuCell.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/24.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SkuTypeNormal,
    SkuTypeStocked,
    SkuTypeSelected,
} SkuType;

@interface SkuCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *properLabel;
@property (nonatomic, assign) SkuType skuType;


@end

