//
//  ListShopViewController.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/12.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseVC.h"
#import "CategoryListModel.h"

@interface ListShopViewController : BaseVC

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) CategoryListModel *categoryList;

@end
