//
//  NSDate+WExtension.h
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WExtension)
+ (NSString *)getCurrentDate;
+ (NSString *)getCurrentTime;
+ (NSString *)getCurrentDateWithFormatter:(NSString *)formatter;
+ (NSString *)getDate:(NSDate *)date withFormatter:(NSString *)formatter;

+ (NSDate *)getDateFromString:(NSString *)dateStr;
+ (NSDate *)getDateFromString:(NSString *)dateStr withFormatter:(NSString *)formatter;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;
@end
