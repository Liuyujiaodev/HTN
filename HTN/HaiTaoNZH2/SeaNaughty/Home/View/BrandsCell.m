//
//  BrandsCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/29.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "BrandsCell.h"
#import "CommonModel.h"
#import <UIButton+WebCache.h>
@implementation BrandsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat width = G_SCREEN_WIDTH/5;
        CGFloat height = width*55/82;
        
        for (int i = 0; i<5; i++)
        {
            for (int j = 0; j<5; j++)
            {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width*i, height*j, width, height)];
                btn.tag = 500+i+j*5;
                [self.contentView addSubview:btn];
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
//                btn.imageView.frame = CGRectMake(15, 10, width-30, height-20);
                btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
                btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
    }
    return self;
}

- (void)setBrandArray:(NSArray *)brandArray
{
    _brandArray = brandArray;
    
    NSInteger num = 25;
    
    if (_brandArray.count <= 25)
    {
        num = _brandArray.count;
    }
    
    for (int i=0; i<num; i++)
    {
        CommonModel *model = brandArray[i];
        UIButton *btn = [self.contentView viewWithTag:500+i];
        [btn sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal];

    }
}

- (void)btnAction:(UIButton *)btn
{
    int temp = (int)btn.tag - 500;
    
    CommonModel *model = _brandArray[temp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToBrandList" object:model];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
