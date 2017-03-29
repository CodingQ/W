//
//  WChartFactory.h
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBaseChart.h"

typedef enum : NSUInteger {
    WChartLine,       //折线
    WChartColumnar,               // 柱状图
    WChartPanCake                 // 饼图
} WChartType;
@interface WChartFactory : NSObject
+ (WBaseChart *)chartsFactory:(WChartType)chartType;
@end
