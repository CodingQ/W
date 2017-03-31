//
//  WUserHeadView.m
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WUserHeadView.h"
#import "WRecordCategoryView.h"
@interface WUserHeadView ()

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WRecordCategoryView *heightLabel;
@property (nonatomic, strong) WRecordCategoryView *weightLabel;
@property (nonatomic, strong) WRecordCategoryView *bmiLabel;
@property (nonatomic, strong) WRecordCategoryView *targetLabel;
@property (nonatomic, copy)   NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *labelArray;

@end

@implementation WUserHeadView

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackground];
        [self setUI];
        [self setMessageUI];
        [self addGesture];
    }
    return self;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@"身高", @"体重", @"BMI", @"目标"];
    }
    return _dataArray;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

#pragma mark - Set UI Method
//- (void)setBackground {
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = self.bounds;
//    gradient.startPoint = CGPointMake(0.f, 0.f);
//    gradient.endPoint = CGPointMake(0.f, 1.f);
//    gradient.colors = @[(__bridge id)[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1].CGColor,
//                        (__bridge id)[UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor];
//    [gradient setLocations:@[@0, @0.8, @1]];
//    
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = path.CGPath;
//    shapeLayer.strokeColor = [UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor;
//    shapeLayer.fillColor = [UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor;
//    shapeLayer.lineCap = kCALineCapRound;
//    shapeLayer.lineJoin = kCALineJoinRound;
//    
//    [gradient setMask:shapeLayer];
//    [self.layer addSublayer:gradient];
//}

- (void)setUI {
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"3.jpg"];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.frame = self.bounds;
    [self addSubview:self.imageView];
    
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.height.mas_equalTo(kScreenH / 6.0);
//    }];
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.textColor = [UIColor whiteColor];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.text = @"W.w.w";
    self.userNameLabel.font = [UIFont systemFontOfSize:kScreenH / 30.f];
    [self addSubview:self.userNameLabel];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self).offset(30);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)setMessageUI {
    
    for (int index = 0; index < 4; index++) {
        WRecordCategoryView *label = [[WRecordCategoryView alloc] initWithFrame:CGRectZero];
        label.mainTitle = self.dataArray[index];
        label.title = @"- -";
        label.mainTitleFont = [UIFont systemFontOfSize:17.f];
        label.titleFont = [UIFont fontWithName:@"Helvetica" size:17.f];
        label.mainTitleColor = [UIColor whiteColor];
        label.titleColor = [UIColor whiteColor];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.width.mas_equalTo(kScreenW / 4.0);
            make.height.mas_equalTo(50);
            make.left.equalTo(self.mas_left).offset(kScreenW / 4.0 * index);
        }];
        
        [self.labelArray addObject:label];
    }
    
}

- (void)addGesture {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(headClickButtonAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:singleTap];
}

#pragma mark - Head View Click Action
- (void)headClickButtonAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userHeadClick)]) {
        [self.delegate userHeadClick];
    }
}

#pragma mark - Set Method
- (void)setUserName:(NSString *)name {
    self.userNameLabel.text = name;
}

- (void)setUserImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setUserHeight:(CGFloat)height {
    if (self.labelArray <= 0) {
        return;
    }
    WRecordCategoryView *label = self.labelArray[0];
    label.title = [NSString stringWithFormat:@"%.1f", height];
}

- (void)setUserWeight:(CGFloat)weight {
    if (self.labelArray <= 0) {
        return;
    }
    WRecordCategoryView *label = self.labelArray[1];
    label.title = [NSString stringWithFormat:@"%.1f", weight];
}

- (void)setUserBMI:(CGFloat)bmi {
    if (self.labelArray <= 0) {
        return;
    }
    WRecordCategoryView *label = self.labelArray[2];
    label.title = [NSString stringWithFormat:@"%.1f", bmi];
}

- (void)setUserTarget:(NSInteger)target {
    if (self.labelArray <= 0) {
        return;
    }
    WRecordCategoryView *label = self.labelArray[3];
    label.title = [NSString stringWithFormat:@"%ld", target];
}

@end
