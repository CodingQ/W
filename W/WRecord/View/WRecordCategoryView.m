//
//  WRecordCategoryView.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WRecordCategoryView.h"
#import "UICountingLabel.h"
@interface WRecordCategoryView()
@property (nonatomic, strong)NSString *oldTitle;
@property (nonatomic, strong) UICountingLabel   *valueLabel;
@property (nonatomic, strong) UICountingLabel   *unitLabel;
@end
@implementation WRecordCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setLabels];
    }
    return self;
    
}

- (void)setLabels {
    self.valueLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.textColor = self.mainTitleColor;
    self.valueLabel.font = self.mainTitleFont;
    self.valueLabel.text = self.mainTitle;
    [self addSubview:self.valueLabel];
    
    self.unitLabel = [[UICountingLabel alloc] initWithFrame:CGRectZero];
    self.unitLabel.text = self.title;
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.textColor = self.titleColor;
    self.unitLabel.font = self.titleFont;
    [self addSubview:self.unitLabel];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-21);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueLabel.mas_bottom).offset(2);
        make.left.right.equalTo(self.valueLabel);
        make.height.equalTo(@21);
    }];
}

- (void)setLabelAnimation {
    self.valueLabel.method = UILabelCountingMethodLinear;
    self.valueLabel.format = self.format;
    [self.valueLabel countFrom:[_oldTitle doubleValue] to:[self.mainTitle doubleValue] withDuration:self.animationDuration];
}

- (void)setMainTitle:(NSString *)mainTitle {
    _oldTitle = _mainTitle;
    _mainTitle = mainTitle;
    self.valueLabel.text = mainTitle;
}

- (void)setMainTitleFont:(UIFont *)mainTitleFont {
    self.valueLabel.font = mainTitleFont;
}

- (void)setMainTitleColor:(UIColor *)mainTitleColor {
    self.valueLabel.textColor = mainTitleColor;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.unitLabel.text = title;
}

- (void)setTitleFont:(UIFont *)titleFont {
    self.unitLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    self.unitLabel.textColor = titleColor;
}

@end
