//
//  AddressViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/11.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "AddressViewController.h"
#import "ProvincesVC.h"
#import "BaseNavigationVC.h"

@interface AddressViewController ()

@property (nonatomic, strong) UIView *btnView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *idCardTextField;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *areaTextField;
@property (nonatomic, strong) UIButton *addressBtn;


@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    [self initUI];
    
}

- (void)initUI
{
    self.view.backgroundColor = LineColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, G_STATUSBAR_HEIGHT+44, G_SCREEN_WIDTH, 250)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    NSArray *array = @[@"收货人",@"手机号",@"身份证号码(选填，直邮奶粉必填)",@"省、市、区/县",@"详细地址，如街道、楼盘号等"];
    for (int i=0; i<5; i++)
    {
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, i*50, G_SCREEN_WIDTH-30, 50)];
        textField.placeholder = array[i];
        textField.textColor = TextColor;
        textField.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:textField];
        textField.tag = 100+i;
        
        textField.enabled = YES;
        if (i == 3)
        {
            _addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 150, G_SCREEN_WIDTH-30, 50)];
            [_addressBtn setTitleColor:TextColor forState:UIControlStateNormal];
//            [_addressBtn setTitle:array[3] forState:UIControlStateNormal];
            _addressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [_addressBtn addTarget:self action:@selector(addressBtnAction) forControlEvents:UIControlEventTouchUpInside];
            _addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [bgView addSubview:_addressBtn];
            textField.enabled = NO;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, i*50-1, G_SCREEN_WIDTH-30, 1)];
        lineView.backgroundColor = LineColor;
        if (i!=0)
        {
            [bgView addSubview:lineView];
        }
    }
    
    [self.view addSubview:self.btnView];
    
    _nameTextField = [bgView viewWithTag:100];
    _phoneTextField = [bgView viewWithTag:101];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _idCardTextField = [bgView viewWithTag:102];
    _idCardTextField.keyboardType = UIKeyboardTypePhonePad;
    _areaTextField = [bgView viewWithTag:103];
    _addressTextField = [bgView viewWithTag:104];
    
    if (_model.commonID)
    {
        _nameTextField.text = _model.receiveName;
        _phoneTextField.text = _model.receivePhone;
        _idCardTextField.text = _model.receiveIdCard;
        _addressTextField.text = _model.receiveAddress;
//        [_addressBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@", _model.receiveProvince, _model.receiveCity, _model.receiveArea] forState:UIControlStateNormal];
        
        if (_model.receiveProvince.length > 0)
        {
            _areaTextField.text = [NSString stringWithFormat:@"%@ %@ %@", _model.receiveProvince, _model.receiveCity, _model.receiveArea];
        }
        
        
    }
}

- (void)setModel:(CommonModel *)model
{
    _model = model;
}


- (UIView *)btnView
{
    if (!_btnView)
    {
        _btnView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-48, G_SCREEN_WIDTH, 48)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        lineView.backgroundColor = LineColor;
        [_btnView addSubview:lineView];
        
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 1, G_SCREEN_WIDTH/2, 47)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:MainColor forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.backgroundColor = [UIColor whiteColor];
        [_btnView addSubview:cancleBtn];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2, 1, G_SCREEN_WIDTH/2, 47)];
        [sureBtn setTitle:@"保存" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.backgroundColor = MainColor;
        [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_btnView addSubview:sureBtn];
        
    }
    return _btnView;
}

#pragma mark - 取消
- (void)cancleAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确定
- (void)sureAction
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@"" forKey:@""];
    
    if (_nameTextField.text.length>0)
    {
        [param setObject:_nameTextField.text forKey:@"receiveName"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人姓名"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    
    if ([self judgePhoneStringValid:_phoneTextField.text])
    {
        [param setObject:_phoneTextField.text forKey:@"receivePhone"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    
    if (_idCardTextField.text.length > 0)
    {
        if ([self judgeIdentityStringValid:_idCardTextField.text])
        {
            [param setObject:_idCardTextField.text forKey:@"receiveIdCard"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
    }
    
   
    
    if (_addressTextField.text > 0)
    {
        [param setObject:_addressTextField.text forKey:@"receiveAddress"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的收货地址"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    
    if (_areaTextField.text.length > 0)
    {
        NSArray *array = [_areaTextField.text componentsSeparatedByString:@" "];
        NSString *province = array[0] ? array[0] : @"";
        NSString *city = array[1] ? array[1] : @"";
        NSString *area = array[2] ? array[2] : @"";
        
        [param setObject:province forKey:@"receiveProvince"];
        [param setObject:city forKey:@"receiveCity"];
        [param setObject:area forKey:@"receiveArea"];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"请输入省市区/县"];
        [SVProgressHUD dismissWithDelay:1.5];
        return;
    }
    NSString *status = @"添加成功!";
    if (_model.commonID)
    {
        [param setObject:_model.commonID forKey:@"receiveId"];
        status = @"修改成功!";
    }
    
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    MBProgressHUD *loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadingHud.mode = MBProgressHUDModeIndeterminate;
    [loadingHud showAnimated:YES];
    
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/saveReceiveInfo" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [loadingHud hideAnimated:YES];
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            [SVProgressHUD showSuccessWithStatus:status];
            [SVProgressHUD dismissWithDelay:1.1];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:result[@"message"]];
            [SVProgressHUD dismissWithDelay:1.1];
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)addressBtnAction
{
    ProvincesVC *vc = [[ProvincesVC alloc] init];
    BaseNavigationVC *nvc = [[BaseNavigationVC alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *area = [[NSUserDefaults standardUserDefaults] valueForKey:@"AREA"];
    
    if (area.length>0)
    {
        _areaTextField.text = area;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"AREA"];
}


- (BOOL)judgePhoneStringValid:(NSString *)phoneString
{
    NSString *regex = @"^((1[3456789][0-9]))\\d{8}$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [identityStringPredicate evaluateWithObject:phoneString];
}

- (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
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
