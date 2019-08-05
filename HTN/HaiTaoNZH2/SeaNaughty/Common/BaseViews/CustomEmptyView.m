//
//  CustomEmptyView.m
//  Pods
//
//  Created by hey on 2016/12/9.
//
//

#import "CustomEmptyView.h"
#import "UIColor+Palette.h"

@interface CustomEmptyView ()



@end

@implementation CustomEmptyView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

-(instancetype)initEmptyView
{
    self = [super init];
    if (self) {
        [self createViews];
        [self createConstrains];
    }
    return self;
}

-(void)createViews
{
    _infoView = [[UIView alloc] init];
    [self addSubview:_infoView];
    
    self.userInteractionEnabled = YES;
    _infoView.userInteractionEnabled = YES;
    _emptyImageView = [[UIImageView alloc] init];
    if(_emptyImageView){
//        _emptyImageView = [[UIImageView alloc] init];
        [_infoView addSubview:_emptyImageView];
    }
    
    
    _describeLabel = [[UILabel alloc] init];
//    _describeLabel.font = ;
    _describeLabel.numberOfLines = 0;
    _describeLabel.font = [UIFont systemFontOfSize:14];
    _describeLabel.textColor = [UIColor colorFromHexString:@"#999999"];
    _align = [[NSString alloc] init];

    _describeLabel.textAlignment = NSTextAlignmentCenter;
    [_infoView addSubview:_describeLabel];
    
//    _btn = [[UIButton alloc] init];
//    _btn.backgroundColor = [UIColor redColor];
//    [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//    [_infoView addSubview:_btn];
   
}

-(void)createConstrains
{
    __weak typeof(self) weakSelf = self;
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(G_SCREEN_WIDTH-30, 160));
    }];
    
    if(_emptyImageView){
        [_emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.infoView).offset(10);
            make.centerX.equalTo(weakSelf.infoView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(122, 100));
        }];
    }
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if(_emptyImageView){
            make.bottom.equalTo(weakSelf.infoView).offset(-10);
        }else{
            make.centerY.equalTo(weakSelf.infoView.mas_centerY);
            
        }
        make.left.equalTo(weakSelf.infoView);
        make.right.equalTo(weakSelf.infoView);
    }];
    

    
}

- (void)btnAction
{
    NSLog(@"smcs");
}

-(void)updateViewImage:(UIImage *)image description:(NSString *)text
{
    _emptyImageView.image = image;
    _describeLabel.text = text;
  
}


@end
