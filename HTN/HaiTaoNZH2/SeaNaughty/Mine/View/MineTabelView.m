//
//  MineTabelView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/21.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "MineTabelView.h"
#import "MineTableViewCell.h"

@interface MineTabelView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *headerView;


@end

@implementation MineTabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[MineTableViewCell class] forCellReuseIdentifier:@"MineCell"];
        self.tableHeaderView = self.headerView;
    }
    return self;
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 280)];
        _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 210)];
        topView.backgroundColor = MainColor;
        [_headerView addSubview:topView];
        
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-30, 70, 60, 60)];
        _headerImg.backgroundColor = [UIColor greenColor];
        _headerImg.layer.cornerRadius = 30;
        [_headerView addSubview:_headerImg];
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(15, 170, G_SCREEN_WIDTH-30, 90)];
        botView.backgroundColor = [UIColor whiteColor];
        botView.layer.cornerRadius = 5;
        [_headerView addSubview:botView];
        
        UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
        orderLabel.textColor = TitleColor;
        orderLabel.text = @"我的订单";
        orderLabel.font = [UIFont systemFontOfSize:13];
        [botView addSubview:orderLabel];
        
        UIButton *orderListBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-130, 10, 100, 15)];
        [orderListBtn setTitle:@"查看全部订单" forState:UIControlStateNormal];
        [orderListBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
        orderListBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [botView addSubview:orderListBtn];
        
        NSArray *array = @[@"待付款",@"待发货",@"已发货",@"已收货"];
        CGFloat width = (G_SCREEN_WIDTH-30)/4-60;
        for (int i=0; i<4; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((width+60)*i+width/2, 30, 60, 50)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:TextColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:11];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"图层 %i",i+7]] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(30, -16, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(-5, 18, 10, 5);
            [botView addSubview:btn];
            
    
        }
        
    }
    return _headerView;
}



#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
        return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"个人信息",@"我的会员卡",@"我的收藏夹",@"修改密码",@"地址管理"];
    NSArray *imageArray = @[@"图层 11",@"图层 12",@"图层 13",@"图层 14",@"图层 15"];
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];

    
    if (indexPath.section==0)
    {
        cell.titleLabel.text = @"优惠券";
        cell.leftLogo.image = [UIImage imageNamed:@"优惠券"];
    }
    else
    {
        cell.titleLabel.text = array[indexPath.row];
        cell.leftLogo.image = [UIImage imageNamed:imageArray[indexPath.row]];
    }
    
    if (indexPath.row==0)
    {
        cell.lineView.hidden = YES;
    }
    
    
    return cell;
}

@end
