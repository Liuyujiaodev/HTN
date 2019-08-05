//
//  CategoriesCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CategoriesCell.h"
#import "CategoryView.h"

@interface CategoriesCell()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CategoriesCell

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
        _dataArray = [[NSMutableArray alloc] init];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 20)];
        label.text = @"线下店铺";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorFromHexString:@"#999999"];
        [self.contentView addSubview:label];
        
        UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-20, 15, 6, 10)];
        rightImage.image = [UIImage imageNamed:@"right-arrow"];
        [self.contentView addSubview:rightImage];
        
        UIButton *topBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 40)];
        [topBtn addTarget:self action:@selector(shopSelected) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:topBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [self.contentView addSubview:lineView];
        
        CGFloat widthh = G_SCREEN_WIDTH/5;
        
        for (int i=0; i<5; i++)
        {
            for (int j=0; j<2; j++)
            {
                CategoryView *view = [[CategoryView alloc] initWithFrame:CGRectMake(widthh*i, 40+(12+widthh)*j, widthh, widthh+12)];
                view.tag = 1000+i+j*5;
                view.userInteractionEnabled = YES;
//                [view addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClicked:)];
                [view addGestureRecognizer:tap];
                [self.contentView addSubview:view];
            }
        }
    }
    
    return self;
}

-(void)setCategoriesArray:(NSArray *)categoriesArray
{
    [_dataArray removeAllObjects];
    _categoriesArray = categoriesArray;
    
    ActivityModel *model1 = [[ActivityModel alloc] init];
    model1.name = @"全球仓库";
    
    ActivityModel *model2 = [[ActivityModel alloc] init];
    model2.name = @"特价专区";
    
    [_dataArray addObject:model1];
    [_dataArray addObject:model2];
    
    [_dataArray addObjectsFromArray:_categoriesArray];
    
    
    NSArray *array = @[@"icon-cangku",@"icon-tejia",@"icon-muying",@"icon-meirong",@"icon-fushi",@"icon-yingyang",@"icon-shenghuo",@"icon-meishi",@"icon-shuiguo",@"icon-qita"];
    

        for (int i=0; i<_dataArray.count; i++)
        {
            if (i<10)
            {
                ActivityModel *model = _dataArray[i];
                CategoryView *view = [self.contentView viewWithTag:1000+i];
                view.model = model;
                view.imageName = array[i];
                view.title = model.name;
            }
        }

}

- (void)shopSelected
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToShopList" object:nil];
}

- (void)btnClicked:(UITapGestureRecognizer *)tap
{
    CategoryView *view = (CategoryView *)tap.view;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GoToList" object:view.model];
}

@end
