//
//  PayViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/9/28.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "PayViewController.h"
#import "BankListModel.h"
#import "OffLineCell.h"
#import "AlertCell.h"
#import "PayMoneyCell.h"
#import "OnLineCell.h"
#import "IPNCrossBorderPluginDelegate.h"
#import "IPNCrossBorderPreSignUtil.h"
#import "IPNCrossBorderPluginAPi.h"
#import "IPNDESUtil.h"
#import "AppPayModel.h"
#import <Masonry.h>
#import "RDCountDownButton.h"
#import "AppDelegate.h"
#import "ShoppingCarViewController.h"
#import "OrderListViewController.h"

@interface PayViewController () <UITableViewDelegate, UITableViewDataSource, OffLineCellDelegate, OnLineCellDelegate, IPNCrossBorderPluginDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat tempHeight;
@property (nonatomic, strong) NSMutableArray *bankArray;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) NSString *codeString;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) RDCountDownButton *codeBtn;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收银台";
//    _firstTotalAmount = @"123845.2";
    _bankArray = [[NSMutableArray alloc] init];
    _codeString = @"";
    _payType = @"wechat";
//
    [self getWalletInfo];
    
//    [self.view addSubview:self.codeView];
    [self calcAmount];
    
    [self getBank];
}

- (void)backBtnClick
{
    if (self.isFromShop)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initUI
{
    _tempHeight = 0;
    if (G_STATUSBAR_HEIGHT > 20)
    {
        _tempHeight = 20;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT-50-_tempHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = LineColor;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[OffLineCell class] forCellReuseIdentifier:@"OffLineCell"];
    [_tableView registerClass:[AlertCell class] forCellReuseIdentifier:@"AlertCell"];
    [_tableView registerClass:[PayMoneyCell class] forCellReuseIdentifier:@"PayMoneyCell"];
    [_tableView registerClass:[OnLineCell class] forCellReuseIdentifier:@"OnLineCell"];
    
//    NSArray *orders = @[@"WWR201808271450414566",@"QQR201808271450414577",@"JBR201808271450414588"];
    NSString *temp = [_ordersArray componentsJoinedByString:@","];
    
    NSString *orderString = [NSString stringWithFormat:@"订单号：%@, 请尽快完成支付以便我们为您安排发货哦~",temp];
    
    CGFloat height = [orderString boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-30, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height+10;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 50+height)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#FFFDF3"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 10, 20, 20)];
    imageView.image = [UIImage imageNamed:@"笑脸"];
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, G_SCREEN_WIDTH-55, 50)];
    label.numberOfLines = 0;
    label.textColor = TitleColor;
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"感谢您在本店购物，您的订单已提交成功！";
    [headerView addSubview:label];
    
    UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, G_SCREEN_WIDTH, height)];
    botView.backgroundColor = [UIColor whiteColor];
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, height)];
    orderLabel.font = [UIFont systemFontOfSize:11];
    orderLabel.textColor = TextColor;
    orderLabel.numberOfLines = 0;
    orderLabel.lineBreakMode = NSLineBreakByCharWrapping;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:orderString];
    [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(4, temp.length)];
    orderLabel.attributedText = str;
    [botView addSubview:orderLabel];
    [headerView addSubview:botView];
    
    _tableView.tableHeaderView = headerView;
    
    _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-50-_tempHeight, G_SCREEN_WIDTH, 50)];
    _payBtn.backgroundColor = MainColor;
    [_payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payBtn];
    
}



