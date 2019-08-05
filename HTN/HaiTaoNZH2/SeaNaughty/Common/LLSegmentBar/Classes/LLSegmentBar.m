//
//  LLSegmentBar.m
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import "LLSegmentBar.h"
#import "UIView+LLSegmentBar.h"

#define KMinMargin 30

@interface LLSegmentBar ()

/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;
/** 添加的按钮数据 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;
/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;

@property (nonatomic, strong) LLSegmentBarConfig *config;

@end

@implementation LLSegmentBar{
// 记录最后一次点击的按钮
    UIButton *_lastBtn;
}

+ (instancetype)segmentBarWithFrame:(CGRect)frame{
    LLSegmentBar *segmentBar = [[LLSegmentBar alloc]initWithFrame:frame];
    return segmentBar;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.sBBackColor;
    }
    return self;
}

- (void)updateWithConfig:(void (^)(LLSegmentBarConfig *))configBlock{
    if (configBlock) {
        configBlock(self.config);
    }
    // 按照当前的self.config 进行刷新
    self.backgroundColor = self.config.sBBackColor;
    self.indicatorView.backgroundColor = self.config.indicatorC;
    for (UIButton *btn in self.itemBtns) {
        [btn setTitleColor:self.config.itemNC forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSC forState:UIControlStateSelected];
        
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

-  (void)setSelectIndex:(NSInteger)selectIndex{
        
    if (self.items.count == 0 || selectIndex < 0 || selectIndex > self.itemBtns.count- 1) {
        return;
    }
    
    
    _selectIndex = selectIndex;
    UIButton *btn = self.itemBtns[selectIndex];
    [self btnClick:btn];
}

- (void)setItems:(NSArray<NSString *> *)items{
    _items = items;
    // 删除之前添加过多的组件
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    
    // 根据所有的选项数据源 创建Button 添加到内容视图
    for (NSString *item in items) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:self.config.itemNC forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSC forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemF;
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - private
- (void)btnClick:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:sender.tag fromIndex:_lastBtn.tag];
    }
    
    _selectIndex = sender.tag;
    
    _lastBtn.selected = NO;
    sender.selected = YES;
    _lastBtn = sender;
    
    for (UIButton *btn in self.itemBtns)
    {
        btn.titleLabel.font = self.config.itemF;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.indicatorView.ll_width = sender.ll_width - self.config.indicatorW * 2;
        self.indicatorView.ll_centerX = sender.ll_centerX;
        sender.titleLabel.font = self.config.itemSFont;
    }];
    
    

    // 滚动到Btn的位置
    CGFloat scrollX = sender.ll_x - self.contentView.ll_width * 0.5;
    
    
    // 考虑临界的位置
    if (scrollX < 0) {
        scrollX = 0;
    }
    if (scrollX > self.contentView.contentSize.width - self.contentView.ll_width) {
        scrollX = self.contentView.contentSize.width - self.contentView.ll_width;
    }
//    [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
}

#pragma mark - layout
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    CGFloat totalBtnWidth = 0;
//    for (UIButton *btn in self.itemBtns) {
//        [btn sizeToFit];
//        btn.ll_width = self.frame.size.width / _items.count;
//
//        totalBtnWidth += btn.ll_width;
//    }
    
//    CGFloat caculateMargin = (self.ll_width - totalBtnWidth) / (self.items.count + 1);
//    if (caculateMargin < KMinMargin) {
//        caculateMargin = KMinMargin;
//    }
    
    
    CGFloat lastX;
    
    CGFloat width = self.frame.size.width / _items.count;
    
    for (int i=0; i<self.itemBtns.count; i++)
    {
        UIButton *btn = self.itemBtns[i];
        btn.frame = CGRectMake(width*i, 0, width, self.frame.size.height);
        btn.titleLabel.font = self.config.itemF;

    }
    

    
    self.contentView.contentSize = CGSizeMake(self.frame.size.height, 0);
    
    if (self.itemBtns.count == 0) {
        return;
    }
    
    UIButton *btn = self.itemBtns[self.selectIndex];
    btn.titleLabel.font = self.config.itemSFont;
    self.indicatorView.ll_width = btn.ll_width-self.config.indicatorW*2;
    self.indicatorView.ll_centerX = btn.ll_centerX;
    self.indicatorView.ll_height = self.config.indicatorH;
    self.indicatorView.ll_y = self.ll_height - self.indicatorView.ll_height;

}

#pragma mark - lazy-init


- (NSMutableArray<UIButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorH;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.ll_height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorC;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (LLSegmentBarConfig *)config{
    if (!_config) {
        _config = [LLSegmentBarConfig defaultConfig];
    }
    return _config;
}


- (void)setIsLeft:(BOOL)isLeft
{
    _isLeft = isLeft;
    
    for (int i = 1; i<self.itemBtns.count-1; i++)
    {
        if (_isLeft)
        {
            UIButton *btn = self.itemBtns[i];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        }
    }
    
}




@end
