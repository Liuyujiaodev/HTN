//
//  ScanViewController.m
//  SeaNaughty
//
//  Created by chilezzz on 2018/10/22.
//  Copyright © 2018年 chilezzz. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ListShopViewController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView * imageView;
    
    BOOL hasCameraRight;
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property (nonatomic, strong) UIButton *flashlightBtn;


@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//
//    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
//    {
//        //无权限
//        return;
//
//     }
    
    
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor blackColor];
    
    //明暗对比
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:maskView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, G_SCREEN_WIDTH, G_SCREEN_HEIGHT)];
    
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 50+ 64,G_SCREEN_WIDTH - 100, G_SCREEN_WIDTH - 100) cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.path = maskPath.CGPath;
    
    maskView.layer.mask = maskLayer;
    
    
    
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"没有相机权限" message:@"请去设置-隐私-相机中对扫一扫授权" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action2){
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [alert addAction:action2];
        //5.将警告呈现出来
        [self presentViewController:alert animated:YES completion:nil];
        hasCameraRight = NO;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        return;
    }
    hasCameraRight = YES;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50+ 64,G_SCREEN_WIDTH - 100, G_SCREEN_WIDTH - 100)];
    imageView.image = [UIImage imageNamed:@"contact_scanframe"];
    [self.view addSubview:imageView];
    
    
    UILabel * introudctionLB= [[UILabel alloc] initWithFrame:CGRectMake(50, G_SCREEN_WIDTH + 34, G_SCREEN_WIDTH - 100, 30)];
    introudctionLB.backgroundColor = [UIColor clearColor];
    introudctionLB.textColor=[UIColor whiteColor];
    introudctionLB.font = [UIFont systemFontOfSize:13];
    introudctionLB.textAlignment = NSTextAlignmentCenter;
    introudctionLB.text=@"将取景框对准二维码，即可自动扫描";
    [self.view addSubview:introudctionLB];
    
    self.flashlightBtn = [[UIButton alloc]initWithFrame:CGRectMake(G_SCREEN_WIDTH/2 - 20, G_SCREEN_WIDTH + 64, 40, 40)];
    [self.flashlightBtn setTitle:@"手电" forState:UIControlStateNormal];
    [self.flashlightBtn addTarget:self action:@selector(flashlightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashlightBtn];
    
    
    upOrdown = NO;
    num =0;
//    _line = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50+ 64 + 8, widthScreen - 100 - 40, 2)];
//    _line.x = self.view.x;
//    _line.image = [UIImage imageNamed:@"line"];
//    [self.view addSubview:_line];
    
    
    [self setupCamera];
}
-(void)flashlightBtnAction:(UIButton *)sender {//闪光灯
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch]) { // 判断是否有闪光灯
            
            // 请求独占访问硬件设备
            
            [device lockForConfiguration:nil];
            
            if (sender.tag == 0) {
                
                
                sender.tag = 1;
                
                [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
                
            }else{
                
                
                sender.tag = 0;
                
                [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
                
            }
            
            // 请求解除独占访问硬件设备
            
            [device unlockForConfiguration];
        }
    }
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 50+ 64 + 8+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (2 * num >= CGRectGetHeight(imageView.frame) - 16) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(CGRectGetMinX(_line.frame), 50+ 64 + 8+2*num, CGRectGetWidth(_line.frame), CGRectGetHeight(_line.frame));
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (hasCameraRight) {
        if (_session && ![_session isRunning]) {
            [_session startRunning];
        }
//        timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [timer invalidate];
}

- (void)setupCamera
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        // Device
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        // Input
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        _output = [[AVCaptureMetadataOutput alloc]init];
        //    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        
        
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input])
        {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output])
        {
            [_session addOutput:self.output];
        }
        
        // 条码类型 AVMetadataObjectTypeQRCode
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // Preview
            _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
            _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //    _preview.frame =CGRectMake(20,110,280,280);
            _preview.frame = self.view.bounds;
            
            [self.view.layer insertSublayer:self.preview atIndex:0];
            // Start
            [_session startRunning];
            
            CGRect intertRect = [_preview metadataOutputRectOfInterestForRect:imageView.frame];
            
            //限制区域
            [ _output setRectOfInterest : intertRect];
            
        });
    });
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        [_session stopRunning];
        [timer invalidate];
        
        stringValue = [[stringValue componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        NSLog(@"%@",stringValue);
        
        if (stringValue.length > 0)
        {
            ListShopViewController *vc = [[ListShopViewController alloc] init];
            vc.searchString = stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

@end
