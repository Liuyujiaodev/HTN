//
//  RedpacketVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/3/31.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "RedpacketVC.h"
#import <Masonry.h>
#import "PayViewController.h"
#import "OrderListViewController.h"

@interface RedpacketVC ()

@property (nonatomic, strong) UILabel *orderIdLabel;
@property (nonatomic, strong) UILabel *luckLabel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RedpacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self initUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(btnAction) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)initUI
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:G_SCREEN_BOUNDS];
    [self.view addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"红包2"];
    
    UIImageView *topImageView = [[UIImageView alloc] init];
    topImageView.image = [UIImage imageNamed:@"恭喜您"];
    [self.view addSubview:topImageView];
    
    CGFloat tempHeight = 130;
    if (G_SCREEN_HEIGHT < 800)
    {
        tempHeight = 80;
    }
    
    [topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@192);
        make.height.equalTo(@68);
        make.top.equalTo(@(G_SCREEN_HEIGHT-370/424.0*G_SCREEN_WIDTH-138/450.0*G_SCREEN_WIDTH-tempHeight));
        make.centerX.mas_equalTo(self.view);
    }];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.image = [UIImage imageNamed:@"红包1"];
    [self.view addSubview:imageView1];
    [imageView1 makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self.view);
        make.top.mas_equalTo(topImageView.mas_bottom);
        make.height.mas_equalTo(@(370/424.0*G_SCREEN_WIDTH));
    }];
    
    UIImageView *goldImageView = [[UIImageView alloc] init];
    goldImageView.image = [UIImage imageNamed:@"金币"];
    [self.view addSubview:goldImageView];
    [goldImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.mas_equalTo(self.view);
        make.top.mas_equalTo(imageView1.mas_bottom).mas_offset(-58);
        make.height.mas_equalTo(@(138/450.0*G_SCREEN_WIDTH));
    }];
    
    
    _orderIdLabel = [[UILabel alloc] init];
    _orderIdLabel.textAlignment = NSTextAlignmentCenter;
    _orderIdLabel.textColor = TitleColor;
    _orderIdLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:_orderIdLabel];
    
    _luckLabel = [[UILabel alloc] init];
    _luckLabel.textAlignment = NSTextAlignmentCenter;
    _luckLabel.textColor = [UIColor colorFromHexString:@"#D00800"];
    _luckLabel.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:_luckLabel];
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    label.text = @"-将直接为您抵扣订单金额-";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = TextColor;
    label.font = [UIFont systemFontOfSize:13];
    
    [_orderIdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(imageView1.mas_top).mas_offset(70);
        make.height.equalTo(@30);
    }];
    
    [_luckLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.equalTo(_orderIdLabel.mas_bottom);
        make.height.equalTo(@63);
    }];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.equalTo(_luckLabel.mas_bottom);
        make.height.equalTo(@20);
    }];
    
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@",self.orderNum];
    if ([_totalAmount isEqualToString:@"0"])
    {
        _luckLabel.text = @"此单免单啦！";
    }
    else
    {
        _luckLabel.text = [NSString stringWithFormat:@"NZD $ %@", _luckyMoney];
        topImageView.hidden = YES;
    }
    
    UIButton *btn = [[UIButton alloc] initWithFrame:G_SCREEN_BOUNDS];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)btnAction{
    
    [_timer invalidate];
    _timer = nil;
    //存在中国快仓
    if (self.nextDic && self.nextDic.allKeys > 0) {

        NSNumber *amount = self.nextDic[@"total_amount"];
        NSString *totalAmount = [NSString stringWithFormat:@"%@", amount];
        RedpacketVC *redVC = [[RedpacketVC alloc] init];
        redVC.orderID = self.nextDic[@"id"];
        if ([_totalAmount floatValue] == 0) {
            if (_ordersArray.count > 1) {
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_ordersArray];
                NSString *orderString = [NSString stringWithFormat:@"%@", _orderID];
                if ([tempArray containsObject:orderString])
                {
                    [tempArray removeObject:orderString];
                }
                redVC.ordersArray = tempArray;
                redVC.needPay = YES;
            } else {
                redVC.ordersArray = self.ordersArray;
                redVC.needPay = NO;
            }
        } else {
            redVC.ordersArray = self.ordersArray;
            redVC.needPay = YES;
        }
        NSNumber *luck = self.nextDic[@"luckyMoney"];
        NSString *luckyMoney = [NSString stringWithFormat:@"%@", luck];
        CGFloat price = [luckyMoney floatValue];
        if (luckyMoney.length > 7)
        {
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
            NSDecimalNumber *ouncesDecimal;
            NSDecimalNumber *roundedOunces;
            ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
            roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
            luckyMoney = [NSString stringWithFormat:@"%@",roundedOunces];
        }
        redVC.luckyMoney = luckyMoney;
        redVC.totalAmount = totalAmount;
        redVC.orderNum = self.nextDic[@"order_number"];
        [self.navigationController pushViewController:redVC animated:YES];
    } else if ([_totalAmount floatValue] == 0) {
        if (_ordersArray.count > 1 || self.needPay)
        {
            PayViewController *vc = [[PayViewController alloc] init];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_ordersArray];
            NSString *orderString = [NSString stringWithFormat:@"%@", _orderID];
            if ([tempArray containsObject:orderString])
            {
                [tempArray removeObject:orderString];
            }
            vc.idArray = tempArray;
            vc.isFromShop = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            OrderListViewController *vc = [[OrderListViewController alloc] init];
            vc.fromPay = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        PayViewController *vc = [[PayViewController alloc] init];
        vc.idArray = _ordersArray;
        vc.isFromShop = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (!self.nextDic || self.nextDic.allKeys.count == 0) {
        self.navigationController.navigationBarHidden = NO;
    }
}



@end
