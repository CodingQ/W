//
//  WHealthDateManager.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WHealthDateManager.h"
#import <HealthKit/HealthKit.h>


@interface WHealthDateManager ()

@property (nonatomic, strong) HKHealthStore *healthStore;

@end

@implementation WHealthDateManager

- (instancetype)init {
    self = [super init];
    if (self) {
        if (![HKHealthStore isHealthDataAvailable]) {
            NSLog(@"设备不支持healthKit");
        }
        
        self.healthStore = [[HKHealthStore alloc] init];
    }
    return self;
}

#pragma mark - Get Authorization
- (void)getAuthorizationWithHandle:(WAuthorizationResult)handle {
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKObjectType *weightCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKObjectType *disCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKObjectType *flightsClimbedCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    HKObjectType *energyCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    NSSet *healthSet = [NSSet setWithObjects:stepCount, weightCount, disCount, flightsClimbedCount, energyCount, nil];
    
    NSSet *writeSet = [NSSet setWithObjects:weightCount, energyCount, nil];
    
    //从健康中获取权限
    [self.healthStore requestAuthorizationToShareTypes:writeSet readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        handle(success);
    }];
}

#pragma mark - Motion Data
//- (void)getHealthCountFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate type:(WDateType)type
//                    motionType:(WMotionType)motionType resultHandle:(WDataBlock)handle {
//    [self self_getHealthCountFromDate:fromDate toDate:toDate type:type motionType:motionType resultHandle:handle];
//}

- (void)getHealthCountFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate type:(WDateType)type
                      motionType:(WMotionType)motionType resultHandle:(WDataBlock)handle{
    HKSampleType *motion = [self getMotionWithType:motionType];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:fromDate endDate:toDate options:HKQueryOptionNone];
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:motion predicate:predicate limit:ULONG_MAX sortDescriptors:nil resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (results.count > 0) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            if (type == WDateDayType) {
                dateFormatter.dateFormat = @"yyyy-MM-dd HH";
            } else if (type == WDateWeekType || type == WDateMonthType || type == WDateNoneType) {
                dateFormatter.dateFormat = @"yyyy-MM-dd";
            } else {
                dateFormatter.dateFormat = @"yyyy-MM";
            }
            
            double count = 0;
            double mintue = 0;
            NSString *pre = [dateFormatter stringFromDate:[results firstObject].startDate];
            NSMutableArray *array = [NSMutableArray array];
            
            double allCount = 0;
            for (int index = 0; index < results.count;) {
                HKQuantitySample *obj = results[index];
                HKQuantity *quantity = obj.quantity;
                NSString *stepStr = [NSString stringWithFormat:@"%@", quantity];
                NSString *stepCount = [[stepStr componentsSeparatedByString:@" "] firstObject];
                mintue += [self getActivityTimeWithFirstTime:obj.startDate secondTime:obj.endDate];
                if ([pre isEqualToString:[dateFormatter stringFromDate:obj.startDate]]) {
                    count += [stepStr doubleValue];
                    if (motionType == WWeightType) {
                        count = [stepStr doubleValue];
                    }
                    index++;
                } else {
                    if (type == WDateDayType) {
                        [array addObject:@{[[pre componentsSeparatedByString:@" "] lastObject] : @(count)}];
                    } else if(type == WDateWeekType || type == WDateMonthType) {
                        NSString *tempStr = [[pre componentsSeparatedByString:@" "] firstObject];
                        [array addObject:@{[[tempStr componentsSeparatedByString:@"-"] lastObject] : @(count)}];
                    } else if(type == WDateYearType) {
                        NSString *tempStr = [[pre componentsSeparatedByString:@" "] firstObject];
                        NSArray *keys = [tempStr componentsSeparatedByString:@"-"];
                        NSString *keyStr = [NSString stringWithFormat:@"%@/%@", keys[0], keys[1]];
                        [array addObject:@{keyStr : @(count)}];
                    } else {
                        [array addObject:@{@"date" : [[pre componentsSeparatedByString:@" "] firstObject],
                                           @"value" : @(count)}];
                    }
                    
                    pre = [dateFormatter stringFromDate:obj.startDate];
                    count = 0;
                }
                
                allCount += [stepCount doubleValue];
            }
            
            if (type == WDateDayType) {
                [array addObject:@{[[pre componentsSeparatedByString:@" "] lastObject] : @(count)}];
            } else if(type == WDateWeekType || type == WDateMonthType) {
                NSString *tempStr = [[pre componentsSeparatedByString:@" "] firstObject];
                [array addObject:@{[[tempStr componentsSeparatedByString:@"-"] lastObject] : @(count)}];
            } else if(type == WDateYearType) {
                NSString *tempStr = [[pre componentsSeparatedByString:@" "] firstObject];
                NSArray *keys = [tempStr componentsSeparatedByString:@"-"];
                NSString *keyStr = [NSString stringWithFormat:@"%@/%@", keys[0], keys[1]];
                [array addObject:@{keyStr : @(count)}];
            } else {
                [array addObject:@{@"date" : [[pre componentsSeparatedByString:@" "] firstObject],
                                   @"value" : @(count)}];
            }
            
            handle(array, mintue);
        } else {
            handle(nil, 0);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (HKSampleType *)getMotionWithType:(WMotionType)type {
    HKSampleType *motion = nil;
    switch (type) {
        case WStepType:
            motion = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            break;
        case WDistanceType:
            motion = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
            break;
        case WClimbedType:
            motion = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
            break;
        case WEnergyType:
            motion = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
            break;
        case WWeightType:
            motion = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
            break;
        default:
            break;
    }
    return motion;
}

- (CGFloat)getActivityTimeWithFirstTime:(NSDate *)firstDate secondTime:(NSDate *)secondDate {
    NSInteger second = [secondDate timeIntervalSinceDate:firstDate];
    double time = second / 60.0;
    
    return time;
}

#pragma mark - Save Data
- (void)saveWeightWithValue:(double)value withDate:(NSDate *)date handle:(WSaveDataBlock)block {
    HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantity      *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixKilo] doubleValue:value];
    
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType quantity:hkQuantity
                                                                    startDate:date endDate:date];
    
    [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (block != nil) {
            block(success, error);
        }
    }];
}

- (void)saveEnergyWithValue:(double)value handle:(WSaveDataBlock)block {
    NSDate          *now = [NSDate date];
    HKQuantityType  *hkQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantity      *hkQuantity = [HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:value];
    
    HKQuantitySample *weightSample = [HKQuantitySample quantitySampleWithType:hkQuantityType quantity:hkQuantity
                                                                    startDate:now endDate:now];
    
    [self.healthStore saveObject:weightSample withCompletion:^(BOOL success, NSError * _Nullable error) {
        if (block != nil) {
            block(success, error);
        }
    }];
}

@end
