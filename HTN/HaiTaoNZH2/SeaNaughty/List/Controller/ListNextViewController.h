//
//  ListNextViewController.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/13.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"
#import "CategoryModel.h"
#import "ChildrenModel.h"

@interface ListNextViewController : BaseRootVC

@property (nonatomic, strong) ChildrenModel *model;

@property (nonatomic, strong) CategoryModel *category;

@end
