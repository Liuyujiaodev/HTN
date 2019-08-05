//
//  FirstSectionCell.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/15.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "FirstSectionCell.h"
#import <YYText.h>

@interface FirstSectionCell ()
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) YYLabel *numLabel;
@end

@implementation FirstSectionCell

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
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 16, 16)];
        imageView.image = [UIImage imageNamed:@"订单"];
        [self.contentView addSubview:imageView];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 13, 200, 20)];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_statusLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, G_SCREEN_WIDTH-60, 20)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        
        _numLabel = [[YYLabel alloc] initWithFrame:CGRectMake(40, 60, G_SCREEN_WIDTH-60, 20)];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = [UIFont systemFontOfSize:12];
        MJWeakSelf;
        _numLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.model.orderNumber)
            {
                [SVProgressHUD showSuccessWithStatus:@"订单号复制成功"];
                UIPasteboard * paste = [UIPasteboard generalPasteboard];
                paste.string = weakSelf.model.orderNumber;
                [SVProgressHUD dismissWithDelay:0.6];
            }
            
        };
        [self.contentView addSubview:_numLabel];
    }
    return self;
}

//- (void)setMiandan:(BOOL)miandan
//{
//    _miandan = miandan;
//    if (_miandan)
//    {
//        _statusLabel.text = @"已支付";
//    }
//}

- (void)setModel:(OrderModel *)model
{
    _model = model;
//    [NSArray arrayWithObjects: @"草稿",@"预定",@"未支付",@"待发货",@"已发货",@"已取消",@"备货中",@"已确认收货",@"已发货",@"已发货", nil]
//    1 = '草稿'; 2= '预定'; 3= '待确认'; 4:='待发货'; 5 = '已发货'; 6 = '已取消'; 7= '备货中'; 8= '已确认收货'; 9 = '已发货';10 = '已发货';
    NSArray *array = [NSArray arrayWithObjects: @"草稿",@"预定",@"未付款",@"待发货",@"已发货",@"已取消",@"备货中",@"已确认收货",@"已发货",@"已发货", nil];
    
    _statusLabel.text = array[model.status-1];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model.createTime longLongValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *createTime = [formatter stringFromDate:date];

    _timeLabel.text = [NSString stringWithFormat:@"下单时间：%@", createTime];
    
    _numLabel.text = [NSString stringWithFormat:@"订单编号：%@", _model.orderNumber];
    
    if (_model.status == 3)
    {
        self.contentView.backgroundColor = MainColor;
    }
    else
    {
        self.contentView.backgroundColor = [UIColor grayColor];
    }
    
    if (_model.status == 3 && _model.isPay)
    {
        _statusLabel.text = @"已支付";
        NSLog(@"%@", _model.isPay);
    }
    else if (_model.status == 3 && !_model.isPay && [[[NSUserDefaults standardUserDefaults] valueForKey:@""] isEqualToString:@"1"])
    {
        _statusLabel.text = @"待确认";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
