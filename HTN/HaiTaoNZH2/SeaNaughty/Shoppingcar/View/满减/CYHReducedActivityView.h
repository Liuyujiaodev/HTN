//
//  CYHReducedActivityView.h
//  SeaNaughty
//
//  Created by Apple on 2019/6/27.
//  Copyright © 2019年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYHReducedActivityView : UIView

@property(nonatomic,strong) NSArray* dataSource;

@property(nonatomic,weak) UIViewController* superSelf;
@property(nonatomic,strong) NSString* titleStr;

-(void)show;
-(void)removeMain;

@end

NS_ASSUME_NONNULL_END
