//
//  TextAlertView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/21.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"
#import "CartAllModel.h"

@interface TextAlertView : UIView

@property (nonatomic, strong) CartModel *model;
@property (nonatomic, strong) CartAllModel *allModel;
@property (nonatomic, assign) BOOL showMid;

@end
