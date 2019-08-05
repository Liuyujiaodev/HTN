//
//  RankCollectionHeaderView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/20.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "RankCollectionHeaderView.h"
#import "RankBtnView.h"
#import "StorehouseView.h"

@interface RankCollectionHeaderView () <RankBtnViewDelegate, StorehouseViewDelege>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation RankCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 170)];
        bgImageView.image = [UIImage imageNamed:@"shpoBg"];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:bgImageView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-100, 48, 200, 74)];
        bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        bgView.layer.borderWidth = 1.8;
        bgView.backgroundColor = RGBACOLOR(255, 255, 255, 0.3);
        
        [self addSubview:bgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//
        [bgView addSubview:_titleLabel];
        
        _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 200, 20)];
        _subLabel.font = [UIFont systemFontOfSize:13];
        _subLabel.textColor = [UIColor whiteColor];
        _subLabel.textAlignment = NSTextAlignmentCenter;
//
        [bgView addSubview:_subLabel];
        
        StorehouseView *store = [[StorehouseView alloc] initWithFrame:CGRectMake(0, 170, G_SCREEN_WIDTH, 70)];
        store.delegat = self;
        [self addSubview:store];
        
        RankBtnView *btn = [[RankBtnView alloc] initWithFrame:CGRectMake(0, 250, G_SCREEN_WIDTH, 40)];
        btn.delegate = self;
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        
        
    }
    return self;
}

- (void)setModel:(ActivityModel *)model
{
    _model = model;
    _titleLabel.text = _model.name;
    _subLabel.text = _model.subTitle;
}

- (void)rankBtnViewWithParam:(NSDictionary *)dic
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(postParam:)])
    {
        [_delegate postParam:dic];
    }
}

- (void)storehouseViewSelected:(ShopModel *)model
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectShop:)])
    {
        [_delegate selectShop:model.shopId];
    }
}

@end
