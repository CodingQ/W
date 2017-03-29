//
//  WRecordCircleView.h
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WRecordCircleView : UIView
@property (nonatomic, assign) NSUInteger    totalStep; //目标步数
@property (nonatomic, copy)   NSString      *nowStep;   //当前步数
@property (nonatomic, assign) NSUInteger    animationDuration;
@end
