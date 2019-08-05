//
//  CartSectionHeaderView.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/24.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "CartSectionHeaderView.h"

#import "Masonry.h"
#import "CYHReducedActivityView.h"

@interface CartSectionHeaderView  ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel* manJIanLabel;
@property (nonatomic, strong) UIButton* checkBtn;

@end

@implementation CartSectionHeaderView

-(UILabel *)manJIanLabel {
    if (!_manJIanLabel) {
        _manJIanLabel = [[UILabel alloc] init];
        _manJIanLabel.text = @"满减";
        _manJIanLabel.textColor = MainColor;
        _manJIanLabel.font = [UIFont systemFontOfSize:11];
        _manJIanLabel.backgroundColor = RGBCOLOR(255, 239, 213);
        _manJIanLabel.textAlignment = NSTextAlignmentCenter;
        _manJIanLabel.layer.masksToBounds = YES;
        _manJIanLabel.layer.cornerRadius = 11;
    }return _manJIanLabel;
}

-(UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"查看本仓满减活动" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:RGBCOLOR(25, 174, 236) forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_checkBtn addTarget:self action:@selector(checkBtn:) forControlEvents:UIControlEventTouchUpInside];
    }return _checkBtn;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 44)];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:12];
        _label.textColor = TitleColor;
        [self addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(45);
            make.height.offset(44);
        }];
        
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 43, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [self addSubview:lineView];
        
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
        [_btn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        [_btn setImage:[UIImage imageNamed:@"no-select"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        
        [self addSubview:self.manJIanLabel];
        [self.manJIanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_label);
            make.left.equalTo(_label.mas_right).offset(12);
            make.width.offset(45);
            make.height.offset(22);
        }];
        
        [self addSubview:self.checkBtn];
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_label);
            make.left.equalTo(self.manJIanLabel.mas_right).offset(10);
            make.height.offset(30);
        }];
        
    }
    return self;
}

-(void)checkBtn:(UIButton *)sender {
    
    NSMutableArray* dataArr = [NSMutableArray new];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    param[@"shopId"] = self.model.shopId;
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/fullOff/list" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        [hud hideAnimated:YES];
        if ([[result[@"code"] stringValue] isEqualToString:@"0"]) {
            NSLog(@"%@",result);
            
            [dataArr addObjectsFromArray:result[@"data"]];
            
            CYHReducedActivityView* showView = [[CYHReducedActivityView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
            showView.dataSource = dataArr;
            showView.superSelf = self.superSelf;
            showView.titleStr = self.model.shopName;
            [showView show];
            
        }
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
    
    
}

- (void)setModel:(CartModel *)model
{
    _model = model;
    _btn.selected = [_model.checked boolValue];
    _label.text = model.shopName;
    
    if (model.shopFullOffs.count > 0) {
        
        self.manJIanLabel.hidden = NO;
        self.checkBtn.hidden = NO;
        
    } else {
        self.manJIanLabel.hidden = YES;
        self.checkBtn.hidden = YES;
    }
    
}


- (void)btnAction
{
    _btn.selected = !_btn.selected;
    
    _model.checked = [NSString stringWithFormat:@"%i",_btn.selected];
    self.block(_model);
}

- (void)handlerButtonAction:(CartModelBlock)block
{
    self.block = block;
}

@end
