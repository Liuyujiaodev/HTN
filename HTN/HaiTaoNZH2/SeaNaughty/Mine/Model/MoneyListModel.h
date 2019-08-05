//
//  MoneyListModel.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/6.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MoneyModel.h"

@protocol MoneyModel

@end

@interface MoneyListModel : NSObject

@property (nonatomic, strong) NSArray <MoneyModel *> *rows;

@end
