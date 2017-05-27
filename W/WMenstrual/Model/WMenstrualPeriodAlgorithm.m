//
//  WMenstrualPeriodAlgorithm.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WMenstrualPeriodAlgorithm.h"
@implementation WMenstrualPeriodAlgorithm
// 用来计算多少个经期
static NSInteger const MenstrualCycleTimes = 18;

// 当前经期
+ (NSArray<NSString *> *)vp_GetCurrentMenstrualPeriodWithDate:(NSDate *)date PeriodLength:(NSInteger)periodLength{
    NSMutableArray *array = [NSMutableArray array];
    if (periodLength == 0 || date == nil) {
        return nil;
    }
    // 公历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    // 当前月经期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (NSInteger i = 0; i < periodLength; i ++)
    {
        NSDate *nextDate = [gregorian dateByAddingUnit:NSCalendarUnitDay
                                                 value:i
                                                toDate:date
                                               options:0];
        NSString *string = [dateFormatter stringFromDate:nextDate];
        if (![array containsObject:string])
        {
            [array addObject:string];
        }
    }
    return [array copy];
}


// 经期
+ (NSArray<NSString *> *)vp_GetMenstrualPeriodWithDate:(NSDate *)date CycleDay:(NSInteger)cycleDay PeriodLength:(NSInteger)periodLength
{
    NSMutableArray *array = [NSMutableArray array];
    if (cycleDay == 0 || periodLength == 0 || date == nil) {
        return nil;
    }
    // 公历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    // 当前月经期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (NSInteger j = 0; j < MenstrualCycleTimes; j ++)
    {
        for (NSInteger i = 0; i < periodLength; i ++)
        {
            NSInteger nextPeriod = j * cycleDay;
            NSDate *nextDate = [gregorian dateByAddingUnit:NSCalendarUnitDay
                                                     value:i + nextPeriod
                                                    toDate:date
                                                   options:0];
            NSString *string = [dateFormatter stringFromDate:nextDate];
            if (![array containsObject:string])
            {
                [array addObject:string];
            }
        }
    }
    
    return [array copy];
}


// 排卵日
+ (NSArray<NSString *> *)vp_GetOvulationDayWithDate:(NSDate *)date CycleDay:(NSInteger)cycleDay PeriodLength:(NSInteger)periodLength
{
    NSMutableArray *array = [NSMutableArray array];
    // 公历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (NSInteger j = 1; j <= MenstrualCycleTimes; j ++)
    {
        NSInteger nextPeriod = j * cycleDay;
        
        NSDate *nextDate = [gregorian dateByAddingUnit:NSCalendarUnitDay
                                                 value:nextPeriod
                                                toDate:date
                                               options:0];
        NSDate *ovulationDay = [gregorian dateByAddingUnit:NSCalendarUnitDay
                                                     value:- 14
                                                    toDate:nextDate
                                                   options:0];
        
        NSString *string = [dateFormatter stringFromDate:ovulationDay];
        if (![array containsObject:string])
        {
            [array addObject:string];
        }
    }
    
    return [array copy];
}

// 排卵期
+ (NSArray<NSString *> *)vp_GetOvulationWithDate:(NSDate *)date CycleDay:(NSInteger)cycleDay PeriodLength:(NSInteger)periodLength
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *ovulationDayArray = [WMenstrualPeriodAlgorithm vp_GetOvulationDayWithDate:date CycleDay:cycleDay PeriodLength:periodLength];
    
    if (cycleDay == 0 || periodLength == 0 ||
        date == nil || ovulationDayArray.count == 0)
    {
        return nil;
    }
    
    // 公历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    gregorian.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for (NSInteger j = 0; j < ovulationDayArray.count; j ++)
    {
        NSString *ovulationDayString = ovulationDayArray[j];
        NSDate *ovulationDay = [dateFormatter dateFromString:ovulationDayString];
        // 前5后4+当天
        for (NSInteger i = -5; i < 5; i ++)
        {
            NSDate *nextDate = [gregorian dateByAddingUnit:NSCalendarUnitDay
                                                     value:i
                                                    toDate:ovulationDay
                                                   options:0];
            
            NSString *string = [dateFormatter stringFromDate:nextDate];
            if (![array containsObject:string])
            {
                [array addObject:string];
            }
        }
    }
    
    return [array copy];
}

@end
