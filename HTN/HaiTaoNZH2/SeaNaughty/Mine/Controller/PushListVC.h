//
//  PushListVC.h
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/29.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface PushListVC : BaseRootVC

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) BOOL fromPush;

@end

NS_ASSUME_NONNULL_END
