//
//  GiftCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/27.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "GiftCell.h"
#import "HLSegementView.h"
#import "GiftCollectionCell.h"
#import "BaseCollectionView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "WMMenuView.h"
#import "ProductDetailViewController.h"
#import "AppDelegate.h"

#import "Masonry.h"

@interface GiftCell () <HLSegementViewDelegate, UICollectionViewDelegate , UICollectionViewDataSource, WMMenuViewDataSource, WMMenuViewDelegate>

@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *array1;
@property (nonatomic, strong) NSMutableArray *array2;
@property (nonatomic, strong) NSMutableArray *array3;
@property (nonatomic, strong) NSMutableArray *array4;
@property (nonatomic, strong) NSMutableArray *array5;
@property (nonatomic, strong) NSMutableArray *array6;
@property (nonatomic, strong) NSMutableArray *array7;
@property (nonatomic, strong) NSMutableArray *array8;
//@property (nonatomic, strong) HLSegementView *segementView;
@property (nonatomic, strong) NSArray *tempArray;
@property (nonatomic, strong) WMMenuView *menu;


/** 空视图 */
@property (nonatomic,strong) UIView *emptyView;

@end

@implementation GiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.backgroundColor = [UIColor whiteColor];
        
//        UIImageView *imgVw = [[UIImageView alloc] init];
//        imgVw.image = kGetImage(@"order_null");
//
        UILabel *lab = [[UILabel alloc] init];
//        [lab SetlabTitle:@"小主，当前栏目下暂无商品可换购了哦~" andFont:kFont(IS_IPHONE_5?13:15) andTitleColor:[UIColor lightGrayColor] andTextAligment:1 andBgColor:nil];
        lab.text = @"小主，当前栏目下暂无商品可换购了哦~";
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor lightGrayColor];
        lab.textAlignment = NSTextAlignmentCenter;
        
//        [_emptyView addSubview:imgVw];
        [_emptyView addSubview:lab];
//        [imgVw mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self->_emptyView);
//            make.top.equalTo(self->_emptyView).offset(120);
//        }];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self->_emptyView);
        }];
        
    } return _emptyView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = LineColor;
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 16, 16)];
        leftImageView.image = [UIImage imageNamed:@"gift"];
        [self.contentView addSubview:leftImageView];
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 16)];
        topLabel.text = @"换购专区  (满购金额不包含邮费)";
        topLabel.font = [UIFont systemFontOfSize:13];
        topLabel.textColor = TextColor;
        [self.contentView addSubview:topLabel];
//        
//        NSArray *array = @[@"面膜专区",@"满28纽币换购",@"满58纽币换购",@"满68纽币换购",@"满98纽币换购",@"满188纽币换购"];
//        _segementView = [[HLSegementView alloc] initWithFrame:CGRectMake(0, 25, G_SCREEN_WIDTH, 40) titles:@[@"面膜专区",@"满28纽币换购",@"满58纽币换购",@"满68纽币换购",@"满98纽币换购",@"满188纽币换购"]];
        
//        _segementView.delegate = self;
//        [self.contentView addSubview:_segementView];
        
        _menu = [[WMMenuView alloc] initWithFrame:CGRectMake(0, 25, G_SCREEN_WIDTH, 40)];
        _menu.delegate = self;
        _menu.dataSource = self;
//        _menu.style = 
        [self.contentView addSubview:_menu];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(G_SCREEN_WIDTH, 130);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[BaseCollectionView alloc] initWithFrame:CGRectMake(0, 70, G_SCREEN_WIDTH, 130) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.showEmptyView = YES;
//        _collectionView.emptyImg = NULL;
//        _collectionView.emptyText = @"小主，当前栏目下暂无商品可换购了哦~";
        _collectionView.backgroundView = self.emptyView;
        _collectionView.backgroundColor = LineColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[GiftCollectionCell class] forCellWithReuseIdentifier:@"GiftCollectionCell"];
        [self.contentView addSubview:_collectionView];
        
        _allArray = [[NSMutableArray alloc] init];
        _selectArray = [[NSMutableArray alloc] init];
        _array1 = [[NSMutableArray alloc] init];
        _array2 = [[NSMutableArray alloc] init];
        _array3 = [[NSMutableArray alloc] init];
        _array4 = [[NSMutableArray alloc] init];
        _array5 = [[NSMutableArray alloc] init];
        _array6 = [[NSMutableArray alloc] init];
        _array7 = [[NSMutableArray alloc] init];
        _array8 = [[NSMutableArray alloc] init];
//        _temp
    }
    
    return self;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _selectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GiftCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GiftCollectionCell" forIndexPath:indexPath];
    
    if (_selectArray.count>0) {
        cell.model = _selectArray[indexPath.item];
        cell.needMoney = _model.needMoney;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductModel *model = _selectArray[indexPath.item];
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    vc.productId = model.productId;
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabbar.selectedViewController pushViewController:vc animated:YES];
}

