//
//  HomeTableView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseTableView.h"
#import <SDCycleScrollView.h>



@interface HomeTableView : BaseTableView

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) NSDictionary *voucherData;
@property (nonatomic, strong) NSArray *indexTipArray;
@property (nonatomic, assign) BOOL showVoucher;

- (void)updateBannerList:(NSArray *)bannerList;

- (void)updateMainCategories:(NSArray *)categoryList;

- (void)updateLimitedSpecials:(NSArray *)limitedSpecials;

- (void)updateActivityList:(NSArray *)activityList;

- (void)updateActivityBlock:(NSArray *)activityBlocks;

- (void)updateBrands:(NSArray *)brandsList;

- (void)updateTime;

@end
