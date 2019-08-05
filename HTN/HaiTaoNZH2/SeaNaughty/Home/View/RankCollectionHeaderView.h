//
//  RankCollectionHeaderView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@protocol HeaderViewDelegate <NSObject>

- (void)postParam:(NSDictionary *)dic;

- (void)selectShop:(NSString *)shopId;

@end

@interface RankCollectionHeaderView : UICollectionReusableView

@property (nonatomic, weak) id <HeaderViewDelegate> delegate;

@property (nonatomic, strong) ActivityModel *model;

@end
