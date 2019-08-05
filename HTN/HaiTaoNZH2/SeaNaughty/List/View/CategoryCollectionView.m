//
//  CategoryCollectionView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/14.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CategoryCollectionView.h"
#import "RankBtnView.h"
#import "ProductListModel.h"
#import "ProductCollectionCell.h"
#import <Masonry.h>

@interface CategoryCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate>


@end

@implementation CategoryCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(80, 80);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    ChildrenModel *model = _dataArray[indexPath.item];
    
//    NSArray *colorArray = @[[UIColor colorFromHexString:@"#f7ebeb"],[UIColor colorFromHexString:@"#fcf1ec"],[UIColor colorFromHexString:@"#e8f1f3"],[UIColor colorFromHexString:@"#faf7f3"],[UIColor colorFromHexString:@"fcf3f7"],[UIColor colorFromHexString:@"f7ebeb"]];
    
   
    
    CGFloat width = 80;
    
    UIView *bgView = [[UIView alloc] init];
    [cell.contentView addSubview:bgView];
    bgView.layer.cornerRadius = 23;
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@46);
        make.height.mas_equalTo(@46);
        make.centerX.equalTo(cell.contentView);
        make.top.mas_equalTo(@7);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [cell.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView);
        make.width.mas_equalTo(@24);
        make.height.mas_equalTo(@24);
        make.top.mas_equalTo(@18);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, width-20, width, 20)];
    [cell.contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(cell.contentView);
        make.height.mas_equalTo(@20);
        make.top.mas_equalTo(54);
        make.left.equalTo(cell.contentView);
    }];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorFromHexString:@"#666666"];
    label.text = model.name;
    
    if (model.backImg.length<6)
    {
        imageView.image = [UIImage imageNamed:model.backImg];
    }
    else
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.backImg]];
    }
    
    
   
    
    if (_selectedModel == model)
    {
        bgView.backgroundColor = [UIColor colorFromHexString:@"#f7ebeb"];
    }
    else
        bgView.backgroundColor = LineColor;
    
    return cell;
    
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self reloadData];
}

- (void)setSelectedModel:(ChildrenModel *)selectedModel
{
    _selectedModel = selectedModel;
    
//    for (int i==0; i<_dataArray.count; i++)
//    {
//        ChildrenModel *model = _dataArray[i];
//
//        if ([model.name isEqualToString:selectedModel]) {
//            <#statements#>
//        }
//    }
    [self reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChildrenModel *model = _dataArray[indexPath.item];
    
    _selectedModel = model;
    [self reloadData];
    
    if (self.subDelegate && [_subDelegate respondsToSelector:@selector(categoryCollectionSelectedModel:)])
    {
        [_subDelegate categoryCollectionSelectedModel:_selectedModel];
    }
}


@end
