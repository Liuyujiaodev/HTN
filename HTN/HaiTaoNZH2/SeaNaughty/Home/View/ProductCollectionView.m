//
//  ProductCollectionView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/2.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProductCollectionView.h"
#import "ProductCollectionCell.h"


@interface ProductCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation ProductCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame collectionViewLayout:self.flowLayout];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = LineColor;
        [self registerClass:[ProductCollectionCell class] forCellWithReuseIdentifier:@"ProductCollectionCell"];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_dataArray.count>6)
    {
        return 6;
    }
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCollectionCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    
    
    if (_dataArray)
    {
        NSDictionary *dic = _dataArray[indexPath.item];
        ProductModel *model = [ProductModel yy_modelWithDictionary:dic];
        cell.data = model;
    }
    return cell;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake(G_SCREEN_WIDTH/2-1, 340);
        _flowLayout.minimumLineSpacing = 2;
        _flowLayout.minimumInteritemSpacing = 2;
        
    }
    return _flowLayout;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    
    [self reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArray[indexPath.item];
    
    ProductModel *model = [ProductModel yy_modelWithDictionary:dic];
    
    NSNotification *notification = [NSNotification notificationWithName:@"goToProductDetailVC" object:model userInfo:@{@"model":@"ProductModel"}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToProductDetailVC" object:model];
}


@end
