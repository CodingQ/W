//
//  WMenstrualPeriodAlgorithm.h
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMenstrualPeriodAlgorithm : NSObject
/*
 存储字符串日期
 */



/**
 获取当前经期算法
 
 @param date 选中的经期开始日
 @param periodLength 经期持续天数
 @return 当前经期
 */
+ (NSArray<NSString *> *)vp_GetCurrentMenstrualPeriodWithDate:(NSDate *)date PeriodLength:(NSInteger)periodLength;



/**
 获取预测经期算法
 
 @param date 选中的经期开始日
 @param cycleDay 经期间隔天数
 @param periodLength 经期持续天数
 @return 各个预测经期
 */
+ (NSArray<NSString *> *)vp_GetMenstrualPeriodWithDate:(NSDate *)date CycleDay:(NSInteger)cycleDay PeriodLength:(NSInteger)periodLength;

/**
 获取预测排卵日算法
 
 @param date 选中的经期开始日
 @param cycleDay 经期间隔天数
 @param periodLength 经期持续天数
 @return 各个排卵日
 */
+ (NSArray<NSString *> *)vp_GetOvulationDayWithDate:(NSDate *)date CycleDay:(NSInteger)cycleDay PeriodLength:(NSInteger)periodLength;

/**
 获取预测排卵期算法
 选中的经期开始日->调用vp_GetOvulationDayWithDate算出排卵日
 排卵日前5后4+排卵日为排卵期
 
 @param date 选中的经期开始日
 @param cycleDay 经期间隔天数
 @param periodLength 经期持续天数
 @return 各个排卵期
 */
+ (NSArray<NSString *> *)vp_GetOvulationWithDate:(NSDate *)date CycleDay:(NSInteger)cycleDay PeriodLength:(NSInteger)periodLength;


@end
