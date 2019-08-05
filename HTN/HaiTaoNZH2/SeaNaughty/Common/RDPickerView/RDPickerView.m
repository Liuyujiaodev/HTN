//
//  RDPickerView.m
//  Pods
//
//  Created by Mr_zhaohy on 2016/11/24.
//
//

#import "RDPickerView.h"
#import <Masonry/Masonry.h>

#define PickerView_height 170
#define Button_height 40

@interface RDPickerView ()
{
    //点击手势
    UITapGestureRecognizer *_tapGes;
    UIView *_btnView;
    UIButton *_cancelBtn;
    UIButton *_sureBtn;
}
@end

@implementation RDPickerView
-(instancetype)initWithView:(UIView *)view{
    self = [super init];
    [self initSubviews];
    //添加手势
    [self addGesture];
    //初始化并隐藏
    self.hidden = YES;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return self;
}
-(void)addGesture{
    _tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundView)];
    [self addGestureRecognizer:_tapGes];
}
-(void)initSubviews{
    
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.showsSelectionIndicator = YES;
    [self addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(PickerView_height);
        //自身高度+按钮高度
        make.top.mas_equalTo(self.mas_bottom).with.offset(Button_height);
    }];
    _btnView = [[UIView alloc]init];
    _btnView.backgroundColor = [UIColor whiteColor];
    [_btnView removeGestureRecognizer:_tapGes];
    [self addSubview:_btnView];
    [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self->_pickerView.mas_top).with.offset(-0.5);
        make.left.and.right.equalTo(self);
        make.height.mas_equalTo(Button_height);
    }];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:TextColor forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.and.bottom.equalTo(self->_btnView);
        make.width.mas_equalTo(50);
    }];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:TextColor forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sureBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_btnView addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self->_btnView.mas_right).with.offset(-25);
        make.top.and.bottom.equalTo(self->_btnView);
        make.width.mas_equalTo(50);
    }];
}
-(void)showWithAnimation:(BOOL)animation{
    self.hidden = NO;
    [_pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_bottom).with.offset(-(PickerView_height));
    }];

    [UIView animateWithDuration:animation == YES ? 0.37 : 0 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    }];
}
-(void)dissmissWithAnimation:(BOOL)animation{
    [self dissmissWithIndex:0 animation:animation];
}
-(void)tapBackgroundView{
    [self dissmissWithIndex:0 animation:YES];
}
-(void)clickBtn:(UIButton *)btn{
    //取消的index为0
    [self dissmissWithIndex:btn == _cancelBtn ? 0 : 1 animation:YES];
}
-(void)dissmissWithIndex:(NSInteger)index animation:(BOOL)animation{
    [_pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        //自身高度+按钮高度
        make.top.mas_equalTo(self.mas_bottom).with.offset(Button_height);
    }];
    
    if(animation)
    {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    
    [UIView animateWithDuration:animation == YES ? 0.37 : 0 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:dissmissWithButtonIndex:)])
    {
        [self.delegate pickerView:self dissmissWithButtonIndex:index];
    }
}
-(void)setDelegate:(id<RDPickerViewDelegate>)delegate{
    _pickerView.delegate = delegate;
    _pickerView.dataSource = delegate;
    _delegate = delegate;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
