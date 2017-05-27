//
//  WChildViewController.m
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WChildViewController.h"
#import "WHealthDataManager.h"
#import "WBaseChart.h"
#import "WUserModel.h"
#import "WChartFactory.h"
#import "WAllDataViewController.h"
static CGFloat const animationDuration = 1.f;
static CGFloat const barChartLineWidth = 8.f;
static CGFloat const lineChartLineWidth = 6.f;

#define kLabelFont [UIFont systemFontOfSize:18.f]

typedef void(^WAllDataBlock)(NSArray *datas);

@interface WChildViewController () {
    CGFloat _lastWeight;
}

@property (nonatomic, strong) UISegmentedControl *segmented;
@property (nonatomic, strong) WHealthDataManager *healthManager;
@property (nonatomic, strong) WBaseChart *barChart;
@property (nonatomic, strong) UILabel *aver;
@property (nonatomic, strong) UILabel *total;
@property (nonatomic, strong) NSMutableArray *dataCache;
@property (nonatomic, strong) NSMutableArray *dateCache;
@property (nonatomic, strong) NSMutableArray *dateXCache;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) WMotionType motionType;
@property (nonatomic, strong) WUserModel *userModel;

@end

@implementation WChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据
    [self dateCache];
    [self dateXCache];
    [self setupSegmented];
    [self dataOperationWithIndex:0];
    [self setChartView];
    [self setAllDataButton];
    [self label];
    
    // 请求权限
    __weak typeof(self) weakSelf = self;
    [self.healthManager getAuthorizationWithHandle:^(BOOL isSuccess) {
        weakSelf.isSuccess = isSuccess;
        [weakSelf dataOperationWithIndex:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initalize
- (void)setChartView {
    [self.barChart drawChart];
    [self.view addSubview:self.barChart];
    
    [self.barChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.width.mas_equalTo(kScreenW - 50);
        make.height.mas_equalTo(kScreenH / 2);
    }];
}

#pragma mark - Set All Data Button
- (void)setAllDataButton {
    UIButton *allDataButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [allDataButton setTitle:@"显示所有数据" forState:UIControlStateNormal];
    [allDataButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    allDataButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [allDataButton addTarget:self action:@selector(allDataButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allDataButton];
    
    [allDataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
}

#pragma mark - Set Label
- (void)label {
    UILabel *averLabel = [[UILabel alloc] init];
    averLabel.font = kLabelFont;
    averLabel.text = @"平均值:";
    if (self.motionType == WWeightType) {
        averLabel.text = @"最新值:";
    }
    averLabel.textColor = [UIColor textColor];
    [self.view addSubview:averLabel];
    [averLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kScreenH / 10.0);
        make.left.equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.font = kLabelFont;
    totalLabel.text = self.unitStr;
    totalLabel.textColor = [UIColor textColor];
    [self.view addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(averLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(24);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.aver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(averLabel.mas_right).offset(20);
        make.top.equalTo(averLabel.mas_top);
        make.width.mas_equalTo(kScreenW / 3 * 2);
        make.height.mas_equalTo(30);
    }];
    
    [self.total mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totalLabel.mas_right).offset(20);
        make.top.equalTo(totalLabel.mas_top);
        make.width.mas_equalTo(kScreenW / 3 * 2);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma mark - Set segmented
- (void)setupSegmented {
    NSArray *segArray = @[@"日", @"周", @"月", @"年"];
    self.segmented = [[UISegmentedControl alloc] initWithItems:segArray];
    self.segmented.selectedSegmentIndex = 0;
    self.segmented.tintColor = [UIColor mainColor];
    [self.segmented addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmented];
    
    [self.segmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW-20);
        make.left.mas_equalTo(10);
        make.top.equalTo(self.view.mas_top).offset(3);
        make.height.mas_equalTo(29);
    }];
    
}

#pragma mark - 切换视图方法
- (void)changeView:(UISegmentedControl *)segment {
    int index = 0;
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.barChart.unit = WUnitDay;
            self.barChart.heightXDatas = self.dateXCache[0];
            self.barChart.dataXArray = self.dateCache[0];
            self.barChart.dataArray = [self.dataCache objectAtIndex:0];
            index = 0;
            break;
        case 1:
            self.barChart.unit = WUnitWeak;
            self.barChart.heightXDatas = self.dateXCache[1];
            self.barChart.dataXArray = self.dateCache[1];
            self.barChart.dataArray = [self.dataCache objectAtIndex:1];
            index = 1;
            break;
        case 2:
            self.barChart.unit = WUnitMonth;
            self.barChart.heightXDatas = self.dateXCache[2];
            self.barChart.dataXArray = self.dateCache[2];
            self.barChart.dataArray = [self.dataCache objectAtIndex:2];
            index = 2;
            break;
        case 3:
            self.barChart.unit = WUnitYear;
            self.barChart.heightXDatas = self.dateXCache[3];
            self.barChart.dataXArray = self.dateCache[3];
            self.barChart.dataArray = [self.dataCache objectAtIndex:3];
            index = 3;
            break;
            
        default:
            break;
    }
    
    if ([self.barChart.dataArray isEqualToArray:@[@"0"]]) {
        [self dataOperationWithIndex:index];
    } else {
        [self.barChart removeFromSuperview];
        NSArray *array = [self getAverAndTotalWithArray:self.barChart.dataArray];
        self.aver.text = [NSString stringWithFormat:@"%.0f %@", [array[1] doubleValue], self.unit];
        self.total.text = [NSString stringWithFormat:@"%.0f %@", [array[0] doubleValue], self.unit];
        if (self.motionType == WDistanceType || self.motionType == WEnergyType) {
            self.aver.text = [NSString stringWithFormat:@"%.1f %@", [array[1] doubleValue] / 1000, self.unit];
            self.total.text = [NSString stringWithFormat:@"%.1f %@", [array[0] doubleValue] / 1000, self.unit];
        } else if (self.motionType == WWeightType) {
            self.aver.text = [NSString stringWithFormat:@"%.1f %@", _lastWeight, self.unit];
            self.total.text = [NSString stringWithFormat:@"%.1f", _lastWeight / pow([self.userModel.height doubleValue] / 100, 2)];
            if (index == 0) {
                self.aver.text = [NSString stringWithFormat:@"0.0 %@", self.unit];
                self.total.text = @"0.0";
            }
        }
        [self setChartView];
    }
}

#pragma mark - All Data Button Action
- (void)allDataButtonAction:(UIButton *)button {
    [SVProgressHUD showWithStatus:@"请稍后~"];
    [self getAllDataWithMotionType:self.motionType handle:^(NSArray *datas) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            WAllDataViewController *allDataVC = [[WAllDataViewController alloc] init];
            allDataVC.title = self.title;
            allDataVC.unit = self.unit;
            allDataVC.dataArray = datas;
            allDataVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:allDataVC animated:YES];
        });
    }];
}

