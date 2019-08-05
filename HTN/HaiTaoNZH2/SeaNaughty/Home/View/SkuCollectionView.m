//
//  SkuCollectionView.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/24.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "SkuCollectionView.h"
#import "SkuCell.h"
#import "SkuHeaderView.h"

@interface SkuCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource, ORSKUDataFilterDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*selectedIndexPaths;
@property (nonatomic, assign) BOOL reFresh;

@end

@implementation SkuCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"selectSku"];
        self.delegate = self;
        self.dataSource = self;
        _selectArray = [[NSMutableArray alloc] init];
        [self registerClass:[SkuCell class] forCellWithReuseIdentifier:@"SkuCell"];
        _filter = [[ORSKUDataFilter alloc] initWithDataSource:self];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SkuHeaderView"];
    }
    return self;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_itemWidth, 30);
}

- (void)setSkuData:(NSArray *)skuData
{
    _skuData = skuData;
    [self reloadData];
    [_filter reloadData];
}

- (void)setSourceArray:(NSArray *)sourceArray
{
    _sourceArray = sourceArray;
}

- (void)setSelectArray:(NSArray *)selectArray
{
    _selectArray = [[NSMutableArray alloc] initWithArray:selectArray];
    _filter.selectedIndexPaths = _selectArray;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sourceArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_sourceArray[section][@"value"] count];
}

//- num

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *skuView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SkuHeaderView" forIndexPath:indexPath];
        for (UIView *view in skuView.subviews) {
            [view removeFromSuperview];
        }
        
        SkuHeaderView *headerView = [[SkuHeaderView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 30)];
        headerView.label.text = _sourceArray[indexPath.section][@"name"];
//        headerView.backgroundColor = [UIColor orangeColor];
        [skuView addSubview:headerView];
        return skuView;
        
    }else {
        return nil;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SkuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SkuCell" forIndexPath:indexPath];
    NSArray *data = _sourceArray[indexPath.section][@"value"];
    
    cell.properLabel.text = data[indexPath.item];
//
    if ([_filter.availableIndexPathsSet containsObject:indexPath]) {
        [cell setSkuType:SkuTypeNormal];
    }else {
        [cell setSkuType:SkuTypeStocked];
    }
    
    if ([_filter.selectedIndexPaths containsObject:indexPath]) {
        [cell setSkuType:SkuTypeSelected];
    }

    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [_selectArray removeAllObjects];
    [_filter didSelectedPropertyWithIndexPath:indexPath];
    [collectionView reloadData];
    [self action_complete];
}


#pragma mark -- ORSKUDataFilterDataSource

- (NSInteger)numberOfSectionsForPropertiesInFilter:(ORSKUDataFilter *)filter {
    return _sourceArray.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter propertiesInSection:(NSInteger)section {
    return _sourceArray[section][@"value"];
}

- (NSInteger)numberOfConditionsInFilter:(ORSKUDataFilter *)filter {
    return _skuData.count;
}

- (NSArray *)filter:(ORSKUDataFilter *)filter conditionForRow:(NSInteger)row {
    NSArray *condition = _skuData[row][@"contition"];
    
    return condition;
}

- (id)filter:(ORSKUDataFilter *)filter resultOfConditionForRow:(NSInteger)row {
    NSDictionary *dic = _skuData[row];
    
    return @{@"sku":dic[@"sku"], @"stock":dic[@"stock"]};
}

- (void)action_complete
{
    
    if (_filter.currentResult)
    {
        NSArray *array = [NSArray arrayWithArray:_filter.selectedIndexPaths];
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in array)
        {
            NSArray *data = _sourceArray[indexPath.section][@"value"];
            NSString *sele = data[indexPath.item];
            [indexArray addObject:sele];
        }
        
        if (self.skuDelegate && [self.skuDelegate respondsToSelector:@selector(skuFilterResult:selectArray:)])
        {
            [self.skuDelegate skuFilterResult:_filter.currentResult selectArray:(NSArray *)indexArray];
        }
        
    }
    else
    {
        
        if (self.skuDelegate && [self.skuDelegate respondsToSelector:@selector(skuFilterResult:selectArray:)])
        {
            [self.skuDelegate skuFilterResult:_filter.currentResult selectArray:_filter.selectedIndexPaths];
        }
    }
    
}

@end
