//
//  ListChildrenView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ListChildrenView.h"
#import "ChildrenModel.h"
#import <Masonry.h>
@interface ListChildrenView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UILabel *labell;

@end

@implementation ListChildrenView

- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)array
{
    CGFloat width = frame.size.width / 3;
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _layout.itemSize = CGSizeMake(width, width);
    
    if (array)
    {
        _dataArray = array;
    }
    
    self = [super initWithFrame:frame collectionViewLayout:_layout];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ListChildrenViewCell"];
//        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ListChildrenHeaderView"];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPat
//{
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ListChildrenHeaderView" forIndexPath:indexPat];
//
//
////            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
////            imageView.backgroundColor = [UIColor redColor];
////
////            [headerView addSubview:imageView];
//        for (UIView *view in headerView.subviews) { [view removeFromSuperview]; }
//
//        if (_model.topImageName)
//        {
//            _labell = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
//            _labell.backgroundColor = [UIColor grayColor];
//            [headerView addSubview:_labell];
//            _labell.text = _model.topImageName;
//        }
//
//
//
//
//        return headerView;
//    }
//    else
//        return nil;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ListChildrenViewCell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    ChildrenModel *model = _dataArray[indexPath.item];
    
    NSArray *colorArray = @[[UIColor colorFromHexString:@"#f7ebeb"],[UIColor colorFromHexString:@"#fcf1ec"],[UIColor colorFromHexString:@"#e8f1f3"],[UIColor colorFromHexString:@"#faf7f3"],[UIColor colorFromHexString:@"fcf3f7"],[UIColor colorFromHexString:@"f7ebeb"]];
    
    
    
    CGFloat width = (G_SCREEN_WIDTH-80)/3;
    
    
    
    CGFloat temp = 0;
//    if (indexPath.item%3==2)
//    {
//        temp = -width/8;
//    }
//    else if (indexPath.item%3==0)
//    {
//        temp = width/8;
//    }

    UIView *bgView = [[UIView alloc] init];
    [cell.contentView addSubview:bgView];
    bgView.layer.cornerRadius = 25;
    
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@50);
        make.centerX.equalTo(cell.contentView).mas_offset(temp);
        make.top.mas_equalTo(@10);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [cell.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.contentView).mas_offset(temp);
        make.width.mas_equalTo(@30);
        make.height.mas_equalTo(@30);
        make.top.mas_equalTo(@20);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, width-20, width, 20)];
    [cell.contentView addSubview:label];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(cell.contentView);
        make.height.mas_equalTo(@20);
        make.top.mas_equalTo(@68);
        make.centerX.equalTo(imageView);
    }];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorFromHexString:@"#666666"];
    label.text = model.name;
    
    if (![model.backImg containsString:@"http"])
    {
        
        [imageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.contentView).mas_offset(temp);
            make.width.mas_equalTo(@40);
            make.height.mas_equalTo(@40);
            make.top.mas_equalTo(@15);
        }];
        
        imageView.image = [UIImage imageNamed:model.backImg];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
    }
    else
    {
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.backImg]];
    }
    
    bgView.backgroundColor = colorArray[indexPath.item%6];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChildrenModel *model = _dataArray[indexPath.item];
    
    if (_childrenDelegate && [_childrenDelegate respondsToSelector:@selector(listChildrenViewDidClickedModel:andCategoryModel:)])
    {
        [_childrenDelegate listChildrenViewDidClickedModel:model andCategoryModel:_model];
    }
}

- (void)setModel:(CategoryModel *)model
{
    _model = model;
    _dataArray = _model.children;
    
    
    CGFloat width = self.frame.size.width / 3;
    
    NSInteger num =  (_dataArray.count-1)/3 + 1;
    
    
    self.frame = CGRectMake(0, 0, self.frame.size.width,num*width);
    
    [self reloadData];
}

//}





@end
