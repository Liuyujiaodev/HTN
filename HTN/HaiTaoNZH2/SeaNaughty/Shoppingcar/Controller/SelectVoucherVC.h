//
//  SelectVoucherVC.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/26.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import "BaseRootVC.h"
#import "VoucherModel.h"

@protocol SelecetVoucherDelegate <NSObject>

- (void)postVoucher:(NSMutableDictionary *)param;

@end

@interface SelectVoucherVC : BaseRootVC

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSArray *selectedVouchers;
@property (nonatomic, strong) NSArray *voucherId;
@property (nonatomic, strong) VoucherModel *feeModel;
@property (nonatomic, weak) id <SelecetVoucherDelegate> delegate;

@end
