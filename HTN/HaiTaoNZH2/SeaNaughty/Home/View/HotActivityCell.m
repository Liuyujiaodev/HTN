//
//  HotActivityCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/29.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "HotActivityCell.h"
#import "HotActivityView.h"
#import "ActivityModel.h"

@interface HotActivityCell ()
@property (nonatomic, strong) HotActivityView *view1;
@property (nonatomic, strong) HotActivityView *view2;
@property (nonatomic, strong) HotActivityView *view3;
@property (nonatomic, strong) HotActivityView *view4;
@property (nonatomic, strong) HotActivityView *view5;
@property (nonatomic, strong) HotActivityView *view6;
@property (nonatomic, strong) NSMutableArray *blockArray;

@end

@implementation HotActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat width = G_SCREEN_WIDTH/2-0.5;
        
        
        
        NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(0, 0, width, 110)];
        NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(width+1, 0, width, 110)];
        NSValue *value3 = [NSValue valueWithCGRect:CGRectMake(0, 111, width, 264)];
        NSValue *value4 = [NSValue valueWithCGRect:CGRectMake(width+1, 111, width, 87)];
        NSValue *value5 = [NSValue valueWithCGRect:CGRectMake(width+1, 199, width, 87)];
        NSValue *value6 = [NSValue valueWithCGRect:CGRectMake(width+1, 288, width, 87)];
        
        NSArray *rectArray = @[value1,value2,value3,value4,value5,value6];
        NSArray *colorArray = @[[UIColor colorFromHexString:@"#FEEEE6"],[UIColor colorFromHexString:@"#D7EDFF"],[UIColor colorFromHexString:@"#D7EDFF"],[UIColor colorFromHexString:@"#FEDDE3"],[UIColor colorFromHexString:@"#FEEEE6"],[UIColor colorFromHexString:@"#F8EBFF"]];
        
        NSArray *subTitleColor = @[[UIColor colorFromHexString:@"#FF7F24"],[UIColor colorFromHexString:@"#87CEFA"],[UIColor colorFromHexString:@"#87CEFA"],[UIColor colorFromHexString:@"#FF6A6A"],[UIColor colorFromHexString:@"#FF7F24"],[UIColor colorFromHexString:@"#bc93d4"]];
        
        for (int i=0; i<rectArray.count; i++)
        {
            CGRect frame = [rectArray[i] CGRectValue];
            HotActivityView *hotView = [[HotActivityView alloc] initWithFrame:frame];
            hotView.tag = 3000+i;
            hotView.subTitleColor = subTitleColor[i];
            hotView.backgroundColor = colorArray[i];
            [self.contentView addSubview:hotView];
            hotView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHotActivityView:)];
            [hotView addGestureRecognizer:tap];
        }

    }
    return self;
}

- (UIView *)viewWithFrame:(CGRect)frame Title:(NSString *)title subTitle:(NSString *)subTitle
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 200, 20)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 200, 20)];
    subTitleLabel.text = subTitle;
    subTitleLabel.font = [UIFont systemFontOfSize:13];
    subTitleLabel.textColor = [UIColor grayColor];
    [view addSubview:subTitleLabel];
    
    
    
    return view;
}

-(void)setDataArray:(NSArray *)dataArray
{
    _blockArray = [[NSMutableArray alloc] initWithArray:dataArray];
    
    ActivityModel *tempModel = [[ActivityModel alloc] init];
    tempModel.subTitle = @"";
    tempModel.name = @"";
    NSInteger num = 6-dataArray.count;
    
    
    for (int i=0; i<num; i++)
    {
        [_blockArray addObject:tempModel];
    }
    
    for (int i=0; i<6; i++)
    {
        ActivityModel *model = _blockArray[i];
        HotActivityView *view = [self.contentView viewWithTag:3000+i];
        view.subTitle = model.subTitle;
        view.title = model.name;
        view.model = model;
        view.imageName = [NSString stringWithFormat:@"%i", i+1];
    }
}

- (void)tapHotActivityView:(UITapGestureRecognizer *)tap
{
    HotActivityView *view = (HotActivityView *)tap.view;
    
    if (view.model.name.length>0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HotActivityNotification" object:view.model];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
