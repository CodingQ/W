//
//  WPageControl.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WPageControl.h"

@interface WPageControl ()

@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@end

@implementation WPageControl

- (void)setupCurrentImageName:(NSString *)currentImageName
           indicatorImageName:(NSString *)indicatorImageName{
    _currentImage = [UIImage imageNamed:currentImageName];
    _inactiveImage = [UIImage imageNamed:indicatorImageName];
}


// 重写CurrentPage的set方法
- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self updateDotsImage];
}

- (void)updateDotsImage{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView * dot = [self imageViewForSubview:[self.subviews objectAtIndex:i]];
        if(i == self.currentPage)
        {
            dot.image = self.currentImage;
        }
        else
        {
            dot.image = self.inactiveImage;
        }
    }
}

- (UIImageView *)imageViewForSubview:(UIView *)view{
    UIImageView * dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView* subview in view.subviews)
        {
            if ([subview isKindOfClass:[UIImageView class]])
            {
                dot = (UIImageView *)subview;
                break;
            }
        }
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
            [view addSubview:dot];
        }
    }
    else
    {
        dot = (UIImageView *) view;
    }
    
    return dot;
}


@end
