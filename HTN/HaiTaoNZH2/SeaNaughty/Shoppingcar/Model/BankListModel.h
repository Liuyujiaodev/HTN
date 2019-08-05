//
//  BankListModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankModel.h"

@protocol BankModel

@end

@interface BankListModel : NSObject

@property (nonatomic, strong) NSArray <BankModel *> *data;

@end