#pragma mark - Get Date
- (NSArray *)getDateWithIndex:(NSInteger)index {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:flags fromDate:nowDate];
    NSInteger hour = dateComponents.hour;
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    NSInteger dayTime = 86400 - (hour * 3600 + minute * 60 + second);
    NSDate *nowDay = nil;
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:dayTime];
    
    switch (index) {
        case 0:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400];
            break;
        case 1:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 7];
            break;
        case 2:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 30];
            break;
        case 3:
            nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 30 * 11];
            break;
        default:
            break;
    }
    
    return @[nowDay, nextDay];
}

#pragma mark - Get Aver
- (NSArray *)getAverAndTotalWithArray:(NSArray *)array {
    NSInteger sum = 0;
    for (NSString *obj in array) {
        sum += [obj integerValue];
    }
    NSInteger aver = sum / array.count;
    
    return @[@(sum), @(aver)];
}

#pragma mark - Data Operation
- (void)dataOperationWithIndex:(NSInteger)index {
    if (!self.isSuccess) {
        return ;
    }
    if ([self.title isEqualToString:@"步数"]) {
        [self getMotionDataWithtype:index motionType:self.motionType];
    } else if ([self.title isEqualToString:@"体重"]) {
        [self getMotionDataWithtype:index motionType:self.motionType];
    } else if ([self.title isEqualToString:@"公里"]) {
        [self getMotionDataWithtype:index motionType:self.motionType];
    }else if ([self.title isEqualToString:@"楼层"]) {
        [self getMotionDataWithtype:index motionType:self.motionType];
    } else if ([self.title isEqualToString:@"卡路里"]) {
        [self getMotionDataWithtype:index motionType:self.motionType];
    }
    
}

