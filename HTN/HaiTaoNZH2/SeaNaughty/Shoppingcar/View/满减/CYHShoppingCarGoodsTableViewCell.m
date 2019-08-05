//
//  CYHShoppingCarGoodsTableViewCell.m
//  SeaNaughty
//
//  Created by Apple on 2019/6/27.
//  Copyright © 2019年 chilezzz. All rights reserved.
//

#import "CYHShoppingCarGoodsTableViewCell.h"
#import "CartProductCell.h"

#import "Masonry.h"
#import "CYHShopFullProduModel.h"
#import "ProductModel.h"
#import "CYHManJianViewController.h"
#import "ProductDetailViewController.h"


@interface CYHShoppingCarGoodsTableViewCell ()<UITableViewDelegate,UITableViewDataSource>

/** baseTableViewGroup */
@property(nonatomic,strong) UITableView *baseTabeleviewGrouped;
@property(nonatomic,strong) NSArray* dataSource;



@end


@implementation CYHShoppingCarGoodsTableViewCell

-(UITableView *)baseTabeleviewGrouped{
    if (_baseTabeleviewGrouped ==nil) {
        _baseTabeleviewGrouped = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _baseTabeleviewGrouped.delegate = self;
        _baseTabeleviewGrouped.dataSource = self;
        _baseTabeleviewGrouped.showsVerticalScrollIndicator = NO;
        _baseTabeleviewGrouped.backgroundColor = [UIColor whiteColor];
        _baseTabeleviewGrouped.separatorColor = [UIColor whiteColor];
        _baseTabeleviewGrouped.scrollEnabled = NO;
        [_baseTabeleviewGrouped registerClass:[CartProductCell class] forCellReuseIdentifier:@"CartProductCell"];
    }
    return _baseTabeleviewGrouped;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubview:self.baseTabeleviewGrouped];
        [self.baseTabeleviewGrouped mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        
    }return self;
}

-(void)setSectionArr:(NSArray *)sectionArr {
    _sectionArr = sectionArr;
    
    self.dataSource = sectionArr;
    [self.baseTabeleviewGrouped reloadData];
    
}

#pragma mark - tableVew-delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    CYHShopFullProduModel* model = self.dataSource[section];
    
    return model.orderItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CartProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartProductCell" forIndexPath:indexPath];
    cell.superVC = self.superVC;
    
    [cell handlerButtonAction:^(ProductModel *modelBlock) {
        NSLog(@"%@", modelBlock);
        //        [self updateProductCheck:modelBlock];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"radioSelect" object:modelBlock];
    }];
    
    CYHShopFullProduModel* model = self.dataSource[indexPath.section];
    
    cell.model = model.orderItems[indexPath.row];
    
    
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}

//返回每个区的头部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CYHShopFullProduModel* model = self.dataSource[section];
    
    if (model.shopFullID) {
        
        NSString* textString;
        if ([model.status boolValue]) {
            //已减
            
            if ([model.type isEqualToString:@"1"]) {
                
                textString = [NSString stringWithFormat:@"已享<%@>已减%@%@,再购%@件,减%@",model.prefixName,self.danWeiString,model.firstFullOffDiscountAmount,model.distance,model.nextFullOffDiscountAmount];
                
            } else {
                textString = [NSString stringWithFormat:@"已享<%@>已减%@%@,再购%@%@,减%@",model.prefixName,self.danWeiString,model.firstFullOffDiscountAmount,self.danWeiString,model.distance,model.nextFullOffDiscountAmount];
            }
            
        } else {
            //再购
            
            if ([model.type isEqualToString:@"1"]) {
                
                textString = [NSString stringWithFormat:@"再购%@件,享<%@>",model.distance,model.prefixName];
                
            } else {
                textString = [NSString stringWithFormat:@"再购%@%@享<%@>",self.danWeiString,model.distance,model.prefixName];
            }
            
        }
        
        CGSize textSize = kGetTextSize(textString, G_SCREEN_WIDTH - 170, MAXFLOAT, 12);
        
        return textSize.height + 20;
    } else {
        return 1;
    }
}

