//
//  RecentDeliverVC.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"
#import "CommonModelList.h"

@protocol RecentDeliverVCDelegate <NSObject>

- (void)postDeliverModel:(CommonModel *)model;

@end

@interface RecentDeliverVC : BaseRootVC

@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, weak) id <RecentDeliverVCDelegate> delegate;

@end
