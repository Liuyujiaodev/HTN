//
//  ProvincesVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/29.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ProvincesVC.h"
#import "NewAddressCell.h"
#import "CityVC.h"

@interface ProvincesVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ProvincesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"省";
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:G_SCREEN_BOUNDS style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[NewAddressCell class] forCellReuseIdentifier:@"NewAddressCell"];
    [self.view addSubview:_tableView];
    
    [self getProvince];
    
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewAddressCell" forIndexPath:indexPath];
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonModel *model = _dataArray[indexPath.row];
    CityVC *vc = [[CityVC alloc] init];
    vc.provinceId = model.commonID;
    vc.provinceName = model.areaName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getProvince
{
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/area/provinces" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        CommonModelList *list = [CommonModelList yy_modelWithDictionary:result];
        weakSelf.dataArray = [[NSMutableArray alloc] initWithArray:list.data];
        [weakSelf.tableView reloadData];
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
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