//返回每个区的尾部视图的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CYHShopFullProduModel* model = self.dataSource[section];
    
    if (model.shopFullID) {
        
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 45)];
        headView.backgroundColor = [UIColor whiteColor];
        
        UILabel* manJianLabel = [[UILabel alloc] init];
        manJianLabel.text = @"满减";
        manJianLabel.textAlignment = NSTextAlignmentCenter;
        manJianLabel.textColor = [UIColor blackColor];
        manJianLabel.font = [UIFont systemFontOfSize:13];
        manJianLabel.layer.borderWidth = .7;
        manJianLabel.layer.borderColor = MainColor.CGColor;
        [headView addSubview:manJianLabel];
        [manJianLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(50);
            make.height.offset(24);
            make.left.equalTo(headView).offset(10);
            make.centerY.equalTo(headView);
        }];
        
        UILabel* priceLabel = [[UILabel alloc] init];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        priceLabel.textColor = TextColor;
        priceLabel.font = [UIFont systemFontOfSize:12];
        priceLabel.text = @"待获取";
        priceLabel.numberOfLines = 0;
        [headView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView).offset(10);
//            make.bottom.equalTo(headView).offset(-10);
            make.left.equalTo(manJianLabel.mas_right).offset(10);
            make.right.equalTo(headView).offset(-100);
        }];
        
        UIButton* gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gotoBtn setTitle:@"去凑单" forState:UIControlStateNormal];
        [gotoBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        gotoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [gotoBtn addTarget:self action:@selector(gotoClick:) forControlEvents:UIControlEventTouchUpInside];
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
                                     NSUnderlineStyleAttributeName:[UIColor redColor]
                                     };
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"去凑单" attributes:attribtDic];
        gotoBtn.titleLabel.attributedText = attribtStr;
        gotoBtn.tag = section + 10;
        [headView addSubview:gotoBtn];
        [gotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(headView);
            make.right.equalTo(headView).offset(-50);
        }];
        
//        ProductModel* proModel = model.orderItems[0];
        
        if ([model.status boolValue]) {
            //已减
            
            if ([model.type isEqualToString:@"1"]) {
                
                priceLabel.text = [NSString stringWithFormat:@"已享<%@>已减%@%@,再购%@件,减%@",model.prefixName,self.danWeiString,model.firstFullOffDiscountAmount,model.distance,model.nextFullOffDiscountAmount];
                
            } else {
                priceLabel.text = [NSString stringWithFormat:@"已享<%@>已减%@%@,再购%@%@,减%@",model.prefixName,self.danWeiString,model.firstFullOffDiscountAmount,self.danWeiString,model.distance,model.nextFullOffDiscountAmount];
            }
            
        } else {
           //再购
           
            if ([model.type isEqualToString:@"1"]) {
                
                priceLabel.text = [NSString stringWithFormat:@"再购%@件,享<%@>",model.distance,model.prefixName];
                
            } else {
                priceLabel.text = [NSString stringWithFormat:@"再购%@%@享<%@>",self.danWeiString,model.distance,model.prefixName];
            }
            
        }
        
        return headView;
        
    } else {
        
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, G_SCREEN_WIDTH, 1)];
        headView.backgroundColor = MainColor;
        
        
        return headView;
    }
    
    
}

-(void)gotoClick:(UIButton *)sender {
    
    NSLog(@"%ld",sender.tag);
    
    CYHShopFullProduModel* model = self.dataSource[sender.tag - 10];
    
    CYHManJianViewController* manVC = [[CYHManJianViewController alloc] init];
    
    manVC.manShoppingDic = @{@"prefixName":model.prefixName,@"shopId":model.shopId,@"productIds":model.productIds,@"activityProduct":model.activityProduct};
    [self.superVC.navigationController pushViewController:manVC animated:YES];
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductModel *product;
    CYHShopFullProduModel* model = self.dataSource[indexPath.section];
    product = model.orderItems[indexPath.row];
    
    ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
    
    vc.productId = product.productId;
    [self.superVC.navigationController pushViewController:vc animated:YES];
    
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
