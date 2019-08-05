//
//  PushListVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/4/29.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "PushListVC.h"
#import <Masonry.h>
#import <WebKit/WebKit.h>
#import "MsgModel.h"
#import "ActivityMsgCell.h"
#import "H5ViewController.h"
#import "NewsVC.h"
#import "TimeTool.h"
#import "OrderDetailViewController.h"

@interface PushListVC ()<UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate>

@property (nonatomic, strong) NSMutableDictionary *param;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation PushListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    _page = 1;
    _dataArray = [[NSMutableArray alloc] init];
    _param = [[NSMutableDictionary alloc] init];
    [_param setObject:self.type forKey:@"type"];
    [_param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [self initUI];
    [self getPushList];
    
//    [self getPushList];
}

- (void)initUI
{
    _tableView = [[BaseTableView alloc] initWithFrame:G_SCREEN_BOUNDS style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.estimatedRowHeight=0;
    _tableView.estimatedSectionHeaderHeight=0;
    _tableView.estimatedSectionFooterHeight=0;
    [_tableView registerClass:[ActivityMsgCell class] forCellReuseIdentifier:@"ActivityMsgCell"];
    _tableView.backgroundColor = [UIColor colorFromHexString:@"#EBEBEB"];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self getPushList];
    }];
    
    _tableView.emptyImg = [UIImage imageNamed:@"图层33"];
    _tableView.showEmptyView = YES;
    _tableView.emptyText = @"喔唷！这里还没有任何信息哦~";
    _tableView.emptyBackgroundColor = [UIColor colorFromHexString:@"#EBEBEB"];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page = _page + 1;
        [self getPushListWithPage:_page];
    }];
    [footer setTitle:@"-已经到底了-" forState:MJRefreshStateNoMoreData];
    footer.automaticallyHidden = YES;
    _tableView.mj_footer = footer;
    
    [self.view addSubview:_tableView];
    
    if (self.fromPush)
    {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
        [leftBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(backBtnClickk) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        [self.navigationItem setLeftBarButtonItem:leftItem];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)backBtnClickk
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray.count > 0)
    {
        MsgModel *model = _dataArray[indexPath.section];
        
        NSLog(@"height = %f", model.imageHeight + model.titleHight + model.subTitleHight + 20 + 40);
        
        return model.imageHeight + model.titleHight + model.subTitleHight + 20 + 40;;
    }
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ActivityMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActivityMsgCell" forIndexPath:indexPath];
    
    MsgModel *model = _dataArray[indexPath.section];
    
    NSLog(@"%lu == %@", indexPath.section, model.msgId);
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgModel *model = _dataArray[indexPath.section];
    
    if (model.isEnd)
    {
        return;
    }
    
    if ([self.type isEqualToString:@"1"])
    {
        if ([[NSString stringWithFormat:@"%@",model.showType] isEqualToString:@"1"])
        {
            NSString *testUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"loginUrl"];
            H5ViewController *vc = [[H5ViewController alloc] init];
            vc.urlString = [NSString stringWithFormat:@"%@/m/user/appRedirect?sessionId=%@&ref=%@",testUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionId"],[NSString stringWithFormat:@"%@",model.href]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([[NSString stringWithFormat:@"%@",model.showType] isEqualToString:@"2"])
        {
            NewsVC *vc = [[NewsVC alloc] init];
            vc.news = model.news;
            vc.titleString = model.alert;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([self.type isEqualToString:@"3"])
    {
        OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
        vc.orderId = model.href;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)getPushList
{
    [_param setObject:[NSString stringWithFormat:@"%li", (long)_page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/push/list" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        [_dataArray removeAllObjects];
        [loadingHud hideAnimated:YES];
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *data = result[@"data"];
            MsgModel *modelList = [MsgModel yy_modelWithDictionary:data];
            

            if (modelList.rows.count > 0)
            {
                for (MsgModel *model in modelList.rows)
                {
                    model.subTitleHight = [model.subtitle boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
                    model.titleHight = [model.alert boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
                    NSString *timeString = [TimeTool getTimeStringAutoShort2:[NSDate dateWithTimeIntervalSince1970:[model.pushTime integerValue]] mustIncludeTime:YES];
                    if ([model.subtitle containsString:@"\n"])
                    {
                        model.subTitleHight = model.subTitleHight+20;
                    }
                    model.time = [NSString stringWithFormat:@"   %@   ",timeString];
                    
                    model.imageHeight = 0;
                    if (model.thumbnail && model.thumbnail.length > 0)
                    {
                        model.imageHeight = G_SCREEN_WIDTH/381.0*152;
                    }
                    
                    NSString *str = [NSString stringWithFormat:@"%@", model.endTime];
                    if (str.length > 0)
                    {
                        if ([model.endTime longLongValue] < [TimeTool getIOSTimeStamp:[NSDate date]])
                        {
                            model.isEnd = YES;
                        }
                    }
                    
                    [_dataArray addObject:model];
                }
            }
            else
            {
                
                self.tableView.showEmptyView = YES;
            }
            
            [_tableView.mj_header endRefreshing];
            
            [_tableView reloadData];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)getPushListWithPage:(NSInteger)page
{
    [_param setObject:[NSString stringWithFormat:@"%li", (long)page] forKey:@"pageNumber"];
    [_param setObject:@"30" forKey:@"pageSize"];
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/push/list" parameters:_param success:^(NSURLSessionDataTask *task, id result) {
        [loadingHud hideAnimated:YES];
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *data = result[@"data"];
            MsgModel *modelList = [MsgModel yy_modelWithDictionary:data];
            
            if (modelList.rows.count > 0)
            {
                for (MsgModel *model in modelList.rows)
                {
                    model.subTitleHight = [model.subtitle boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
                    model.titleHight = [model.alert boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-50, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
                    
                    if ([model.subtitle containsString:@"\n"])
                    {
                        model.subTitleHight = model.subTitleHight+20;
                    }
                    
                    NSString *timeString = [TimeTool getTimeStringAutoShort2:[NSDate dateWithTimeIntervalSince1970:[model.pushTime integerValue]] mustIncludeTime:YES];
                    
                    model.time = [NSString stringWithFormat:@"   %@   ",timeString];
                    model.imageHeight = 0;
                    if (model.thumbnail && model.thumbnail.length > 0)
                    {
                        model.imageHeight = G_SCREEN_WIDTH/381.0*152;
                    }
                    
                    NSString *str = [NSString stringWithFormat:@"%@", model.endTime];
                    if (str.length > 0)
                    {
                        if ([model.endTime longLongValue] < [TimeTool getIOSTimeStamp:[NSDate date]])
                        {
                            model.isEnd = YES;
                        }
                    }
                    
                    
                    [_dataArray addObject:model];
                }
                [_tableView.mj_footer endRefreshing];
            }
            else
            {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [_tableView reloadData];
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



@end
