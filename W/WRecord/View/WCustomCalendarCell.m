//
//  WCustomCalendarCell.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WCustomCalendarCell.h"


@implementation WCustomCalendarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAShapeLayer *ovulationDayLayer = [[CAShapeLayer alloc] init];
        ovulationDayLayer.fillColor = [UIColor colorWithHue:0.75 saturation:0.80 brightness:0.71 alpha:1.00].CGColor;
        ovulationDayLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:ovulationDayLayer below:self.titleLabel.layer];
        self.ovulationDayLayer = ovulationDayLayer;
        
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        selectionLayer.fillColor = [UIColor colorWithRed:0.99 green:0.80 blue:0.82 alpha:1.00].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:selectionLayer below:ovulationDayLayer];
        self.selectionLayer = selectionLayer;
        
        
        CAShapeLayer *todayLayer = [[CAShapeLayer alloc] init];
        todayLayer.fillColor = [UIColor colorWithRed:0.26 green:0.80 blue:0.86 alpha:1.00].CGColor;
        todayLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:todayLayer below:ovulationDayLayer];
        self.todayLayer = todayLayer;
        
        
        self.todayLayer.hidden = YES;
        self.shapeLayer.hidden = YES;
        self.ovulationDayLayer.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 重写各个日期的布局
    self.titleLabel.frame = CGRectMake(0, 0, 20, 20);
    self.titleLabel.center = CGPointMake(self.fs_width / 2, 15);
    
    CGRect frame = CGRectMake(0, 4.5, self.fs_width, 22);
    self.selectionLayer.frame = frame;
    self.selectionLayer.frame = CGRectInset(frame, -1, 0);
    
    self.todayLayer.frame = CGRectMake(0, 0, 30, 30);
    
    CGFloat diameter1 = MIN(self.todayLayer.fs_height, self.todayLayer.fs_width);
    self.todayLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter1/2, self.contentView.fs_height/2-17, diameter1, diameter1)].CGPath;
    
    self.ovulationDayLayer.frame = CGRectMake(0, 0, 20, 20);
    CGFloat diameter2 = MIN(self.ovulationDayLayer.fs_height, self.ovulationDayLayer.fs_width);
    self.ovulationDayLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter2/2, self.contentView.fs_height/2-12, diameter2, diameter2)].CGPath;
    
    
    if (self.selectionType == SelectionTypeMiddle) {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:self.selectionLayer.bounds].CGPath;
    }
    else if (self.selectionType == SelectionTypeLeftBorder)
    {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.selectionLayer.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.selectionLayer.fs_width/2, self.selectionLayer.fs_width/2)].CGPath;
    }
    else if (self.selectionType == SelectionTypeRightBorder)
    {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.selectionLayer.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(self.selectionLayer.fs_width/2, self.selectionLayer.fs_width/2)].CGPath;
    }
    else if (self.selectionType == SelectionTypeSingle)
    {
        //        CGFloat diameter = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width);
        self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-diameter2/2 + 1, self.contentView.fs_height/2-16, diameter2, diameter2)].CGPath;
    }
}

- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}
@end
