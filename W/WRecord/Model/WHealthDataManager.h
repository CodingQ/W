//
//  WHealthDateManager.h
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^WAuthorizationResult)(BOOL isSuccess);
typedef void(^WSaveDataBlock)(BOOL isSuccess, NSError *error);
typedef void(^WDataBlock)(NSArray *datas, double mintue);

typedef enum : NSUInteger {
    WDateDayType = 0,
    WDateWeekType,
    WDateMonthType,
    WDateYearType,
    WDateNoneType
} WDateType;

typedef enum : NSUInteger {
    WStepType = 0,
    WDistanceType,
    WClimbedType,
    WWeightType,
    WEnergyType
} WMotionType;

@interface WHealthDataManager : NSObject

- (void)getAuthorizationWithHandle:(WAuthorizationResult)handle;

- (void)getHealthCountFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate type:(WDateType)type
                    motionType:(WMotionType)motionType resultHandle:(WDataBlock)handle;

- (void)saveWeightWithValue:(double)value withDate:(NSDate *)date handle:(WSaveDataBlock)block;
- (void)saveEnergyWithValue:(double)value handle:(WSaveDataBlock)block;
- (void)getMenstrualCycleStart;
@end
