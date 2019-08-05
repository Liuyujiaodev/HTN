//
//  StorehouseView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/6.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListModel.h"

@protocol StorehouseViewDelege <NSObject>

- (void)storehouseViewSelected:(ShopModel *)model;

@end

@interface StorehouseView : UIView

@property (nonatomic, weak) id<StorehouseViewDelege> delegat;
@property (nonatomic, strong) NSString *firstName;

@end