- (void)getMotionDataWithtype:(NSInteger)index motionType:(WMotionType)motionType {
    NSMutableArray *barData = [NSMutableArray array];
    NSArray *dates = [self getDateWithIndex:index];
    NSArray *cacheDate = self.dateCache[index];
    int countX = 0;
    if (index == 0) {
        countX = 24;
    } else if (index == 1) {
        countX = 7;
    } else if (index == 2) {
        countX = 30;
    } else {
        countX = 12;
    }
    [self.healthManager getHealthCountFromDate:dates[0] toDate:dates[1] type:index motionType:motionType resultHandle:^(NSArray *datas, double mintue) {
        if (dates != nil) {
            int count = 0;
            for (int index = 0; index < countX; index++) {
                if (count >= datas.count) {
                    [barData addObject:@"0"];
                    continue;
                }
                
                NSNumber *value = [datas[count] objectForKey:cacheDate[index]];
                if (value == nil) {
                    [barData addObject:@"0"];
                } else {
                    [barData addObject:[NSString stringWithFormat:@"%@", value]];
                    _lastWeight = [value doubleValue];
                    count++;
                }
            }
        } else {
            [barData addObject:@"0"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.barChart removeFromSuperview];
            NSArray *array = [self getAverAndTotalWithArray:barData];
            self.barChart.dataArray = barData;
            self.aver.text = [NSString stringWithFormat:@"%.0f %@", [array[1] doubleValue], self.unit];
            self.total.text = [NSString stringWithFormat:@"%.0f %@", [array[0] doubleValue], self.unit];
            if (motionType == WDistanceType || motionType == WEnergyType) {
                self.aver.text = [NSString stringWithFormat:@"%.1f %@", [array[1] doubleValue] / 1000, self.unit];
                self.total.text = [NSString stringWithFormat:@"%.1f %@", [array[0] doubleValue] / 1000, self.unit];
            } else if (motionType == WWeightType) {
                self.aver.text = [NSString stringWithFormat:@"%.1f %@", _lastWeight, self.unit];
                self.total.text = [NSString stringWithFormat:@"%.1f", _lastWeight / pow([self.userModel.height doubleValue] / 100, 2)];
            }
            [self.dataCache replaceObjectAtIndex:index withObject:barData];
            [self setChartView];
        });
    }];
}

- (void)getAllDataWithMotionType:(WMotionType)motionType handle:(WAllDataBlock)handle  {
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:flags fromDate:nowDate];
    NSInteger hour = dateComponents.hour;
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    NSInteger dayTime = 86400 - (hour * 3600 + minute * 60 + second);
    NSDate *nowDay = nowDay = [NSDate dateWithTimeIntervalSinceNow:dayTime - 86400 * 365 * 3];
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow:dayTime];
    
    [self.healthManager getHealthCountFromDate:nowDay toDate:nextDay type:4 motionType:motionType resultHandle:^(NSArray *datas, double mintue) {
        handle(datas);
    }];
}

- (NSArray *)getDateCacheWithIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSArray *dates = [self getDateWithIndex:index];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *startDate = dates[0];
    if (index == 0) {
        formatter.dateFormat = @"HH";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 23; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitHour value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    } else if (index == 1) {
        formatter.dateFormat = @"dd";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 6; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    } else if (index == 2) {
        formatter.dateFormat = @"dd";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 29; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    } else {
        formatter.dateFormat = @"yyyy/MM";
        [array addObject:[formatter stringFromDate:startDate]];
        for (int index = 0; index < 11; index++) {
            startDate = [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:startDate options:0];
            [array addObject:[formatter stringFromDate:startDate]];
        }
    }
    return array;
}

