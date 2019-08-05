//
//  WuliuViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/25.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "WuliuViewController.h"
#import <Masonry.h>
#import "WuliuCell.h"
#import <YYLabel.h>

@interface WuliuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WuliuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流详情";
    _dataArray = [[NSMutableArray alloc] init];
    [self initUI];
    [self getDetail];
    
}

- (void)initUI
{
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideTop);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
    _tableView.tableHeaderView = self.headerView;
    _tableView.estimatedRowHeight = 100;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[WuliuCell class] forCellReuseIdentifier:@"WuliuCell"];
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WuliuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WuliuCell" forIndexPath:indexPath];
    cell.dataDic = _dataArray[indexPath.row];
    
    if (indexPath.row == 0)
    {
        cell.isFirst = YES;
        cell.isLast = NO;
    }
    else if (indexPath.row == _dataArray.count-1)
    {
        cell.isFirst = NO;
        cell.isLast = YES;
    }
    else
    {
        cell.isFirst = NO;
        cell.isLast = NO;
    }
    
    
    if (_dataArray.count == 1)
    {
        cell.isFirst = YES;
        cell.isLast = NO;
    }
    
    return cell;
}




- (void)getDetail
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.shippingNumber forKey:@"shippingNumber"];
    [param setObject:self.courierCode forKey:@"courierCode"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/orders/track" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        
        [hud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            _dataArray = [[NSMutableArray alloc] initWithArray:result[@"data"]];
            [_tableView reloadData];
        }
        
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
        [hud hideAnimated:YES];
        
    }];
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 75)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        NSString *str = [NSString stringWithFormat:@"物流公司:%@", self.courierName];
        
        CGFloat width = [str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width+5;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, width, 20)];
        label1.text = str;
        label1.font = [UIFont systemFontOfSize:14];
        label1.textColor = TextColor;
        [_headerView addSubview:label1];
        
       
        
        YYLabel *label2 = [[YYLabel alloc] initWithFrame:CGRectMake(15, 40, G_SCREEN_WIDTH-30, 20)];
        label2.text = [NSString stringWithFormat:@"快递单号:%@", self.shippingNumber];
        label2.font = [UIFont systemFontOfSize:14];
        label2.textColor = TextColor;
        [_headerView addSubview:label2];
        
        MJWeakSelf;
        label2.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.shippingNumber)
            {
                [SVProgressHUD showSuccessWithStatus:@"快递单号复制成功"];
                UIPasteboard * paste = [UIPasteboard generalPasteboard];
                paste.string = weakSelf.shippingNumber;
                [SVProgressHUD dismissWithDelay:0.6];
            }
        };
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width+30, 15, 60, 20)];
        [btn setTitle:@"官网查询" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor colorFromHexString:@"#0EA4EA"] forState:UIControlStateNormal];
        [_headerView addSubview:btn];
        [btn addTarget:self action:@selector(searchhh) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (void)searchhh
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.website]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
