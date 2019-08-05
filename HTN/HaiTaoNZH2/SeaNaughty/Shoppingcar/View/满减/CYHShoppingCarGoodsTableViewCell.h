//
//  CYHShoppingCarGoodsTableViewCell.h
//  SeaNaughty
//
//  Created by Apple on 2019/6/27.
//  Copyright © 2019年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYHShoppingCarGoodsTableViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController *superVC;

@property (nonatomic, strong) NSArray* sectionArr;
@property (nonatomic, strong) NSString* danWeiString;

@end

NS_ASSUME_NONNULL_END
