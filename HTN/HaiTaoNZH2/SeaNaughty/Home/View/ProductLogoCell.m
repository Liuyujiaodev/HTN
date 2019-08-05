//
//  ProductLogoCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/7.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProductLogoCell.h"

#import <SDCycleScrollView.h>

@interface ProductLogoCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIView *saleView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) NSMutableArray *titleArray;
//@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ProductLogoCell

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
        
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner_default"]];
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.autoScrollTimeInterval = MAXFLOAT;
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        [self.contentView addSubview:_bannerView];
        
        _numView = [[UIView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-65, G_SCREEN_WIDTH-50, 50, 24)];
        _numView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
        _numView.layer.cornerRadius = 12;
        [self.contentView addSubview:_numView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-65, G_SCREEN_WIDTH-50, 50, 24)];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numLabel];
        
        [self.contentView addSubview:self.saleView];
        
    }
    return self;
}

- (void)setIsSale:(BOOL)isSale
{
    _isSale = isSale;
    
    self.saleView.hidden = !_isSale;
}

- (void)setModel:(ProductModel *)model
{
    _model = model;
    
    if (_model.endTime)
    {
        _saleEndTimeSecond = _model.endTime;
        _timeLabel.text = [self countTimer:_model.endTime];
    }
    else
    {
        self.saleView.hidden = YES;
    }
    
    _bannerView.imageURLStringsGroup = _model.carouselImgs;
    
    _titleArray = [[NSMutableArray alloc] init];
    for (int i=0; i<_model.carouselImgs.count; i++)
    {
        NSString *string = [NSString stringWithFormat:@"%i / %lu", i+1, (unsigned long)_model.carouselImgs.count];
        [_titleArray addObject:string];
    }
    
    
    
    _numLabel.text = _titleArray[0];
    
//    _bannerView.titlesGroup = titleArray;
}

- (void)setSaleEndTimeSecond:(NSTimeInterval)saleEndTimeSecond
{
    _saleEndTimeSecond = saleEndTimeSecond;
    
    _timeLabel.text = [self countTimer:_model.endTime];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    _numLabel.text = _titleArray[index];
}


- (NSString *)countTimer:(NSTimeInterval)endTime
{
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval createTime = endTime;
    NSTimeInterval endTimeSecond = createTime - currentTime;
    
    int days = floor(endTimeSecond / 86400);
    endTimeSecond = endTimeSecond-days*86400;
    int hour = endTimeSecond/60/60;
    endTimeSecond = endTimeSecond-hour*60*60;
    int minute = endTimeSecond/(60);
    endTimeSecond = endTimeSecond-minute*60;
    int second = ((int)endTimeSecond % (60));
    
    NSString *tempTime;
    if (days>0)
    {
        tempTime = [NSString stringWithFormat:@"    距活动结束%d天%02d时%02d分%02d秒", days, hour, minute, second];
    }
    else
    {
        tempTime = [NSString stringWithFormat:@"    距活动结束%02d时%02d分%02d秒", hour, minute, second];
    }
    
    return tempTime;
}

- (UIView *)saleView
{
    if (!_saleView)
    {
        _saleView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_WIDTH, G_SCREEN_WIDTH, 40)];
        _saleView.backgroundColor = [UIColor colorFromHexString:@"#FFA800"];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 75, 20)];
        btn.layer.cornerRadius = 10;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitle:@"限时特价" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorFromHexString:@"#FFA800"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [_saleView addSubview:btn];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, G_SCREEN_WIDTH-100, 20)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [_saleView addSubview:_timeLabel];
        
    }
    return _saleView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
