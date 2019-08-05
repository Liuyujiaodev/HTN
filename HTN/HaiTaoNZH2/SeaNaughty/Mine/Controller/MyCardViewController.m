//
//  MyCardViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "MyCardViewController.h"
#import "ZFConst.h"
#import <Masonry.h>

@interface MyCardViewController ()

@end

@implementation MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的会员卡";
    self.view.backgroundColor = MainColor;
    [self initUI];
}

- (void)initUI
{
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, G_STATUSBAR_HEIGHT, G_SCREEN_WIDTH-200, 44)];
//    titleLabel.text = @"我的会员卡";
    
    
    UILabel *topView = [[UILabel alloc] initWithFrame:CGRectMake(10, G_STATUSBAR_HEIGHT+54, G_SCREEN_WIDTH-20, 60)];
    topView.text = [NSString stringWithFormat:@"      %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"fullName"]];
    topView.backgroundColor = [UIColor colorFromHexString:@"#F4F4F4"];
    topView.textColor = MainColor;
    topView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:topView];
    
    UIImageView *codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, G_STATUSBAR_HEIGHT+114, G_SCREEN_WIDTH-20, G_SCREEN_WIDTH-20)];
    codeImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:codeImageView];
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    [codeImageView addSubview:imageView1];
    
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@9);
        make.right.equalTo(codeImageView.mas_right).offset(-9);
        make.height.equalTo(@100);
        make.top.equalTo(@30);
    }];
    
    imageView1.image = [UIImage imageForCodeString:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] size:(G_SCREEN_WIDTH-18) color:ZFSkyBlue pattern:kCodePatternForBarCode];
    
    
    UIImageView * imageView = [[UIImageView alloc] init];
    [codeImageView addSubview:imageView];
    CGFloat width = G_SCREEN_WIDTH-210;
    //条形码：kCodePatternForBarCode 二维码：kCodePatternForQRCode
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView1.mas_bottom).offset(30);
        make.centerX.equalTo(codeImageView);
        make.width.height.mas_equalTo(width);
    }];
    
    imageView.image = [UIImage imageForCodeString:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] size:width color:ZFSkyBlue pattern:kCodePatternForQRCode];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationController.navigationBar.subviews[0].subviews[1].hidden = YES;
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
