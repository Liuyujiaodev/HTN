//
//  CustomEmptyView.h
//  Pods
//
//  Created by hey on 2016/12/9.
//
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@interface CustomEmptyView : UIView

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UIImageView *emptyImageView;

@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) NSString *align;

-(instancetype)initEmptyView;

-(void)updateViewImage:(UIImage *)image description:(NSString *)text;

@end
