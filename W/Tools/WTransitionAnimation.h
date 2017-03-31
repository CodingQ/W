//
//  WTransitionAnimation.h
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WPresentTrasitionType) {
    WPresentTrasitionPresent,
    WPresentTrasitionDismiss
};

typedef NS_ENUM(NSUInteger, WAnimationType) {
    WAnimationUpToDown,
    WAnimationCircle
};

@interface WTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(WPresentTrasitionType)type animationType:(WAnimationType)animationType;
- (instancetype)initWithTransitionType:(WPresentTrasitionType)type animationType:(WAnimationType)animationType;
@end
