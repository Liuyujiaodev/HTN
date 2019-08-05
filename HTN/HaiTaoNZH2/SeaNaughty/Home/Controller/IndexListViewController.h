//
//  IndexListViewController.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseVC.h"
#import "ActivityModel.h"

@interface IndexListViewController : BaseVC

@property (nonatomic, strong) ActivityModel *model;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, assign) BOOL isLimitedSpecials;


@end
