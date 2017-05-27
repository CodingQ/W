//
//  WChildViewController.h
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    WAChartLine = 0,
    WAChartBar
} WAChartType;

@interface WChildViewController : UIViewController

@property (nonatomic, copy)     NSString        *unit;
@property (nonatomic, copy)     NSString        *unitStr;
@property (nonatomic, assign)   WAChartType    chartType;

@end
