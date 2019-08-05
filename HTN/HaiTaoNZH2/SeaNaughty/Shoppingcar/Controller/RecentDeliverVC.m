//
//  RecentDeliverVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "RecentDeliverVC.h"
#import "CommonModelList.h"

@interface RecentDeliverVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, assign) float tempHeight;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CommonModel *postModel;

@end

@implementation RecentDeliverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近发货人";
    
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    self.view.backgroundColor = LineColor;
    //    [self getAddressWithPage:_page];
    
    _tempHeight = 0;
    if (G_STATUSBAR_HEIGHT > 20)
    {
        _tempHeight = 20;
    }
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-50-_tempHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = LineColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    if (_searchArray.count==0)
    {
        _tableView.tableHeaderView = self.headerView;
    }
    
    [self.view addSubview:self.bottomView];
    
    //    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        weakSelf.isRefresh = YES;
    //        weakSelf.page = 1;
    //        [weakSelf getAddressWithPage:weakSelf.page];
    //    }];
    //
    //
    //    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        weakSelf.isRefresh = NO;
    //        weakSelf.page++;
    //        [weakSelf getAddressWithPage:weakSelf.page];
    //    }];
    
    
    
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchArray.count>0)
    {
        return _searchArray.count;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonModel *model;
    if (_searchArray.count>0)
    {
        model = _searchArray[indexPath.section];
    }
    else
    {
        model = _dataArray[indexPath.section];
    }
    
    NSString *newString = [NSString stringWithFormat:@"%@    %@    %@", model.receiveName, model.receivePhone, model.receiveIdCard];
    
    CGFloat nameHeight = [self calculateContentWithText:newString size:CGSizeMake(G_SCREEN_WIDTH-30, 1000) font:14].size.height;
    
    NSString *addressString = [NSString stringWithFormat:@"%@ %@ %@ %@", model.receiveProvince, model.receiveCity, model.receiveArea, model.receiveAddress];
    CGFloat addressHeight = [self calculateContentWithText:addressString size:CGSizeMake(G_SCREEN_WIDTH-30, 1000) font:13].size.height;
    
    
    return nameHeight+addressHeight+30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 8;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 8)];
    lineView.backgroundColor = LineColor;
    return lineView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 8)];
    lineView.backgroundColor = LineColor;
    return lineView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierString = [NSString stringWithFormat:@"cell%li%li",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textColor = TitleColor;
        nameLabel.tag = 100+indexPath.section;
        nameLabel.numberOfLines = 0;
        [cell.contentView addSubview:nameLabel];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, G_SCREEN_WIDTH-30, 20)];
        addressLabel.font = [UIFont systemFontOfSize:13];
        addressLabel.textColor = TextColor;
        addressLabel.numberOfLines = 0;
        addressLabel.tag = 400+indexPath.section;
        [cell.contentView addSubview:addressLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 60, G_SCREEN_WIDTH-30, 1)];
        lineView.backgroundColor = LineColor;
        lineView.tag = 500+indexPath.section;
//        [cell.contentView addSubview:lineView];
        
    }
    
    if (_dataArray.count>0 || _searchArray.count>0)
    {
        CommonModel *model;
        if (_searchArray.count > 0)
        {
            model = _searchArray[indexPath.section];
        }
        else
        {
            model = _dataArray[indexPath.section];
        }
        
        NSString *strPhone = model.sendPhone ? model.sendPhone : @"";
//        NSString *strId = model.se ? model.receiveIdCard : @"";
        
        NSString *newString = [NSString stringWithFormat:@"%@    %@    ", model.sendName, strPhone];
        
        CGFloat nameHeight = [self calculateContentWithText:newString size:CGSizeMake(G_SCREEN_WIDTH-30, 1000) font:14].size.height;
        
        UILabel *nameLabel = [cell.contentView viewWithTag:100+indexPath.section];
        nameLabel.text = newString;
        nameLabel.frame = CGRectMake(15, 12, G_SCREEN_WIDTH-30, nameHeight);
        
        NSString *addressString = @"";
//        if (model.receiveProvince)
//        {
//            addressString = [NSString stringWithFormat:@"%@ %@ %@ %@", model.receiveProvince, model.receiveCity, model.receiveArea, model.receiveAddress];
//        }
//        else
//        {
            addressString = model.sendAddress;
//        }
        
        UILabel *addressLabel = [cell.contentView viewWithTag:400+indexPath.section];
        
        CGFloat addressHeight = [self calculateContentWithText:addressString size:CGSizeMake(G_SCREEN_WIDTH-30, 1000) font:13].size.height;
        
        addressLabel.text = addressString;
        addressLabel.frame = CGRectMake(15, nameHeight+20, G_SCREEN_WIDTH-30, addressHeight);
        
//        UIView *lineView = [cell.contentView viewWithTag:500+indexPath.section];
//        lineView.frame = CGRectMake(15, nameHeight+30+addressHeight, G_SCREEN_WIDTH-30, 1);
//
//        UIButton *editBtn = [cell.contentView viewWithTag:600+indexPath.section];
//        UIButton *delBtn = [cell.contentView viewWithTag:700+indexPath.section];
//
//        editBtn.frame = CGRectMake(G_SCREEN_WIDTH-120, nameHeight+40+addressHeight, 50, 20);
//        delBtn.frame = CGRectMake(G_SCREEN_WIDTH-60, nameHeight+40+addressHeight, 50, 20);
        
    }
    
    return cell;
}

