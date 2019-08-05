//
//  RankBtnView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/4.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RankBtnViewDelegate <NSObject>

- (void)rankBtnViewWithParam:(NSDictionary *)dic;

@end

@interface RankBtnView : UIView

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) BOOL showTopline;
@property (nonatomic, weak) id<RankBtnViewDelegate> delegate;
@property (nonatomic, strong) NSDictionary *dictionary;


@end
