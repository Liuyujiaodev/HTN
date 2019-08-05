//
//  AlertView.h
//  SeaNaughty
//
//  Created by chilezzz on 2018/11/2.
//  Copyright © 2018 chilezzz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AlertType)
{
    AlertTypeText,
    AlertTypeImage,
    AlertTypeView
};


@interface AlertView : UIView

@property (nonatomic, assign) AlertType type;
@property (nonatomic, strong) NSString *imageName;
//@property (nonatomic, assign)  *<#object#>;

@end
