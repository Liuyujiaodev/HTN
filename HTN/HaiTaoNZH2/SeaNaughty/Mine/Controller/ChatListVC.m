//
//  ChatListVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2019/2/26.
//  Copyright © 2019 chilezzz. All rights reserved.
//

#import "ChatListVC.h"
#import "QYSDK.h"
#import "ChatListCell.h"
#import <UserNotifications/UserNotifications.h>
#import "PushListVC.h"
#import "ActivityMsgListVC.h"
#import "TimeTool.h"
#import <Masonry.h>

@interface ChatListVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) BOOL showHeader;
@property (nonatomic, strong) NSDictionary *systemMsg;
@property (nonatomic, strong) NSDictionary *activityMsg;
@property (nonatomic, strong) NSDictionary *logisticsMsg;
@property (nonatomic, strong) MBProgressHUD *loadingHud;
@property (nonatomic, assign) long systemTime;
@property (nonatomic, assign) long activityTime;
@property (nonatomic, assign) long logisticsTime;
@property (nonatomic, assign) long serviceTime;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) QYSessionInfo *info;
@property (nonatomic, assign) NSInteger activityMsgCount;
@property (nonatomic, assign) NSInteger logisticsMsgCount;
@property (nonatomic, assign) NSInteger sysMsgCount;
@property (nonatomic, assign) NSInteger serviceCount;
@end

@implementation ChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    _serviceTime = 0;
    _logisticsTime = 1;
    _activityTime = 2;
    _systemTime = 3;
    
    _activityMsgCount = 0;
    _logisticsMsgCount = 0;
    _sysMsgCount = 0;
    _serviceCount = 0;
    
    _showArray = [[NSMutableArray alloc] initWithArray:@[@"活动促销",@"交易物流",@"系统通知",@"联系客服"]];
    
    [self getUserInfo];
    
    [self initUI];
    
    _loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _loadingHud.mode = MBProgressHUDModeIndeterminate;
    //    loadingHud.
    [_loadingHud showAnimated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self checkCurrentNotificationStatus];
    [self getIndexMsg];
}

- (void)initUI
{
    _tableView = [[UITableView alloc] initWithFrame:G_SCREEN_BOUNDS style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"ChatListCell"];
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
    }];
    
}

#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _showHeader)
    {
        return self.headerView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && _showHeader) {
        return 64;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell" forIndexPath:indexPath];
    
    
    cell.iconName = _showArray[indexPath.row];
    cell.titleString = _showArray[indexPath.row];
    
    if ([_showArray[indexPath.row] isEqualToString:@"活动促销"])
    {
        if (_activityMsg.allKeys.count > 0)
        {
            cell.subTitleString = _activityMsg[@"alert"];
            cell.timeString = [TimeTool getTimeStringAutoShort2:[NSDate dateWithTimeIntervalSince1970:[_activityMsg[@"pushTime"] integerValue]] mustIncludeTime:NO];
            cell.msgCount = _activityMsgCount;
        }
        else
        {
            cell.subTitleString = @"";
            cell.timeString = @"";
            cell.msgCount = 0;
        }
    }
    else if ([_showArray[indexPath.row] isEqualToString:@"交易物流"])
    {
        if (_logisticsMsg.allKeys.count > 0)
        {
            cell.subTitleString = _logisticsMsg[@"alert"];
            cell.timeString = [TimeTool getTimeStringAutoShort2:[NSDate dateWithTimeIntervalSince1970:[_logisticsMsg[@"pushTime"] integerValue]] mustIncludeTime:NO];
            cell.msgCount = _logisticsMsgCount;
        }
        else
        {
            cell.subTitleString = @"";
            cell.timeString = @"";
            cell.msgCount = 0;
        }
    }
    else if ([_showArray[indexPath.row] isEqualToString:@"系统通知"])
    {
        if (_systemMsg.allKeys.count > 0)
        {
            cell.subTitleString = _systemMsg[@"alert"];
            cell.timeString = [TimeTool getTimeStringAutoShort2:[NSDate dateWithTimeIntervalSince1970:[_systemMsg[@"pushTime"] integerValue]] mustIncludeTime:NO];
            cell.msgCount = _sysMsgCount;
        }
        else
        {
            cell.subTitleString = @"";
            cell.timeString = @"";
            cell.msgCount = 0;
        }
    }
    else if ([_showArray[indexPath.row] isEqualToString:@"联系客服"])
    {
        if (_info)
        {
            cell.subTitleString = _info.lastMessageText;
            cell.timeString = [TimeTool getTimeStringAutoShort2:[NSDate dateWithTimeIntervalSince1970:_info.lastMessageTimeStamp] mustIncludeTime:NO];
            cell.msgCount = _serviceCount;
        }
        else
        {
            cell.subTitleString = @"点击查看您与客服的沟通记录";
            cell.timeString = @"";
            cell.msgCount = 0;
        }
        
    }
    
   
    
    return cell;
}

