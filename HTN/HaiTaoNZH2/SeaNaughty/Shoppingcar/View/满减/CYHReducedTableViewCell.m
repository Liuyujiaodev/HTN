//
//  CYHReducedTableViewCell.m
//  SeaNaughty
//
//  Created by Apple on 2019/6/27.
//  Copyright © 2019年 chilezzz. All rights reserved.
//

#import "CYHReducedTableViewCell.h"


#import "Masonry.h"
@interface CYHReducedTableViewCell ()



@end
@implementation CYHReducedTableViewCell

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"待获取";
        
    }return _titleLabel;
}

-(UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"点击查看" forState:UIControlStateNormal];
        [_checkBtn setTitleColor:RGBCOLOR(25, 174, 236) forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }return _checkBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.titleLabel];
        [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(15);
        }];
        
        
        [self addSubview:self.checkBtn];
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(15);
            make.centerY.equalTo(self);
            make.height.offset(30);
        }];
        
        
    }return self;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
