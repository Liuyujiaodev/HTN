//
//  FilterView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/26.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate <NSObject>

- (void)selectedIndex:(int)index show:(BOOL)isShow;

@end

@interface FilterView : UIView

@property (nonatomic, weak) id <FilterViewDelegate> delegate;
@property (nonatomic, assign) BOOL hideAll;

@end
