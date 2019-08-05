//
//  ShopListViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/3.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopListCell.h"
#import "ShopListModel.h"
@interface ShopListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"线下店铺";
    
    _dataArray = [[NSMutableArray alloc] init];

    [self getShopList];
    
    _tableView = [[UITableView alloc] initWithFrame:G_SCREEN_BOUNDS style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 130;
    _tableView.sectionHeaderHeight = 0.01;
    _tableView.estimatedSectionHeaderHeight = 0.01;
    _tableView.sectionFooterHeight = 11;
    _tableView.estimatedSectionFooterHeight = 11;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[ShopListCell class] forCellReuseIdentifier:@"ShopListCell"];
    [self.view addSubview:_tableView];
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
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
    ShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListCell" forIndexPath:indexPath];
    
//    cell.shopListDic = dic;
//
//    if (indexPath.section==6)
//    {
//        cell.bgView.frame = CGRectMake(15, 45, G_SCREEN_WIDTH-30, 40);
//        cell.imageView1.hidden = YES;
//        cell.imageView3.hidden = YES;
//        cell.addressLabel.frame = CGRectMake(30, 10, G_SCREEN_WIDTH-60, 20);
//        cell.imageView2.frame = CGRectMake(10, 10, 15, 15);
//    }
//    else
//    {
//        cell.bgView.frame = CGRectMake(15, 50, G_SCREEN_WIDTH-30, 95);
//        cell.imageView1.hidden = NO;
//        cell.imageView3.hidden = NO;
//        cell.addressLabel.frame = CGRectMake(30, 35, G_SCREEN_WIDTH-60, 25);
//        cell.imageView2.frame = CGRectMake(10, 40, 15, 15);
//    }
//
    if (_dataArray.count > 0)
    {
        cell.model = _dataArray[indexPath.section];
    }
    
    return cell;
}


- (void)getShopList
{
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/companies/warehouseInfo" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            ShopListModel *model = [ShopListModel yy_modelWithDictionary:result];
            
            if (model.data.count > 0)
            {
                [_dataArray addObjectsFromArray:model.data];
            }
            
            [_tableView reloadData];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    if (self.isFromMessage)
//    {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}




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
