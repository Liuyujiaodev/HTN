//
//  WKTagListView.m
//  tagButton
//
//  Created by developer_k on 16/3/18.
//  Copyright © 2016年 developer_k. All rights reserved.
//

#import "WKTagListView.h"
#import "WKCollectionViewFlowLayout.h"
#import "WKTagCollectionViewCell.h"

@interface WKTagListView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,copy)WKTagListViewBlock selectBlock;


@end

static NSString* const reuseId = @"WKListViewItemId";
@implementation WKTagListView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUpdate];
        
    }
    return  self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpdate];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
}

-(void)setUpdate
{
    _selectedTags = [NSMutableArray array ];
    _tags = [NSMutableArray array];
    _canSelectTags = YES;
    _tagStrokeColor = LineColor;
    _tagBackGroundColor = LineColor;
    _tagTextColor = TextColor;
    _tagSelectedBackGroundColor = _tagBackGroundColor;
    
    _tagCornerRadius = 5.0f;
    WKCollectionViewFlowLayout *layout = [[WKCollectionViewFlowLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _canSelectMulti = YES;
    _allBecomeNormal = NO;
    [_collectionView registerClass:[WKTagCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    
    [self addSubview:_collectionView];
}



-(void)setCompletionBlockWithSelected : (WKTagListViewBlock)completionBlock
{
    self.selectBlock = completionBlock;
}

- (void)setCanSelectMulti:(BOOL)canSelectMulti
{
   _canSelectMulti = canSelectMulti;
}

- (void)setAllBecomeNormal:(BOOL)allBecomeNormal
{
    [self.selectedTags removeAllObjects];
    _allBecomeNormal = allBecomeNormal;
    [_collectionView reloadData];
}

#pragma mark - collection delegate dataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    WKCollectionViewFlowLayout *layout = (WKCollectionViewFlowLayout*)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left-layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize
                                                           options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil];
    return CGSizeMake(frame.size.width+20.0f, layout.itemSize.height);
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WKTagCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    cell.backgroundColor = self.tagBackGroundColor;
    cell.layer.borderColor = self.tagStrokeColor.CGColor;
    cell.layer.cornerRadius = self.tagCornerRadius;
    cell.titleLabel.text = self.tags[indexPath.item];
    cell.titleLabel.textColor = TextColor;
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = self.tagSelectedBackGroundColor;
        
    }
    

    if (self.allBecomeNormal)
    {
        cell.backgroundColor = self.tagBackGroundColor;
        cell.titleLabel.textColor = TextColor;
        cell.layer.borderColor = LineColor.CGColor;
    }
    
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]])
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = MainColor;
        cell.layer.borderColor = MainColor.CGColor;
    }
    else
    {
        cell.backgroundColor = self.tagBackGroundColor;
        cell.titleLabel.textColor = TextColor;
        cell.layer.borderColor = LineColor.CGColor;
    }
    
    
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.canSelectMulti)
    {
        [self.selectedTags removeAllObjects];
    }
    
    if (self.canSelectTags)
    {
        WKTagCollectionViewCell*cell = (WKTagCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        
        if ([self.selectedTags containsObject:self.tags[indexPath.item]])
        {
            cell.backgroundColor = self.tagBackGroundColor;
            cell.titleLabel.textColor = TextColor;
            cell.layer.borderColor = LineColor.CGColor;
            cell.hasSelected = NO;
            [self.selectedTags removeObject:self.tags[indexPath.item]];
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.textColor = MainColor;
            cell.layer.borderColor = MainColor.CGColor;
            cell.hasSelected = YES;
            [self.selectedTags addObject:self.tags[indexPath.item]];
        }
    }
    
    if (self.selectBlock) {
        self.selectBlock(indexPath.item);
    }
    
    [_collectionView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