#pragma mark - Tableview Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return _bankArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }
    else if (indexPath.section == 1)
    {
        return 180;
    }
    else if (indexPath.section == 2)
    {
        if (_bankArray.count>0)
        {
            BankModel *model = _bankArray[indexPath.row];
            CGFloat height = [model.remark boundingRectWithSize:CGSizeMake(G_SCREEN_WIDTH-40, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size.height+2+130;
            return height;
        }
        return 180;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
    {
        return 8;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        return 40;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        NSArray *array = @[@"在线支付",@"线下支付"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, G_SCREEN_WIDTH-30, 40)];
        label.textColor = TextColor;
        label.text = array[section-1];
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        return view;
    }
    else
    {
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PayMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayMoneyCell" forIndexPath:indexPath];
        
        if (_dataDic.allKeys>0)
        {
            NSString *str1 = [[_dataDic valueForKey:@"firstTotalAmount"] stringValue];
            if (str1.length > 8)
            {
                float price = [str1 floatValue];
                NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber *ouncesDecimal;
                NSDecimalNumber *roundedOunces;
                
                ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
                roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
                
                str1 = [NSString stringWithFormat:@"%@",roundedOunces];
            }
            
            NSString *str2 = [[_dataDic valueForKey:@"secondTotalAmount"] stringValue];
            
            if (str2.length > 8)
            {
                float price = [str2 floatValue];
                NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
                NSDecimalNumber *ouncesDecimal;
                NSDecimalNumber *roundedOunces;
                
                ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
                roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
                
                str2 = [NSString stringWithFormat:@"%@",roundedOunces];
            }
            
            cell.totalFee = [NSString stringWithFormat:@"%@ %@/%@ %@", _dataDic[@"firstCurrencyName"], str1,_dataDic[@"secondCurrencyName"],str2];
        }
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        OnLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OnLineCell" forIndexPath:indexPath];
        cell.delegate = self;
        
        if (_dataDic.allKeys > 0)
        {
//            cell.walletSum = [_dataDic[@"walletSum"][@"totalAmount"] stringValue];
            cell.walletSum = [NSString stringWithFormat:@"%@%@",[_dataDic[@"walletSum"][@"totalAmount"] stringValue], _dataDic[@"walletSum"][@"currencyName"]];
            if ([_dataDic[@"isWalletEnough"] intValue] == YES)
            {
                cell.showAlert = NO;
            }
            else
                cell.showAlert = YES;
        }
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        OffLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OffLineCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = _bankArray[indexPath.row];
        return cell;
    }
    else
    {
        AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell" forIndexPath:indexPath];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)onLineCellSelectedIndex:(NSInteger)index
{
    for (BankModel *model in _bankArray)
    {
         model.checked = 0;
    }
    
    if (index == 1)
    {
        _payType = @"wechat";
    }
    else if (index == 2)
    {
        _payType = @"余额";
    }
    else if (index == 3)
    {
        _payType = @"alipay";
    }
    
    self.bottomView.hidden = YES;
    self.payBtn.hidden = NO;
    
    [_tableView reloadData];
}

- (void)offLineSelected:(BankModel *)bankModel
{
    for (BankModel *model in _bankArray)
    {

        if (model != bankModel)
        {
            model.checked = 0;
        }
    }

    OnLineCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.selectIndex = 0;


    self.bottomView.hidden = NO;
    self.payBtn.hidden = YES;
    
    [_tableView reloadData];
}


- (void)getBank
{
    MJWeakSelf;
    
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/v3/bank" parameters:nil success:^(NSURLSessionDataTask *task, id result) {
        
        BankListModel *list = [BankListModel yy_modelWithDictionary:result];
        
        weakSelf.bankArray = [[NSMutableArray alloc] initWithArray:list.data];
        
        for (BankModel *model in weakSelf.bankArray)
        {
            model.checked = 0;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



- (void)payAction
{
    
    if ([_payType isEqualToString:@"余额"])
    {
        [self sendPayCode];
    }
    else
    {
        [self getAppPay:_payType];
    }
    
}



#pragma mark - 微信支付
- (void)getAppPay:(NSString *)payType
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:_payType forKey:@"channel"];
    [param setObject:_idArray forKey:@"orderIds"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:@"mobile" forKey:@"deviceType"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/appPay" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        [hud hideAnimated:YES];
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            AppPayModel *model = [AppPayModel yy_modelWithDictionary:result[@"data"]];
            IPNCrossBorderPreSignUtil *preSign = [[IPNCrossBorderPreSignUtil alloc] init];
            preSign.appId=model.appId;
            preSign.payChannelType=model.payChannelType;
            preSign.mhtOrderNo=model.mhtOrderNo;
            preSign.mhtOrderName=model.mhtOrderName;
            preSign.mhtOrderType=model.mhtOrderType;
            preSign.mhtCurrencyType=model.mhtCurrencyType;
            preSign.mhtOrderAmt=model.mhtOrderAmt;
            preSign.mhtOrderDetail=model.mhtOrderDetail;
            preSign.mhtOrderStartTime=model.mhtOrderStartTime;
            preSign.notifyUrl=model.notifyUrl;
            preSign.mhtCharset=model.mhtCharset;
            preSign.mhtOrderTimeOut=model.mhtOrderTimeOut;
            preSign.mhtAmtCurrFlag =model.mhtAmtCurrFlag;
            preSign.mhtReserved = model.mhtReserved;

            
            [IPNCrossBorderPluginAPi pay:model.str AndScheme:@"IPaynowCrossBorderGatherPluginDemo" viewController:self delegate:self];
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud1.mode = MBProgressHUDModeText;
                hud1.detailsLabel.text = result[@"message"];
                [hud1 hideAnimated:YES afterDelay:1.2];
            });
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        [hud hideAnimated:YES];
    }];
    
    
}


