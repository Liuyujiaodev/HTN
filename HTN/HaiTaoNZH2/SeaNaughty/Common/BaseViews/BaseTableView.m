//
//  BaseTableView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BaseTableView.h"
#import "CustomEmptyView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <MJRefresh.h>

@interface BaseTableView () <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIColor *lastColor;

@end

@implementation BaseTableView


-(id)initWithCoder:(NSCoder *)aDecoder
{
    if( self = [super initWithCoder:aDecoder] )
    {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        
        [self setExtraCellLineHidden:self];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        
        [self setExtraCellLineHidden:self];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
        [self setExtraCellLineHidden:self];
    }
    return self;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    if (tableView.style == UITableViewStylePlain) {
        UIView *view =[ [UIView alloc]init];
        
        view.backgroundColor = [UIColor clearColor];
        
        [tableView setTableFooterView:view];
        
        [tableView setTableHeaderView:view];
    }
    
}

#pragma mark -- 取消选中状态

- (void)cancelSelectStatus
{
    for (NSIndexPath *indexPath in self.indexPathsForSelectedRows) {
        [self deselectRowAtIndexPath:indexPath animated:YES];
    }
}
#pragma mark -- 空态视图
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if(!_lastColor )
    {
        _lastColor = self.backgroundColor;
    }
    if (self.showEmptyView) {
        if(_emptyBackgroundColor)
        {
            self.backgroundColor = _emptyBackgroundColor;
        }
        else
        {
            self.backgroundColor = [UIColor whiteColor];
        }
    }
    
    CustomEmptyView *view = [[CustomEmptyView alloc] init];
    

    [view updateViewImage:_emptyImg description:_emptyText];
    
    self.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.showEmptyView;
}

- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView
{
    self.backgroundColor = _lastColor;
}

@end
