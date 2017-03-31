//
//  NSDate+WExtension.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "NSDate+WExtension.h"

@implementation NSDate (WExtension)
#pragma mark - Date To String
+ (NSString *)getCurrentDate {
    return [self getCurrentDateWithFormatter:@"yyyy年MM月dd日"];
}

+ (NSString *)getCurrentTime {
    return [self getCurrentDateWithFormatter:@"HH:mm:ss"];
}

+ (NSString *)getCurrentDateWithFormatter:(NSString *)formatter {
    NSDate *currentDate = [NSDate date];
    return [self getDate:currentDate withFormatter:formatter];
}

+ (NSString *)getDate:(NSDate *)date withFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月";
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    return [formatter dateFromString:string];
}

#pragma mark - String To Date
+ (NSDate *)getDateFromString:(NSString *)dateStr {
    return [self getDateFromString:dateStr withFormatter:@"yyyy年MM月dd日 HH:mm:ss"];
}

+ (NSDate *)getDateFromString:(NSString *)dateStr withFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter dateFromString:dateStr];
}
@end
