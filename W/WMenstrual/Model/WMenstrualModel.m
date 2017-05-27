//
//  WMenstrualModel.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WMenstrualModel.h"

@implementation WMenstrualModel



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupObjects];
    }
    return self;
}

- (void)setupObjects{
    // 事件数据源
    // 事件数据源
//    self.datesWithEvent = @[@"2016-12-23"];
//    
//    self.datesWithMultipleEvents = @[@"2016-12-09"];
//    
//    self.datesOfLastForecastPeriod = @[@"2016-11-09", @"2016-11-10", @"2016-11-11",
//                                       @"2016-11-12", @"2016-11-13", @"2016-11-14",
//                                       @"2016-11-15", @"2016-11-16"];
//    
//    // 各个阶段数据
//    self.datesOfMenstrualPeriod = @[@"2016-12-09", @"2016-12-10", @"2016-12-11",
//                                    @"2016-12-12", @"2016-12-13", @"2016-12-14",
//                                    @"2016-12-15", @"2016-12-16"];
//    
//    self.datesOfForecastPeriod = @[@"2016-12-23", @"2016-12-24", @"2016-12-25",
//                                   @"2016-12-26", @"2016-12-27", @"2016-12-28",
//                                   @"2016-12-29", @"2016-12-30"];
//    
//    
//    
//    self.datesOfNextForecastPeriod = @[@"2017-01-07", @"2017-01-08", @"2017-01-09",
//                                       @"2017-01-10", @"2017-01-11", @"2017-01-12",
//                                       @"2017-01-13", @"2017-01-14"];
//    
    self.iconImageArray = [@[@"period-begin_end",@"period-begin_end"] mutableCopy];
    
    self.titleLabelTextArray = [@[@"姨妈来了🙄",@"姨妈走了👻"] mutableCopy];
    
    self.titleLabelForBottomStateGuide = @[@"姨妈还在😭",
                                           @"姨妈可能要来🤔",
                                           @"姨妈没来😎"];
    
 
}



@end
