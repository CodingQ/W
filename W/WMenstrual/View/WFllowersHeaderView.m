//
//  WFllowersHeaderView.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WFllowersHeaderView.h"

@implementation WFllowersHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.fllowersImageView];
    [self addSubview:self.dayLabel];// 布局基于这个
    [self addSubview:self.describeLabel];
    [self addSubview:self.stateLabel];
    [self viewLayout];
}

- (void)viewLayout{
    
    [_fllowersImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(240, 240));
    }];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 60));
    }];
    
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_dayLabel.mas_top);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(240, 40));
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dayLabel.mas_bottom);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(240, 40));
    }];
}

- (UIImageView *)fllowersImageView{
    if (!_fllowersImageView) {
        _fllowersImageView = [[UIImageView alloc] init];
    }
    return _fllowersImageView;
}


- (UILabel *)describeLabel{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.font = [UIFont fontWithName:@"DINCond-Medium" size:27];
        _describeLabel.textAlignment = NSTextAlignmentCenter;
        _describeLabel.textColor = [UIColor whiteColor];
    }
    return _describeLabel;
}

- (UILabel *)dayLabel{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont fontWithName:@"DINCond-Medium" size:45];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.textColor = [UIColor whiteColor];
    }
    return _dayLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont fontWithName:@"DINCond-Medium" size:27];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
    }
    return _stateLabel;
}

@end


@implementation CalendarBottmLabelView

static NSInteger const LabelFontSize = 10;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.view1];
    [self addSubview:self.view2];
    [self addSubview:self.view3];
    [self addSubview:self.view4];
    [self viewLayout];
}

- (void)viewLayout{
    
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self);
    }];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_view1.mas_right).equalTo(@4);
        make.centerY.equalTo(self);
    }];
    [_view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_view2.mas_right).equalTo(@4);
        make.centerY.equalTo(self);
    }];
    [_view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_view3.mas_right).equalTo(@4);
        make.right.lessThanOrEqualTo(@(-10));
        make.centerY.equalTo(self);
    }];
    
}

- (StateImageViewAndLabelView *)view1{
    if (!_view1) {
        _view1 = [[StateImageViewAndLabelView alloc] init];
        _view1.label.textColor = [UIColor colorWithHexString:@"ffcdd2"];
        _view1.imageView.image = [UIImage imageNamed:@"Menstrual_period"];
    }
    return _view1;
}

- (StateImageViewAndLabelView *)view2{
    if (!_view2) {
        _view2 = [[StateImageViewAndLabelView alloc] init];
        _view2.label.textColor = [UIColor colorWithHexString:@"e57373"];
        _view2.imageView.image = [UIImage imageNamed:@"Menstrual_period"];
    }
    return _view2;
}

- (StateImageViewAndLabelView *)view3{
    if (!_view3) {
        _view3 = [[StateImageViewAndLabelView alloc] init];
        _view3.label.textColor = [UIColor colorWithHexString:@"7e57c2"];
        _view3.imageView.image = [UIImage imageNamed:@"Ovulation"];
    }
    return _view3;
}

- (StateImageViewAndLabelView *)view4{
    if (!_view4) {
        _view4 = [[StateImageViewAndLabelView alloc] init];
        _view4.label.textColor = [UIColor colorWithHexString:@"673ab7"];
        _view4.imageView.image = [UIImage imageNamed:@"Ovulation_day"];
    }
    return _view4;
}

@end


@implementation StateImageViewAndLabelView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    
    [self viewLayout];
}

- (void)viewLayout{
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_offset(CGSizeMake(5, 5));
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_right).equalTo(@2);
        make.top.right.bottom.equalTo(self);
    }];
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:LabelFontSize];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.adjustsFontSizeToFitWidth = YES;
    }
    return _label;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end



@implementation HeaderInSectionView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews:frame];
    }
    return self;
}

- (void)setupViews:(CGRect)frame{
    [self addSubview:self.calendarLabel];
    [self addSubview:self.stateLabel];
    
    [self viewLayout:frame];
}

- (void)viewLayout:(CGRect)frame{
    CGFloat height = CGRectGetHeight(frame) / 2 - 10;
    
    [_calendarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.offset(height);
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-10));
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.offset(height);
    }];
}


- (UILabel *)calendarLabel{
    if (!_calendarLabel) {
        _calendarLabel = [[UILabel alloc] init];
        //        _calendarLabel.font = [UIFont  fontWithName:@"Helvetica-Bold" size:17];
        _calendarLabel.font = [UIFont systemFontOfSize:17];
        _calendarLabel.textAlignment = NSTextAlignmentLeft;
        _calendarLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _calendarLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        _stateLabel.textAlignment = NSTextAlignmentLeft;
        _stateLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _stateLabel;
}

@end
