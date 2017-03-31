//
//  WUserHeadView.h
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WUserHeadDelegate <NSObject>

- (void)userHeadClick;

@end

@interface WUserHeadView : UIView

@property (nonatomic, weak) id<WUserHeadDelegate> delegate;

- (void)setUserName:(NSString *)name;                                       // 设置用户名
- (void)setUserImage:(UIImage *)image;                                      // 设置用户头像
- (void)setUserHeight:(CGFloat)height;                                    // 设置用户身高
- (void)setUserWeight:(CGFloat)weight;                                    // 设置用户体重
- (void)setUserBMI:(CGFloat)bmi;                                            // 设置用户BMI值
- (void)setUserTarget:(NSInteger)target;                                    // 设置用户目标
@end
