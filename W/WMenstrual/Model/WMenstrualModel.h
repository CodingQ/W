//
//  WMenstrualModel.h
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMenstrualModel : NSObject

@property (nonatomic, copy) NSArray *datesWithEvent;// 单事件
@property (nonatomic, copy) NSArray *datesWithMultipleEvents;// 多重事件

@property (nonatomic, copy) NSArray *datesOfLastForecastPeriod;
@property (nonatomic, copy) NSArray *datesOfMenstrualPeriod;// 月经期
@property (nonatomic, copy) NSArray *datesOfForecastPeriod;// 预产下一月经期
@property (nonatomic, copy) NSArray *datesOfOvulation;// 排卵期
@property (nonatomic, copy) NSArray *datesOfOvulationDay;// 排卵日
@property (nonatomic, copy) NSArray *datesOfNextForecastPeriod;
@property (nonatomic, strong) NSMutableArray *iconImageArray;
@property (nonatomic, strong) NSMutableArray *titleLabelTextArray;
@property (nonatomic, copy) NSArray *titleLabelForBottomStateGuide;
@property (nonatomic, copy) NSArray *menstrualFlowRemindArray;
@property (nonatomic, copy) NSArray *menstrualPainRemindArray;
@end
