//
//  AddressManagerViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "AddressManagerViewController.h"
#import "CommonModelList.h"
#import "AddressViewController.h"

@interface AddressManagerViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *searchTextField;
@end

@implementation AddressManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    MJWeakSelf;
    self.view.backgroundColor = LineColor;
//    [self getAddressWithPage:_page];
    
    
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-50) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = LineColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    if (_searchArray.count==0)
    {
        _tableView.tableHeaderView = self.headerView;
    }
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isRefresh = YES;
        weakSelf.page = 1;
        [weakSelf getAddressWithPage:weakSelf.page];
    }];
    
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isRefresh = NO;
        weakSelf.page++;
        [weakSelf getAddressWithPage:weakSelf.page];
    }];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-50, G_SCREEN_WIDTH, 50)];
    addBtn.backgroundColor = MainColor;
    [addBtn setTitle:@"新增地址" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addBtn addTarget:self action:@selector(addAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
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
    
    
    return nameHeight+addressHeight+70;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        [cell.contentView addSubview:lineView];
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-120, 70, 50, 20)];
        [editBtn setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        editBtn.imageEdgeInsets = UIEdgeInsetsMake(4, -2, 4, 8);
        [editBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        editBtn.tag = 600+indexPath.section;
        [editBtn addTarget:self action:@selector(editbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:editBtn];
        
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-60, 70, 50, 20)];
        [delBtn setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        delBtn.imageEdgeInsets = UIEdgeInsetsMake(4, -2, 4, 8);
        [delBtn setTitleColor:LightGrayColor forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        delBtn.tag = 700+indexPath.section;
        [delBtn addTarget:self action:@selector(delbtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:delBtn];
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
        
        NSString *phone = @"";
       
        if (model.receivePhone)
        {
            phone = model.receivePhone;
            for (int i=0; i<3; i++)
            {
                if (i+4<phone.length)
                {
                    phone = [phone stringByReplacingCharactersInRange:NSMakeRange(4+i, 1) withString:@"*"];
                }
                else
                {
                    i=2;
                }
            }
        }
        
        
        NSString *idCard = @"";
        if (model.receiveIdCard)
        {
            idCard = model.receiveIdCard;
            for (int i=0; i<4; i++)
            {
                if (i+4<idCard.length)
                {
                    idCard = [idCard stringByReplacingCharactersInRange:NSMakeRange(4+i, 1) withString:@"*"];
                }
                else
                {
                    i=3;
                }
            }
        }
        
        NSString *newString = [NSString stringWithFormat:@"%@    %@    %@", model.receiveName, phone, idCard];
        
        CGFloat nameHeight = [self calculateContentWithText:newString size:CGSizeMake(G_SCREEN_WIDTH-30, 1000) font:14].size.height;
        
        UILabel *nameLabel = [cell.contentView viewWithTag:100+indexPath.section];
        nameLabel.text = newString;
        nameLabel.frame = CGRectMake(15, 12, G_SCREEN_WIDTH-30, nameHeight);
        
        NSString *addressString = @"";
        if (model.receiveProvince)
        {
            addressString = [NSString stringWithFormat:@"%@ %@ %@ %@", model.receiveProvince, model.receiveCity, model.receiveArea, model.receiveAddress];
        }
        else
        {
            addressString = model.receiveAddress;
        }
        
        UILabel *addressLabel = [cell.contentView viewWithTag:400+indexPath.section];
       
        CGFloat addressHeight = [self calculateContentWithText:addressString size:CGSizeMake(G_SCREEN_WIDTH-30, 1000) font:13].size.height;
    
        addressLabel.text = addressString;
        addressLabel.frame = CGRectMake(15, nameHeight+20, G_SCREEN_WIDTH-30, addressHeight);
        
        UIView *lineView = [cell.contentView viewWithTag:500+indexPath.section];
        lineView.frame = CGRectMake(15, nameHeight+30+addressHeight, G_SCREEN_WIDTH-30, 1);
        
        UIButton *editBtn = [cell.contentView viewWithTag:600+indexPath.section];
        UIButton *delBtn = [cell.contentView viewWithTag:700+indexPath.section];
        
        editBtn.frame = CGRectMake(G_SCREEN_WIDTH-120, nameHeight+40+addressHeight, 50, 20);
        delBtn.frame = CGRectMake(G_SCREEN_WIDTH-60, nameHeight+40+addressHeight, 50, 20);
        
    }
    
    return cell;
}

- (void)editbtnAction:(UIButton *)btn
{
    CommonModel *model;
    if (_searchArray.count > 0)
    {
        model = _searchArray[btn.tag-600];
    }
    else
    {
        model = _dataArray[btn.tag-600];
    }
    AddressViewController *vc = [[AddressViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)delbtnAction:(UIButton *)btn
{
    CommonModel *model;
    if (_searchArray.count > 0)
    {
        model = _searchArray[btn.tag-700];
    }
    else
    {
        model = _dataArray[btn.tag-700];
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:model.commonID forKey:@"receiveId"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/delReceiveInfo" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [SVProgressHUD dismissWithDelay:1.1];
        _page = 1;
        [self getAddressWithPage:1];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 获取地址列表数据
- (void)getAddressWithPage:(int)page
{
    _page = page;
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSString stringWithFormat:@"%i",_page] forKey:@"pageNumber"];
    [param setObject:@"1000" forKey:@"pageSize"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    __weak typeof(self) weakSelf = self;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/receiveInfoList" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        if (page==1)
        {
            [_dataArray removeAllObjects];
        }
        [loadingHud hideAnimated:YES];
        CommonModelList *list = [CommonModelList yy_modelWithDictionary:result[@"data"]];

//        NSDictionary *dataDic = dic[@"data"];
        NSArray *array = list.rows;
        
        if (array.count>0)
        {
            if (weakSelf.isRefresh)
            {
                [weakSelf.tableView.mj_header endRefreshing];
            }
            else
            {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.dataArray addObjectsFromArray:array];
            
            [weakSelf.tableView reloadData];
        }
        else
        {
            if (weakSelf.page == 1)
            {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView reloadData];
            }
            
            
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
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

- (void)addAddressAction
{
    AddressViewController *vc = [[AddressViewController alloc] init];
    vc.model = [[CommonModel alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    NSLog(@"点击了搜索");
    
    return YES;
    
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
        
        [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/receiveInfoList" parameters:param success:^(NSURLSessionDataTask *task, id result) {
            
            CommonModelList *list = [CommonModelList yy_modelWithDictionary:result[@"data"]];
            //        NSDictionary *dataDic = dic[@"data"];
            NSArray *array = list.rows;
            
            if (array.count>0)
            {
                AddressManagerViewController *vc = [[AddressManagerViewController alloc] init];
                vc.searchArray = array;
                weakSelf.keyWord = weakSelf.searchTextField.text;
                [weakSelf.navigationController pushViewController:vc animated:YES];
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