#pragma mark - 获取地址列表数据
- (void)getAddressWithPage:(int)page
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%i",_page] forKey:@"pageNumber"];
    [param setObject:@"1000" forKey:@"pageSize"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    __weak typeof(self) weakSelf = self;
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/sendInfoList" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [loadingHud hideAnimated:YES];
        [_dataArray removeAllObjects];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            
            CommonModelList *list = [CommonModelList yy_modelWithDictionary:result[@"data"]];
            //        NSDictionary *dataDic = dic[@"data"];
            NSArray *array = list.rows;
            
            if (array.count>0)
            {
                weakSelf.postModel = list.rows[0];
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            
            [weakSelf.tableView reloadData];
            
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_searchArray.count > 0)
    {
        _postModel = _searchArray[indexPath.section];
    }
    else
        _postModel = _dataArray[indexPath.section];
}

- (UIView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 44)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(12, 10, G_SCREEN_WIDTH-30, 24)];
        _searchTextField.placeholder = @"姓名 / 手机号码 / 地址";
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.font = [UIFont systemFontOfSize:13];
        _searchTextField.delegate = self;
        [_searchTextField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
        [_headerView addSubview:_searchTextField];
        _searchTextField.text = _keyWord;
        
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-50, 12, 20, 20)];
        [searchBtn setImage:[UIImage imageNamed:@"search-icon"] forState:UIControlStateNormal];
        searchBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
        [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:searchBtn];
        
    }
    return _headerView;
}

- (CGRect)calculateContentWithText:(NSString *)text size:(CGSize)size font:(CGFloat)fontSize
{
    CGRect rect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_searchArray.count==0)
    {
        _page = 1;
        [self getAddressWithPage:_page];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
    
}

- (void)textChanged
{
    if (_searchTextField.text.length == 0)
    {
        self.searchArray = @[];
        [_tableView reloadData];
        _postModel = nil;
    }
}


- (void)searchAction
{
    MJWeakSelf;
    if (_searchTextField.text.length > 0)
    {
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setObject:[NSString stringWithFormat:@"%i",1] forKey:@"pageNumber"];
        [param setObject:@"1000" forKey:@"pageSize"];
        [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
        [param setObject:_searchTextField.text forKey:@"keyword"];
        
        MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        loadingHud.mode = MBProgressHUDModeIndeterminate;
        [loadingHud showAnimated:YES];
        
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/sendInfoList" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            [loadingHud hideAnimated:YES];
            
            CommonModelList *list = [CommonModelList yy_modelWithDictionary:result[@"data"]];
            //        NSDictionary *dataDic = dic[@"data"];
            NSArray *array = list.rows;
            
            if (array.count>0)
            {
//                RecentDeliverVC *vc = [[RecentDeliverVC alloc] init];
//                vc.searchArray = array;
//                weakSelf.keyWord = weakSelf.searchTextField.text;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
                weakSelf.searchArray = array;
                [weakSelf.tableView reloadData];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"没有相关信息"];
                [SVProgressHUD dismissWithDelay:1.2];
            }
            
            
        } fail:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
        
    }
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-50-_tempHeight, G_SCREEN_WIDTH, 50)];
        [self.view addSubview:_bottomView];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH/2, 50)];
        backBtn.backgroundColor = [UIColor whiteColor];
        [backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [backBtn setTitleColor:MainColor forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:backBtn];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2,0, G_SCREEN_WIDTH/2, 50)];
        sureBtn.backgroundColor = MainColor;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sureBtn addTarget:self action:@selector(orderAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:sureBtn];
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_bottomView addSubview:lineView];
        
    }
    return _bottomView;
}

#pragma mark - 返回购物车
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确认
- (void)orderAction
{
    if (_postModel)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(postDeliverModel:)])
        {
            [_delegate postDeliverModel:_postModel];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
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
