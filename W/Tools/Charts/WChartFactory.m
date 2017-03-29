//
//  WChartFactory.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WChartFactory.h"
#import "WLineChart.h"
#import "WColumChart.h"
@implementation WChartFactory
+ (WBaseChart *)chartsFactory:(WChartType)chartType {
    WBaseChart *base = nil;
    switch (chartType) {
        case WChartLine:
            base = [[WLineChart alloc] initWithFrame:CGRectZero];
            break;
        case WChartColumnar:
            base = [[WColumChart alloc] initWithFrame:CGRectZero];
            break;
        case WChartPanCake:
            break;
            
        default:
            base = [[WLineChart alloc] initWithFrame:CGRectZero];
            break;
    }
    
    base.lineColor = [UIColor mainColor];
    base.lineWidth = 5.f;
    base.hasAnimation = YES;
    base.dashLineColor = [UIColor colorWithRed:230 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:0.6];
    base.valueLabelFont = [UIFont systemFontOfSize:14.f];
    base.valueLabelColor = [UIColor mainColor];
    base.animationDuration = 1.f;
    base.labelFont = [UIFont systemFontOfSize:10.f];
    base.labelColor = [UIColor colorWithRed:202 / 255.0 green:202 / 255.0 blue:202 / 255.0 alpha:1];
    base.hasDashLine = YES;
    base.hasShowValue = NO;
    base.showAllDashLine = YES;
    base.backgroundColors = @[(__bridge id)[UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor,
                              (__bridge id)[UIColor mainColor].CGColor];
    
    return base;
}

@end
