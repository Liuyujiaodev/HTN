//
//  ActivityListModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityModel.h"

@protocol ActivityModel

@end

@interface ActivityListModel : NSObject

@property (nonatomic, strong) NSArray<ActivityModel> *data;

@end