- (void)getUserInfo
{
    NSDictionary *param = @{@"customerId":[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"]};
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/info" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *info = result[@"data"];
            QYUserInfo *user = [[QYUserInfo alloc] init];
            user.userId = info[@"id"];
            NSArray *array = @[@{@"key":@"real_name",@"value":info[@"fullName"]}, @{@"key":@"mobile_phone",@"value":info[@"phone"]}, @{@"key":@"email",@"value":info[@"email"]}];
            NSData *data=[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            user.data = jsonStr;
            
            [[QYSDK sharedSDK] setUserInfo:user];
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_showArray[indexPath.row] isEqualToString:@"联系客服"])
    {
        if ([_showArray[indexPath.row] isEqualToString:@"活动促销"])
        {
            ActivityMsgListVC *vc = [[ActivityMsgListVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        else if ([_showArray[indexPath.row] isEqualToString:@"交易物流"])
        {
            PushListVC *vc = [[PushListVC alloc] init];
            vc.titleString = @"交易物流";
            vc.type = @"3";
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([_showArray[indexPath.row] isEqualToString:@"系统通知"])
        {
            PushListVC *vc = [[PushListVC alloc] init];
            vc.titleString = @"系统通知";
            vc.type = @"1";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        [[QYSDK sharedSDK].conversationManager clearUnreadCount];
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"allUnreadCount"];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        QYSource *source = [[QYSource alloc] init];
        
        source.title = @"客服助手";
        source.urlString = @"https://8.163.com/";
        QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
        sessionViewController.sessionTitle = @"客服助手";
        sessionViewController.source = source;
        sessionViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sessionViewController animated:YES];
    }
    
    
}

-(void) checkCurrentNotificationStatus
{
    if (@available(iOS 10 , *))
    {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus == UNAuthorizationStatusDenied)
            {
                // 没权限
                _showHeader = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
                
            }
            
        }];
    }
    else
    {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
            _showHeader = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
    }
}

- (void)getIndexMsg
{
    NSDictionary *param = @{@"customerId":[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"]};
    
    
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/push/indexMsg" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        [_loadingHud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            
            NSDictionary *dataDic = result[@"data"];
            if ([dataDic.allKeys containsObject:@"systemMsg"])
            {
                _systemMsg = dataDic[@"systemMsg"];
                NSNumber *time = _systemMsg[@"pushTime"];
                _systemTime = [time longValue];
                NSNumber *count = dataDic[@"sysMsgCount"];
                _sysMsgCount = [count integerValue];
            }
            
            if ([dataDic.allKeys containsObject:@"activityMsg"])
            {
                _activityMsg = dataDic[@"activityMsg"];
                NSNumber *time = _activityMsg[@"pushTime"];
                _activityTime = [time longValue];
                NSNumber *count = dataDic[@"activityMsgCount"];
                _activityMsgCount  = [count integerValue];
            }
            
            if ([dataDic.allKeys containsObject:@"logisticsMsg"])
            {
                _logisticsMsg = dataDic[@"logisticsMsg"];
                NSNumber *time = _logisticsMsg[@"pushTime"];
                _logisticsTime = [time longValue];
                
                NSNumber *count = dataDic[@"sysMsgCount"];
                _logisticsMsgCount = [count integerValue];
            }
            
            NSArray *array = [[[QYSDK sharedSDK] conversationManager] getSessionList];
            
            if (array.count > 0)
            {
                _info = [array firstObject];
                _serviceTime = (long)(_info.lastMessageTimeStamp);
                _serviceCount = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
            }
            
            NSArray *tempArray = @[@(_systemTime), @(_activityTime), @(_logisticsTime), @(_serviceTime)];
            
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:NO];
            NSArray *timeArray = [tempArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            NSLog(@"%@", timeArray);
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            
            for (int i=0; i<=3; i++) {
                NSNumber *num = timeArray[i];
                long value = [num longValue];
                if (value == _activityTime)
                {
                    [resultArray addObject:@"活动促销"];
                }
                else if (value == _systemTime)
                {
                    [resultArray addObject:@"系统通知"];
                }
                else if (value == _serviceTime)
                {
                    [resultArray addObject:@"联系客服"];
                }
                else if (value == _logisticsTime)
                {
                    [resultArray addObject:@"交易物流"];
                }
            }
            
            _showArray = [[NSMutableArray alloc] initWithArray:(NSArray *)resultArray];
            
            [_tableView reloadData];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 64)];
        _headerView.backgroundColor = [UIColor colorFromHexString:@"#F5F5F5"];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, G_SCREEN_WIDTH-20, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 10;
        [_headerView addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 12, 12)];
        imageView.image = [UIImage imageNamed:@"pushx"];
        [bgView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(44, 12, G_SCREEN_WIDTH-100, 20)];
        label.text = @"打开系统通知，物流优惠等消息不错过";
        label.textColor = TitleColor;
        label.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-80, 10, 40, 24)];
        btn.backgroundColor = MainColor;
        [btn setTitle:@"开启" forState:UIControlStateNormal];
        btn.layer.cornerRadius = 12;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:btn];
        [btn addTarget:self action:@selector(gotoPush) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headerView;
}

- (void)gotoPush
{
    if (@available(iOS 10 , *)) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }];
    }else{
        
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}

@end
