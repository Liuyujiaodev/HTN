//
//  SkuCountCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/1/26.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "SkuCountCell.h"


@interface SkuCountCell () <SkuFilterResultDelegate>

@property (nonatomic, strong) UIView *numBtnView;
@property (nonatomic, strong) UITextField *numTextField;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@end

@implementation SkuCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.numBtnView];
        _countNum = 1;
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(80, 30);
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 8;
        _flowLayout.headerReferenceSize = CGSizeMake(G_SCREEN_WIDTH, 30);
        
        _skuView = [[SkuCollectionView alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 0) collectionViewLayout:_flowLayout];
        _skuView.scrollEnabled = NO;
        _skuView.skuDelegate = self;
        _skuView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_skuView];
        
    }
    return self;
}

- (void)setCountNum:(int)countNum
{
    _countNum = countNum;
    _numTextField.text = [NSString stringWithFormat:@"%i", _countNum];
}

- (void)setSourceArray:(NSArray *)sourceArray
{
    if (!_sourceArray) {
        _sourceArray = sourceArray;
        
        _skuView.sourceArray = sourceArray;
    }
}

- (void)setSkuData:(NSArray *)skuData
{
    if (!_skuData) {
        _skuData = skuData;
        _skuView.skuData = skuData;
    }
}


- (void)setSkuHeight:(CGFloat)skuHeight
{
    _skuHeight = skuHeight;
    _skuView.frame = CGRectMake(15, 5, G_SCREEN_WIDTH-30, _skuHeight);
    _numBtnView.frame = CGRectMake(0, _skuHeight+10, G_SCREEN_WIDTH, 44);
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    _skuView.itemWidth = _itemWidth;
//    _skuView =
}

- (void)setSelectArray:(NSArray *)selectArray
{
    _skuView.selectArray = selectArray;
    [_skuView reloadData];
}



- (UIView *)numBtnView
{
    if (!_numBtnView)
    {
        _numBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 11, G_SCREEN_WIDTH, 44)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 50, 26)];
        label.text = @"数量";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = LightGrayColor;
        [_numBtnView addSubview:label];
        
        UIButton *decreaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 6, 35, 32)];
        [decreaseBtn setTitle:@" - " forState:UIControlStateNormal];
        [decreaseBtn setTitleColor:TextColor forState:UIControlStateNormal];
        decreaseBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        decreaseBtn.layer.borderColor = LightGrayColor.CGColor;
        decreaseBtn.layer.borderWidth = 1;
        [decreaseBtn addTarget:self action:@selector(decreaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_numBtnView addSubview:decreaseBtn];
        
        UIButton *increaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(173, 6, 35, 32)];
        [increaseBtn setTitle:@" + " forState:UIControlStateNormal];
        [increaseBtn setTitleColor:TextColor forState:UIControlStateNormal];
        increaseBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        increaseBtn.layer.borderColor = LightGrayColor.CGColor;
        increaseBtn.layer.borderWidth = 1;
        [increaseBtn addTarget:self action:@selector(increaseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_numBtnView addSubview:increaseBtn];
        
        _numTextField = [[UITextField alloc] initWithFrame:CGRectMake(116, 6, 56, 32)];
        _numTextField.layer.borderColor = LightGrayColor.CGColor;
        _numTextField.layer.borderWidth = 1;
        _numTextField.text = @"1";
        _numTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numTextField.textAlignment = NSTextAlignmentCenter;
        _numTextField.textColor = TitleColor;
        [_numBtnView addSubview:_numTextField];
    }
    return _numBtnView;
}



- (void)skuFilterResult:(NSDictionary *)sku selectArray:(NSArray *)selectArray
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(postProductSku:selectArray:)])
    {
        [_delegate postProductSku:sku selectArray:_skuView.filter.selectedIndexPaths];
    }
}




- (void)decreaseBtnAction
{
    
    if (_countNum > 0)
    {
        _countNum --;
        _numTextField.text = [NSString stringWithFormat:@"%i", _countNum];
        
        if (_delegate && [_delegate respondsToSelector:@selector(postProductCount:)])
        {
            [_delegate postProductCount:_countNum];
        }
        
    }
}

- (void)increaseBtnAction
{
    _countNum ++;
    _numTextField.text = [NSString stringWithFormat:@"%i", _countNum];
    if (_delegate && [_delegate respondsToSelector:@selector(postProductCount:)])
    {
        [_delegate postProductCount:_countNum];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