- (NSArray *)getDateXCacheWithIndex:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    NSArray *dates = [self getDateCacheWithIndex:index];
    if (index == 0) {
        array = [NSMutableArray arrayWithArray:@[@"上午", @"中午12时", @"下午"]];
    } else if (index == 1) {
        for (NSString *obj in dates) {
            NSInteger time = [obj integerValue];
            [array addObject:[NSString stringWithFormat:@"%ld日", (long)time]];
        }
    } else if (index == 2) {
        for (int index = 1; index < 6; index++) {
            NSInteger time = [dates[index * 6 - 1] integerValue];
            [array addObject:[NSString stringWithFormat:@"%ld日", (long)time]];
        }
    } else {
        for (int index = 1; index < 5; index++) {
            [array addObject:dates[index * 3 - 1]];
        }
    }
    return array;
}

#pragma mark - Lazy Load
- (UILabel *)aver {
    if (!_aver) {
        _aver = [[UILabel alloc] init];
        _aver.font = kLabelFont;
        _aver.text = [NSString stringWithFormat:@"0 %@", self.unit];
        _aver.textColor = [UIColor mainColor];
        [self.view addSubview:_aver];
    }
    return _aver;
}

- (UILabel *)total {
    if (!_total) {
        _total = [[UILabel alloc] init];
        _total.font = kLabelFont;
        _total.text = [NSString stringWithFormat:@"0 %@", self.unit];
        _total.textColor = [UIColor mainColor];
        [self.view addSubview:_total];
    }
    return _total;
}

- (WHealthDataManager *)healthManager {
    if (!_healthManager) {
        _healthManager = [[WHealthDataManager alloc] init];
    }
    return _healthManager;
}

- (WBaseChart *)barChart {
    if (!_barChart) {
        if (self.chartType == WAChartBar) {
            _barChart = [WChartFactory chartsFactory:WChartColumnar];
            _barChart.lineWidth = barChartLineWidth;
        } else {
            _barChart = [WChartFactory chartsFactory:WChartLine];
            _barChart.lineWidth = lineChartLineWidth;
        }
        _barChart.bounds = CGRectMake(0, 0, kScreenW - 50, kScreenH / 2);
        _barChart.hasShowValue = YES;
        _barChart.animationDuration = animationDuration;
        _barChart.showAllDashLine = NO;
        _barChart.unit = WUnitDay;
        _barChart.dataXArray = self.dateCache[0];
        _barChart.heightXDatas = self.dateXCache[0];
    }
    return _barChart;
}

- (NSMutableArray *)dataCache {
    if (!_dataCache) {
        _dataCache = [NSMutableArray arrayWithArray:@[@[@"0"], @[@"0"], @[@"0"], @[@"0"]]];
    }
    return _dataCache;
}

- (NSMutableArray *)dateCache {
    if (!_dateCache) {
        _dateCache = [NSMutableArray arrayWithArray:@[[self getDateCacheWithIndex:0],
                                                      [self getDateCacheWithIndex:1],
                                                      [self getDateCacheWithIndex:2],
                                                      [self getDateCacheWithIndex:3]]];
    }
    return _dateCache;
}

- (NSMutableArray *)dateXCache {
    if (!_dateXCache) {
        _dateXCache = [NSMutableArray arrayWithArray:@[[self getDateXCacheWithIndex:0],
                                                       [self getDateXCacheWithIndex:1],
                                                       [self getDateXCacheWithIndex:2],
                                                       [self getDateXCacheWithIndex:3]]];
    }
    return _dateXCache;
}

- (WUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[WUserModel alloc] init];
        [_userModel loadData];
    }
    return _userModel;
}

- (WMotionType)motionType {
    if (!_motionType) {
        if ([self.title isEqualToString:@"步数"]) {
            _motionType = WStepType;
        } else if ([self.title isEqualToString:@"体重"]) {
            _motionType = WWeightType;
        } else if ([self.title isEqualToString:@"公里"]) {
            _motionType = WDistanceType;
        }else if ([self.title isEqualToString:@"楼层"]) {
            _motionType = WClimbedType;
        } else if ([self.title isEqualToString:@"卡路里"]) {
            _motionType = WEnergyType;
        }
    }
    return _motionType;
}


@end
