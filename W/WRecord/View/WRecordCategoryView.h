//
//  WRecordCategoryView.h
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRecordCategoryView : UIView
@property (nonatomic, assign)   NSUInteger    animationDuration;
@property (nonatomic, copy)     NSString      *mainTitle; //数值
@property (nonatomic, strong)   UIFont        *mainTitleFont;  //数值字体
@property (nonatomic, copy)     NSString      *title;   //单位
@property (nonatomic, strong)   UIFont        *titleFont; //单位字体
@property (nonatomic, copy)     NSString      *format;  //格式
@property (nonatomic, strong)   UIColor       *mainTitleColor;
@property (nonatomic, strong)   UIColor       *titleColor;

- (void)setLabelAnimation;

@end
