//
//  WCustomSwitch.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WCustomSwitch.h"

#define cicleLeftAndRight 3 //小圆的缩进大小 可以通过改变数字调整

@interface WCustomSwitch ()

@property (nonatomic, assign) CGRect leftRect;
@property (nonatomic, assign) CGRect rightRect;

@end

@implementation WCustomSwitch

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.enabled = YES;
        self.on = NO;
        self.leftRect = CGRectMake(cicleLeftAndRight/2, cicleLeftAndRight/2 + 0.25, frame.size.height- cicleLeftAndRight, frame.size.height- cicleLeftAndRight);
        self.rightRect = CGRectMake(frame.size.width - frame.size.height + cicleLeftAndRight/2, self.leftRect.origin.y + 0.25 , self.leftRect.size.width, self.leftRect.size.height);
        
        self.layer.cornerRadius = frame.size.height/2;
        self.cicleView = [[UIImageView alloc]init];
        self.cicleView.frame = self.leftRect;
        self.cicleView.backgroundColor = [UIColor whiteColor];
        self.cicleView.layer.cornerRadius = (frame.size.height - cicleLeftAndRight)/2;
        [self addSubview:self.cicleView];
        self.backgroundColor = [UIColor colorWithHexString:@"bdbdbd"];//默认灰色
    }
    return self;
}

- (void)setSwiftOnImageName:(NSString *)onImageName offImageName:(NSString *)offImageName withTarget:(id)target action:(SEL)action{
    
    self.onImageName = onImageName;
    self.offImageName = offImageName;
    [self setBackgroundImage:[UIImage imageNamed:onImageName] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageNamed:offImageName] forState:UIControlStateNormal];
    
    //添加目标和方法
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSwiftOnColor:(UIColor *)onColor offColor:(UIColor *)offColor withTarget:(id)target action:(SEL)action {
    self.onColor = onColor;
    self.offColor = offColor;
    //添加目标和方法
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setOn:(BOOL)on {
    _on = on;
    self.selected = on;
    [UIView animateWithDuration:0.3 animations:^{
        self.cicleView.frame = on ? self.rightRect : self.leftRect;
        self.backgroundColor = on ? self.onColor : self.offColor;
    } completion:^(BOOL finished) {
        
    }];
}


@end
