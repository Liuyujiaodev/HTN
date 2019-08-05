//
//  BaseVC.h
//  NZH
//
//  Created by chilezzz on 2018/8/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"

@interface BaseVC : BaseRootVC

@property (nonatomic, strong) NSString *searchText;
//@property (nonatomic, assign) BOOL isFromMessage;
@property (nonatomic, assign) BOOL leftBackBtn;

- (void)goToShopCar;

- (void)scanCode;

@end
