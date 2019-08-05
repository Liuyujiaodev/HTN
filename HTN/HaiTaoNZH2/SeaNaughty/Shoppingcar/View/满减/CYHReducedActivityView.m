//
//  CYHReducedActivityView.m
//  SeaNaughty
//
//  Created by Apple on 2019/6/27.
//  Copyright © 2019年 chilezzz. All rights reserved.
//
#define self_ViewH 220
#import "CYHReducedActivityView.h"
#import "CYHReducedTableViewCell.h"

#import "Masonry.h"

#import "CYHManJianViewController.h"

@interface CYHReducedActivityView ()<UITableViewDelegate,UITableViewDataSource>

/** baseTableViewGroup */
@property(nonatomic,strong) UITableView *baseTabeleviewGrouped;
@property(nonatomic,strong) UILabel* shuoLabel;



@property(nonatomic,strong) UIControl * coverView;
//底部白色视图
@property(nonatomic,strong) UIView *whiteView;


@end

@implementation CYHReducedActivityView

-(UIControl *)coverView {
    if (!_coverView) {
        _coverView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        [_coverView addTarget:self action:@selector(removeMain) forControlEvents:UIControlEventTouchUpInside];
        _coverView.userInteractionEnabled = YES;
    }
    return _coverView;
}

-(UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(30, -self_ViewH, G_SCREEN_WIDTH - 60, self_ViewH)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.userInteractionEnabled = YES;
        _whiteView.layer.masksToBounds = YES;
        _whiteView.layer.cornerRadius = 3;
    }
    return _whiteView;
}

-(UITableView *)baseTabeleviewGrouped{
    if (_baseTabeleviewGrouped ==nil) {
        _baseTabeleviewGrouped = [[UITableView alloc]initWithFrame:(CGRect){0,55,G_SCREEN_WIDTH - 60,220 - 55} style:UITableViewStyleGrouped];
        _baseTabeleviewGrouped.delegate = self;
        _baseTabeleviewGrouped.dataSource = self;
        _baseTabeleviewGrouped.showsVerticalScrollIndicator = NO;
        _baseTabeleviewGrouped.backgroundColor = [UIColor whiteColor];
        _baseTabeleviewGrouped.separatorColor = [UIColor whiteColor];
    }
    return _baseTabeleviewGrouped;
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self creatUI];
        
        
        
    }return self;
}

-(void)creatUI
{
    
    [self addSubview:self.coverView];
    [self.coverView addSubview:self.whiteView];
    
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH - 60, 45)];
    headView.backgroundColor = RGBCOLOR(255, 201, 97);
    [self.whiteView addSubview:headView];
    self.shuoLabel = [[UILabel alloc] init];
    self.shuoLabel.text = [NSString stringWithFormat:@"%@满减活动",self.titleStr];
    self.shuoLabel.textColor = [UIColor blackColor];
    self.shuoLabel.font = [UIFont systemFontOfSize:17];
    [headView addSubview:self.shuoLabel];
    [self.shuoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView).offset(15);
        make.centerY.equalTo(headView);
    }];
    
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"del-icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(removeMain) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.offset(40);
        make.top.right.equalTo(headView);
    }];
    
    
    [self.whiteView addSubview:self.baseTabeleviewGrouped];
    
    
    
}

-(void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    
    self.shuoLabel.text = [NSString stringWithFormat:@"%@满减活动",titleStr];
}

-(void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    
    [self.baseTabeleviewGrouped reloadData];
    
}

#pragma mark - tableVew-delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CYHReducedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell%ld",indexPath.section]];
    if (cell==nil) {
        cell = [[CYHReducedTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell%ld",indexPath.section]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld、%@",indexPath.row + 1,self.dataSource[indexPath.row][@"prefixName"]];
    
    cell.checkBtn.tag = indexPath.row + 10;
    [cell.checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)checkBtn:(UIButton *)sender {
    
    CYHManJianViewController* manVC = [[CYHManJianViewController alloc] init];
    manVC.manShoppingDic = self.dataSource[sender.tag - 10];
    [self.superSelf.navigationController pushViewController:manVC animated:YES];
    [self removeMain];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 30;
}

//返回每个区的头部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

//返回每个区的尾部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}



#pragma mark - 显示视图
-(void)show
{
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        CGRect frame = self.whiteView.frame;
        frame.origin.y = 200;
        self.whiteView.frame = frame;
        
        
    }completion:^(BOOL finished){
        
    }];
}

#pragma mark - 隐藏视图
-(void)removeMain
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        
        CGRect frame = self.whiteView.frame;
        frame.origin.y = -self_ViewH;
        self.whiteView.frame = frame;
        
    }completion:^(BOOL finished){
        
        // 如果使用单例就不能置空控件，否则会展现nil的（但在主控制器使用创建对象的形式展现的话，最好要置空控件即nil）
        self.coverView = nil;
        self.whiteView = nil;
        [self removeFromSuperview];
    }];
}

@end
