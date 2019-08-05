//
//  PayTypeCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "FifthCell.h"
#import "YBImageBrowser.h"
#import <YYText.h>

@interface FifthCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation FifthCell

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
        
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
        leftLable.text = @"快递公司";
        leftLable.textColor = TextColor;
        leftLable.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:leftLable];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-115, 12, 100, 20)];
        _label.textAlignment = NSTextAlignmentRight;
        _label.textColor = TextColor;
        _label.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_label];
        
        _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 70, 60, 20)];
        [_btn1 setTitleColor:MainColor forState:UIControlStateNormal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:11];
        [_btn1 addTarget:self action:@selector(btnAction1) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn1];
        
        _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(85, 70, 60, 20)];
        [_btn2 setTitleColor:MainColor forState:UIControlStateNormal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:11];
        [_btn2 addTarget:self action:@selector(btnAction2) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn2];
        
        _btnArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setModel:(OrderModel *)model
{
    _model = model;
    
    _label.text = _model.courierName;
    
    if (_model.shipImgUrl && _model.shipImgUrl.length > 0)
    {
        [_btnArray addObject:@"面单照片"];
    }
    
    if (_model.shipPhotoUrl && _model.shipPhotoUrl.length > 0)
    {
        [_btnArray addObject:@"实拍照片"];
    }
    
    if (_btnArray.count==1)
    {
        _btn2.hidden = YES;
        [_btn1 setTitle:_btnArray[0] forState:UIControlStateNormal];
    }
    else if (_btnArray.count == 2)
    {
        [_btn1 setTitle:_btnArray[0] forState:UIControlStateNormal];
        [_btn2 setTitle:_btnArray[1] forState:UIControlStateNormal];
    }
    
    if (_model.shippingNumber.length > 0)
    {
        NSArray *array = [_model.shippingNumber componentsSeparatedByString:@","];
        CGFloat width1 = 0;
        int temp = 0;
        for (int i=0; i<array.count; i++)
        {
            NSString *title = array[i];
            CGFloat height = 40;
            
            CGFloat width = [title boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width+65;
            
            if (i!=0)
            {
                width1 = [array[i-1] boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width+65+width1;
                
                NSLog(@"%f", G_SCREEN_WIDTH);
                
                if (width1+width > G_SCREEN_WIDTH-30-30*temp)
                {
                    temp = 0;
                    width1 = 0;
                    height = 60;
                }
            }
            
            UIView *view1 = [self.contentView viewWithTag:100+i];
            [view1 removeFromSuperview];
            UIView *view2 = [self.contentView viewWithTag:1100+i];
            [view2 removeFromSuperview];
            
            UIView *vieww = [self btnViewTitle:array[i] tag:100+i frame:CGRectMake(15*(temp+1)+width1, height, width, 20)];
            
            temp++;
            
            [self.contentView addSubview:vieww];
        }
    }
}

- (void)btnAction1
{
    NSMutableArray *browserDataArr = [NSMutableArray array];
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    
    if ([_btn1.titleLabel.text isEqualToString:@"实拍照片"])
    {
        data.url = [NSURL URLWithString:_model.shipPhotoUrl];
    }
    else
        data.url = [NSURL URLWithString:_model.shipImgUrl];
    
    
    [browserDataArr addObject:data];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    browser.currentIndex = 0;
    [browser show];
}

- (void)btnAction2
{
    NSMutableArray *browserDataArr = [NSMutableArray array];
    
    YBImageBrowseCellData *data = [YBImageBrowseCellData new];
    data.url = [NSURL URLWithString:_model.shipPhotoUrl];
    [browserDataArr addObject:data];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = browserDataArr;
    browser.currentIndex = 0;
    [browser show];
}

- (UIView *)btnViewTitle:(NSString *)title tag:(NSInteger)tag frame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    CGFloat width = frame.size.width - 60;
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(3, 0, width, 20)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = LightGrayColor;
    label.tag = tag+1000;
    [view addSubview:label];
    label.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (title)
        {
            [SVProgressHUD showSuccessWithStatus:@"快递单号复制成功"];
            UIPasteboard * paste = [UIPasteboard generalPasteboard];
            paste.string = title;
            [SVProgressHUD dismissWithDelay:0.6];
        }
    };
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width+4, 0, 60, 20)];
    [btn setTitle:@"物流追踪" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorFromHexString:@"#0EA4EA"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

- (void)btnClick:(UIButton *)btn
{
    NSArray *array = [_model.shippingNumber componentsSeparatedByString:@","];
    
    NSInteger temp = btn.tag - 100;
    
    NSString *str = array[temp];
    
//    NSNotification *notification = [NSNotification notificationWithName:@"goToProductDetailVC" object:str userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POSTAGECLICK" object:str];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
