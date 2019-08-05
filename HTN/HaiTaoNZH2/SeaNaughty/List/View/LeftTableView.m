//
//  LeftTableView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "LeftTableView.h"
#import "CategoryCell.h"
#import "ChildrenModel.h"

@interface LeftTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation LeftTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dataArray = [[NSMutableArray alloc] init];
        [self registerClass:[CategoryCell class] forCellReuseIdentifier:@"CategoryCell"];
        
    }
    return self;
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    CategoryModel *model = _dataArray[indexPath.row];
    
    cell.nameLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.leftTableViewDelegate && [self.leftTableViewDelegate respondsToSelector:@selector(leftTableView:didSelectCategoryName:)])
    {
        [_leftTableViewDelegate leftTableView:self didSelectCategoryName:_dataArray[indexPath.row]];
    }
}

- (void)updateCategories:(CategoryListModel *)list
{
    NSArray *temp = @[@"全球仓库",@"好物推荐",@"特价专区"];
    
    for (int i=0; i<3; i++)
    {
        CategoryModel *model = [[CategoryModel alloc] init];
        model.name = temp[i];
//        model.topImageName = temp[i];
        if (i==0)
        {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:SHOPLIST];
            NSArray *tempArray = dic[@"data"];

            ChildrenModel *model1 = [[ChildrenModel alloc] init];
            model1.name = @"所有仓库";

            NSMutableArray *shopArray = [[NSMutableArray alloc] init];
            [shopArray addObject:model1];
            [shopArray addObjectsFromArray:tempArray];

            NSMutableArray *childrenArray = [[NSMutableArray alloc] init];

            for (int j=0; j<6; j++)
            {
                ChildrenModel *model = [[ChildrenModel alloc] init];
                model.name = shopArray[j];
                [childrenArray addObject:model];
            }

            model.children = (NSArray <ChildrenModel *> *)childrenArray;
        }
        [_dataArray addObject:model];
    }
    
    [_dataArray addObjectsFromArray:list.data];
    
    [self reloadData];
}

- (void)selectedWithName:(NSString *)name
{
    
    for (int i=0; i<_dataArray.count; i++)
    {
        CategoryModel *model = _dataArray[i];
        if ([name isEqualToString:model.name])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftTabelViewModel" object:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self selectRowAtIndexPath:indexPath animated:nil scrollPosition:UITableViewScrollPositionNone];
            
        }
        
    }
    
}



@end