/**
 *   订单签名该由服务器完成，此处本地签名仅作为展示使用。
 */
//- (void)payByLocalSign{
//    NSString *md5 = [IPNDESUtil md5Encrypt:_appKey.text];
//    md5 = [_presignStr stringByAppendingFormat:@"&%@",md5];
//    md5 = [IPNDESUtil md5Encrypt:md5];
//    md5 = [NSString stringWithFormat:@"mhtSignType=MD5&mhtSignature=%@",md5];
//    NSString *payData = [_originalString stringByAppendingFormat:@"&%@",md5];
//    [IPNCrossBorderPluginAPi pay:payData AndScheme:@"IPaynowCrossBorderGatherPluginDemo" viewController:self delegate:self];
//
//}

#pragma mark - SDK的回调方法
- (void)iPNCrossBorderPluginResult:(IPNCrossBorderPayResult)result erroCode:(NSString *)erroCode erroInfo:(NSString *)erroInfo{
    
    NSString *resultString = @"";
    switch (result) {
        case IPNCrossBorderPayResultFail:
            resultString = [NSString stringWithFormat:@"支付失败:\r\n错误码:%@,异常信息:%@",erroCode, erroInfo];
            break;
        case IPNCrossBorderPayResultCancel:
            resultString = @"支付被取消";
            break;
        case IPNCrossBorderPayResultSuccess:
            resultString = @"支付成功";
            break;
        case  IPNCrossBorderPayResultUnknown:
            resultString = [NSString stringWithFormat:@"支付结果未知:%@",erroInfo];
        default:
            break;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
    if (result == IPNCrossBorderPayResultSuccess)
    {
//        [self.navigationController popToRootViewControllerAnimated:YES];
        OrderListViewController *vc = [[OrderListViewController alloc] init];
        vc.fromPay = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 获取付款信息
- (void)calcAmount
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud showAnimated:YES];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:self.idArray forKey:@"orderIds"];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    MJWeakSelf;
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/calc-amount" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        [hud hideAnimated:YES];
       
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            weakSelf.dataDic = result[@"data"];
            
            weakSelf.firstTotalAmount = weakSelf.dataDic[@"firstTotalAmount"];
            weakSelf.secondTotalAmount = weakSelf.dataDic[@"secondTotalAmount"];
            
            weakSelf.ordersArray = weakSelf.dataDic[@"orderNumbers"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf initUI];
                [weakSelf.tableView reloadData];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
            [SVProgressHUD dismissWithDelay:1.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}


#pragma mark - 获取余额
- (void)getWalletInfo
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:@"1" forKey:@"pageNumber"];
    [param setObject:@"10" forKey:@"pageSize"];
    
    MJWeakSelf;
    [AppService requestHTTPMethod:@"get" URL:@"/webapi/customer/getWalletInfo" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
      
        dispatch_async(dispatch_get_main_queue(), ^{
            
            OnLineCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            
            cell.walletSum = result[@"data"][@"walletSum"];
           
            float totalMoney = [weakSelf.firstTotalAmount floatValue];
            if (![cell.walletSum containsString:@"纽币"])
            {
                totalMoney = [weakSelf.secondTotalAmount floatValue];
            }
            
            NSString *pureNumbers = [[cell.walletSum componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
            
            if ([pureNumbers floatValue] < totalMoney)
            {
                cell.showAlert = YES;
            }
            
            
            [weakSelf.tableView reloadData];
            
        });
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)sendPayCode
{
    MJWeakSelf;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/customer/sendPayCode" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
            NSDictionary *temp = result[@"data"];
            
            if ([[temp[@"status"] stringValue] isEqualToString:@"0"])
            {
//                验证码
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.phoneLabel.text = [NSString stringWithFormat:@"为了您的支付安全，系统已向您绑定的手机号%@发送支付验证码，请输入已完成支付！", temp[@"phone"]];
                    [weakSelf.view addSubview:weakSelf.codeView];
                    weakSelf.codeBtn.enabled = NO;
                    [weakSelf.codeBtn startCountDownWithSecond:60];
                    [weakSelf.codeBtn setTitleColor:MainColor forState:UIControlStateNormal];
                    [weakSelf.codeBtn countDownChanging:^NSString *(RDCountDownButton *countDownButton,NSUInteger second) {
                        NSString *title = [NSString stringWithFormat:@"%zds重新获取",second];
                        return title;
                    }];
                    [weakSelf.codeBtn countDownFinished:^NSString *(RDCountDownButton *countDownButton, NSUInteger second) {
                        weakSelf.codeBtn.enabled = YES;
                        [weakSelf.codeBtn setTitleColor:TextColor forState:UIControlStateNormal];
                        return @"获取验证码";
                        
                    }];
                    
                    
                });
                
            }
            else if ([[temp[@"status"] stringValue] isEqualToString:@"1"])
            {
                [weakSelf payByWallet];
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                [SVProgressHUD dismissWithDelay:1.2];
                
            });
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 余额支付
- (void)payByWallet
{
    MJWeakSelf;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"customerId"] forKey:@"customerId"];
    [param setObject:self.idArray forKey:@"orderIds"];
    if (_codeTextField.text.length > 0)
    {
        [param setObject:_codeTextField.text forKey:@"code"];
    }
    
    
    [AppService requestHTTPMethod:@"post" URL:@"/webapi/v3/orders/pay-by-wallet" parameters:param success:^(NSURLSessionDataTask *task, id result) {
        
        
        if ([[result[@"code"] stringValue] isEqualToString:@"0"])
        {
//            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            OrderListViewController *vc = [[OrderListViewController alloc] init];
            vc.fromPay = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.detailsLabel.text = result[@"message"];
                _codeTextField.text = @"";
                [hud hideAnimated:YES afterDelay:1.2];
            });
        }
        
    } fail:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (UIView *)codeView
{
    if (!_codeView)
    {
        _codeView = [[UIView alloc] initWithFrame:G_SCREEN_BOUNDS];
        MJWeakSelf;
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:G_SCREEN_BOUNDS];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_codeView addSubview:bgView];
        
        UIView *bg2View = [[UIView alloc] init];
        bg2View.backgroundColor = [UIColor whiteColor];
        [_codeView addSubview:bg2View];
        [bg2View makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(@35);
            make.right.mas_equalTo(weakSelf.codeView).mas_offset(@-35);
            make.center.mas_equalTo(weakSelf.codeView);
            make.height.mas_equalTo(@220);
        }];
        
        UILabel *topView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH-70, 44)];
        topView.backgroundColor = [UIColor colorFromHexString:@"#FFFDF0"];
        topView.font = [UIFont systemFontOfSize:12];
        topView.textAlignment = NSTextAlignmentCenter;
        [bg2View addSubview:topView];
        
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"笑脸"];
        attachment.bounds = CGRectMake(0, -5, 20, 20);
        NSAttributedString *image = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"   如有问题，请联系公众号客服"];
        [str insertAttributedString:image atIndex:0];
        topView.attributedText = str;
        bg2View.layer.cornerRadius = 5;
        bg2View.layer.masksToBounds = YES;
        [bg2View addSubview:self.phoneLabel];
        
        _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, G_SCREEN_WIDTH-220, 20)];
        _codeTextField.placeholder = @"输入短信验证码(必填)";
        _codeTextField.textColor = TextColor;
        _codeTextField.font = [UIFont systemFontOfSize:11];
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        [bg2View addSubview:_codeTextField];
        
        _codeBtn = [[RDCountDownButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH-150, 130, 75, 20)];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor colorFromHexString:@"#CECECE"] forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_codeBtn addTarget:self action:@selector(sendPayCode) forControlEvents:UIControlEventTouchUpInside];
