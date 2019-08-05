//
//  CityVC.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/29.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CityVC.h"
#import "NewAddressCell.h"
#import "CountryVC.h"

@interface CityVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"";
    
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
    CountryVC *vc = [[CountryVC alloc] init];
    vc.cityId = model.commonID;
    vc.cityName = model.areaName;
    vc.provinceName = self.provinceName;
    
    if ([_provinceId isEqualToString:@"820000"])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSString *area = [NSString stringWithFormat:@"%@ %@ ", self.provinceName, model.areaName];
        
        [[NSUserDefaults standardUserDefaults] setObject:area forKey:@"AREA"];
    }
    else
    {
        [self.navigationController pushViewController:vc animated:YES];
    }
    
   
}

- (void)getProvince
{
    MJWeakSelf;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/area/cities" parameters:@{@"provinceId":_provinceId} success:^(NSURLSessionDataTask *task, id result) {
        
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
