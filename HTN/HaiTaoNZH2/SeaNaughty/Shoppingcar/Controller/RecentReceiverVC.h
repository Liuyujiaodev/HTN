//
//  RecentReceiverVC.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/26.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"
#import "CommonModelList.h"

@protocol RecentReceiverVCDelegate <NSObject>

- (void)postReceriverModel:(CommonModel *)model;

@end

@interface RecentReceiverVC : BaseRootVC

@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, weak) id <RecentReceiverVCDelegate> delegate;

@end
