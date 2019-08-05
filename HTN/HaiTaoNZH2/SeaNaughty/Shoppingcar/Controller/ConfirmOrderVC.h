//
//  ConfirmOrderVC.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"
#import "CartAllModel.h"

@interface ConfirmOrderVC : BaseRootVC

@property (nonatomic, strong) CartAllModel *allModel;
@property (nonatomic, assign) BOOL showAlert;
@property (nonatomic, strong) NSString *shippingCourier;

@end
