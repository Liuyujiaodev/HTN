//
//  RightTableView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/8/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "RightTableView.h"
#import "ListChildrenView.h"
#import "RankBtnView.h"
#import "RightCell.h"

@interface RightTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, assign) BOOL hasImage;

@property (nonatomic, strong) ListChildrenView *listChildrenView;

@property (nonatomic, strong) RankBtnView *rankBtn;


@end

@implementation RightTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/3+20)];
        topView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width-30, self.frame.size.width/3-10)];
        imageView.image = [UIImage imageNamed:@"全球仓库"];
        [topView addSubview:imageView];
        self.tableHeaderView = topView;
        [self registerClass:[RightCell class] forCellReuseIdentifier:@"RightCell"];
    }
    return self;
}

#pragma mark - Tableview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat width = self.frame.size.width;
    
    _rankBtn = [[RankBtnView alloc] initWithFrame:CGRectMake(0, 0, width, 40)];
    _rankBtn.backgroundColor = [UIColor whiteColor];
    _rankBtn.showTopline = YES;
    return _rankBtn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell" forIndexPath:indexPath];
    
//    cell.data = 
    return cell;
}




- (void)setCategory:(CategoryModel *)category
{
    _category = category;

    NSLog(@"backImg = %@",_category.backImg);
    NSArray *array = @[@"好物推荐",@"特价专区",@"全球仓库"];

    self.listChildrenView.model = _category;
    
    if ([array containsObject:_category.name])
    {
        self.hasImage = YES;
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width/3+10)];
        topView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width-30, self.frame.size.width/3-10)];
        imageView.image = [UIImage imageNamed:_category.name];
        [topView addSubview:imageView];
        
        if ([_category.name isEqualToString:@"全球仓库"])
        {
            
        }
        
        self.tableHeaderView = topView;
    }
    else
    {
        if (_category.children.count>0)
        {
            self.tableHeaderView = self.listChildrenView;
        }
        else
        {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
            header.backgroundColor = [UIColor yellowColor];
            self.tableHeaderView = header;
        }
        self.hasImage = NO;
    }
    
    [self reloadData];
}






- (ListChildrenView *)listChildrenView
{
    if (!_listChildrenView)
    {
        _listChildrenView = [[ListChildrenView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH-80, 100) dataArray:nil];
    }
    return _listChildrenView;
}



@end
