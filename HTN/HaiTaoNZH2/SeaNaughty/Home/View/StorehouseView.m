//
//  StorehouseView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/6.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "StorehouseView.h"


@interface StorehouseView ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation StorehouseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = LineColor;
        CGFloat width = (frame.size.width-4)/3;
        CGFloat height = (frame.size.height-2)/2;
        for (int i=0; i<3; i++)
        {
            for (int j=0; j<2; j++)
            {
                ShopModel *model = self.dataArray[i+j*3];
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((width+2)*i, (height+2)*j, width, height)];
                [btn setTitle:model.name forState:UIControlStateNormal];
                btn.tag = 0x10+i+j*3;
                btn.titleLabel.font = [UIFont systemFontOfSize:11];
                [btn setTitleColor:TextColor forState:UIControlStateNormal];
                [btn setTitleColor:MainColor forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
                btn.backgroundColor = [UIColor whiteColor];
                [self addSubview:btn];
                if (i==0 && j==0)
                {
                    btn.selected = YES;
                }
            }
        }
    }
    return self;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
        
        ShopModel *model1 = [[ShopModel alloc] init];
        model1.name = @"全球仓库";
        model1.shopId = @"";
        model1.l2Index = @"";
        model1.nzhIndex = @"";
        model1.linkcIndex = @"";
        [_dataArray addObject:model1];
        
        ShopListModel *list = [ShopListModel yy_modelWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:SHOPLIST]];
        
        [_dataArray addObjectsFromArray:list.data];
    
    }
    return _dataArray;
}

- (void)setFirstName:(NSString *)firstName
{
    _firstName = firstName;
    
    
    UIButton *btn = (UIButton *)[self viewWithTag:0x10];
    
    [btn setTitle:_firstName forState:UIControlStateNormal];
    
}

- (void)btnSelected:(UIButton *)btn
{
    int temp = (int)btn.tag - 0x10;
    ShopModel *model = self.dataArray[temp];
    
    for (id temp in self.subviews)
    {
        if ([temp isKindOfClass:[UIButton class]])
        {
            UIButton *tempBtn = (UIButton *)temp;
            tempBtn.selected = NO;
        }
    }
    
    btn.selected = YES;
    
    if (_delegat && [_delegat respondsToSelector:@selector(storehouseViewSelected:)])
    {
        [_delegat storehouseViewSelected:model];
    }
    
}

@end