//        _codeBtn.hidden = YES;
        [bg2View addSubview:_codeBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 150, G_SCREEN_WIDTH-110, 1)];
        lineView.backgroundColor = LineColor;
        [bg2View addSubview:lineView];
        
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 179, G_SCREEN_WIDTH-70, 1)];
        lineView1.backgroundColor = LineColor;
        [bg2View addSubview:lineView1];
        
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 180, G_SCREEN_WIDTH/2-35, 40)];
        [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftBtn setTitleColor:MainColor forState:UIControlStateNormal];
        leftBtn.backgroundColor = [UIColor whiteColor];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [bg2View addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(G_SCREEN_WIDTH/2-35, 180, G_SCREEN_WIDTH/2-35, 40)];
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.backgroundColor = MainColor;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [bg2View addSubview:rightBtn];
        [rightBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _codeView;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel)
    {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 56, G_SCREEN_WIDTH-110, 50)];
        _phoneLabel.numberOfLines = 0;
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        _phoneLabel.textColor = TitleColor;
////        _phoneLabel.lineBreakMode = NSLineBreakByCharWrapping;
//        _phoneLabel.text = [NSString stringWithFormat:@"为了您的支付安全，系统已向您绑定的手机号%@发送支付验证码，请输入已完成支付！", @"18888889898"];
    }
    return _phoneLabel;
}

- (void)cancleAction
{
    [self.codeView removeFromSuperview];
}

- (void)sureAction
{
    if (_codeTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        [SVProgressHUD dismissWithDelay:1.2];
        return;
    }
    else
        [self payByWallet];
}

- (UIView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, G_SCREEN_HEIGHT-50-_tempHeight, G_SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = MainColor;
        [self.view addSubview:_bottomView];
        
        CGFloat width = G_SCREEN_WIDTH/3;
        NSArray *array = @[@"返回首页", @"我的订单", @"购物车"];
        for (int i = 0; i<3; i++)
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 0, width, 50)];
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:btn];
        }
        
    }
    return _bottomView;
}

- (void)btnAction:(UIButton *)btn
{
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"返回首页"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
//        self.hidesBottomBarWhenPushed = NO;
    
//        self.navigationController.tabBarController.tabBar.hidden = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            app.tabbar.tabBar.hidden = NO;
            app.tabbar.selectedIndex = 0;
        });
        

        
    }
    else if ([title isEqualToString:@"我的订单"])
    {
        OrderListViewController *vc = [[OrderListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([title isEqualToString:@"购物车"])
    {
        ShoppingCarViewController *vc = [[ShoppingCarViewController alloc] init];
        vc.isSecond = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}










@end