- (void)setModel:(CartModel *)model
{
    _model = model;
    
    NSArray *array;
    
    [_allArray removeAllObjects];
    
    [_selectArray removeAllObjects];
    
    
    NSDictionary *dic = _model.common;
    
    NSNumber *totalFee = dic[@"firstTotalAmount"];
    
    NSNumber *shipFee = dic[@"firstShippingFee"];
    
    CGFloat needMoney = [totalFee floatValue] - [shipFee floatValue];
    
    _model.needMoney = needMoney;
    
    if ([_model.shopId isEqualToString:@"4"])
    {
        array = @[@"0" ,@"99", @"199", @"299", @"599", @"899"];
//
//        _segementView = [[HLSegementView alloc] initWithFrame:CGRectMake(0, 25, G_SCREEN_WIDTH, 40) titles:@[@"面膜专区",@"满99人民币换购",@"满199人民币换购",@"满299人民币换购",@"满599人民币换购",@"满899人民币换购"]];
//        _segementView.titles = @[@"面膜专区",@"满99人民币换购",@"满199人民币换购",@"满299人民币换购",@"满599人民币换购",@"满899人民币换购"];
//        _segementView
        _tempArray = @[@"面膜专区",@"满99人民币换购",@"满199人民币换购",@"满299人民币换购",@"满599人民币换购",@"满899人民币换购"];
        [_menu reload];
    }
    else
    {
        _tempArray = @[@"面膜专区",@"满28纽币换购",@"满58纽币换购",@"满68纽币换购",@"满98纽币换购",@"满188纽币换购", @"满258纽币换购", @"满298纽币换购"];
        [_menu reload];
//        _segementView = [[HLSegementView alloc] initWithFrame:CGRectMake(0, 25, G_SCREEN_WIDTH, 40) titles:@[@"面膜专区",@"满28纽币换购",@"满58纽币换购",@"满68纽币换购",@"满98纽币换购",@"满188纽币换购"]];
//        _segementView.titles = @[@"面膜专区",@"满28纽币换购",@"满58纽币换购",@"满68纽币换购",@"满98纽币换购",@"满188纽币换购"];
         array = @[@"0" ,@"28", @"58", @"68", @"98", @"188", @"258", @"298"];
    }
  
    
    for (int i=0; i<_model.giftProducts.count; i++)
    {
        ProductModel *modell = _model.giftProducts[i];
        
        if ([modell.firstGiftThreshold isEqualToString:array[0]] || [modell.secondGiftThreshold isEqualToString:array[0]])
        {
            [_array1 addObject:modell];
        }
        else if ([modell.firstGiftThreshold isEqualToString:array[1]] || [modell.secondGiftThreshold isEqualToString:array[1]])
        {
            [_array2 addObject:modell];
        }
        else if ([modell.firstGiftThreshold isEqualToString:array[2]] || [modell.secondGiftThreshold isEqualToString:array[2]])
        {
            [_array3 addObject:modell];
        }
        else if ([modell.firstGiftThreshold isEqualToString:array[3]] || [modell.secondGiftThreshold isEqualToString:array[3]])
        {
            [_array4 addObject:modell];
        }
        else if ([modell.firstGiftThreshold isEqualToString:array[4]] || [modell.secondGiftThreshold isEqualToString:array[4]])
        {
            [_array5 addObject:modell];
        }
        else if ([modell.firstGiftThreshold isEqualToString:array[5]] || [modell.secondGiftThreshold isEqualToString:array[5]])
        {
            [_array6 addObject:modell];
        }
       
        
        if (![_model.shopId isEqualToString:@"4"])
        {
            if ([modell.firstGiftThreshold isEqualToString:array[6]] || [modell.secondGiftThreshold isEqualToString:array[6]])
            {
                [_array7 addObject:modell];
            }
            
            if ([modell.firstGiftThreshold isEqualToString:array[7]] || [modell.secondGiftThreshold isEqualToString:array[7]])
            {
                [_array8 addObject:modell];
            }
            
        }
        
    }
    
    _selectArray = _array1;
    
    [_allArray addObject:_array1];
    [_allArray addObject:_array2];
    [_allArray addObject:_array3];
    [_allArray addObject:_array4];
    [_allArray addObject:_array5];
    [_allArray addObject:_array6];
    
    if (![_model.shopId isEqualToString:@"4"])
    {
        [_allArray addObject:_array7];
        [_allArray addObject:_array8];
    }
    
    
    [_collectionView reloadData];
}


- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu
{
    return _tempArray.count;
}
- (NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index
{
    
    return _tempArray[index];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index
{
    NSString *title = _tempArray[index];
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    CGFloat itemWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attrs context:nil].size.width+10;
//    itemWidth = itemWidth < 30 ? 30 : itemWidth;
    return ceil(itemWidth);
}

- (CGFloat)menuView:(WMMenuView *)menu titleSizeForState:(WMMenuItemState)state atIndex:(NSInteger)index
{
    return 12;
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state atIndex:(NSInteger)index
{
    if (state == WMMenuItemStateSelected)
    {
        return TextColor;
    }
    else
        return LightGrayColor;
}

- (void)menuView:(WMMenuView *)menu didSelectedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex
{
    _selectArray = _allArray[index];
    [_collectionView reloadData];
}


- (NSString *)moneyWithString:(NSString *)str
{
    CGFloat price = [str floatValue];
    if (str.length > 6)
    {
        NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        NSDecimalNumber *ouncesDecimal;
        NSDecimalNumber *roundedOunces;
        ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
        roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
        str = [NSString stringWithFormat:@"%@",roundedOunces];
    }
    
    return str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
