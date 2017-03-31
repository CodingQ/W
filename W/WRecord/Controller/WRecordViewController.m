//
//  WRecordViewController.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WRecordViewController.h"
#import "WRecordCircleView.h"
#import "WRecordCategoryView.h"
#import <CoreMotion/CoreMotion.h>
#import "WBaseChart.h"
#import "WUserModel.h"
#import "WHealthDataManager.h"
#import "WChartFactory.h"
#import "WCalendarViewController.h"
#import "WCalendarVC.h"


static CGFloat const animationDuration = 1.f;

@interface WRecordViewController () {
    NSArray *_descs;
    NSArray *_colors;
    NSString *_stepCount;
    NSDate  *_stepDate;
    CGFloat _activityTime;
    CGFloat _oriEnergy;
    NSInteger  _count;
    NSMutableArray *_barDatas;
    BOOL _isInWeek;
    double _stepSum;
    double _energySum;
    double _disSum;
}

@property (nonatomic, strong) WRecordCircleView *circleView;
@property (nonatomic, strong) WBaseChart *barChart;

@property (nonatomic, strong) WHealthDataManager *healthManager;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) WUserModel *userModel;
@property (nonatomic, strong) CMPedometer *cmPedometer;
@property (nonatomic, strong) WRecordCategoryView *kcalLabel;
@property (nonatomic, strong) WRecordCategoryView *timeLabel;
@property (nonatomic, strong) WRecordCategoryView *disLabel;
@property (nonatomic, assign) BOOL isSuccess;

@end

@implementation WRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessage) name:Notice_Run object:nil];
    
    [self initilaze];
    [self setNavigation];
    [self drawCircle];
    [self addMessageText];
    [self addBarChart];
    [self setBarDataWithNowDate:[NSDate date] isChange:NO];
//    [self addButton];
    
    if (![CMPedometer isStepCountingAvailable] || ![CMPedometer isDistanceAvailable] || ![CMPedometer isPaceAvailable]) {
        NSLog(@"CMPedometer Error");
    }
    
    __weak typeof(self) weakSelf = self;
    [self.healthManager getAuthorizationWithHandle:^(BOOL isSuccess) {
        NSDate *current = [NSDate getDateFromString:[NSDate getCurrentDate] withFormatter:@"yyyy年MM月dd日"];
        weakSelf.isSuccess = isSuccess;
        [weakSelf setBarDataWithNowDate:current isChange:NO];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popOverWithRow:) name:Notice_Run object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_Run object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Init
- (void)initilaze {
    [self.userModel loadData];
    _count = 0;
    _stepCount = @"0";
    _descs = @[@"千卡", @"活跃时间(分)", @"公里"];
    _colors = @[[UIColor colorWithRed:234 / 255.0 green:98 / 255.0 blue:86 / 255.0 alpha:1],
                [UIColor colorWithRed:245 / 255.0 green:166 / 255.0 blue:35 / 255.0 alpha:1],
                [UIColor mainColor]];
    self.healthManager = [[WHealthDataManager alloc] init];
}

#pragma mark - Navigation Item
- (void)setNavigation {
    //单独设置Navigation的title
    self.navigationItem.title = [NSDate getCurrentDate];
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"]
//                                                                   style:UIBarButtonItemStyleDone
//                                                                  target:self
//                                                                  action:@selector(leftBarItemAction:)];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc] initWithTitle:@"日历" style:UIBarButtonItemStyleDone target:self action:@selector(leftBarItemAction:)];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"round_add"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(rightBarItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - Draw Circle
- (void)drawCircle {
    self.circleView = [[WRecordCircleView alloc] initWithFrame:CGRectMake(kScreenW / 2.0 - kScreenW / 4.2, kScreenH / 16.0,
                                                                      kScreenW / 2.1, kScreenW / 2.1)];
    self.circleView.totalStep = [self.userModel.tag integerValue];
    self.circleView.animationDuration = animationDuration;
    self.circleView.nowStep = @"0";
    [self.view addSubview:self.circleView];
}

#pragma mark - Add MessageText
- (void)addMessageText {
    self.kcalLabel = [self getRecordCategoryView];
    self.kcalLabel.title = _descs[0];
    self.kcalLabel.mainTitleColor = _colors[0];
    [self.view addSubview:self.kcalLabel];
    
    [self.kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(kScreenW / 3.0 * (0 % 3));
        make.width.mas_equalTo(kScreenW / 3.0);
        make.height.mas_equalTo(kScreenH / 10.0);
    }];
    
    self.timeLabel = [self getRecordCategoryView];
    self.timeLabel.title = _descs[1];
    
    self.timeLabel.mainTitleColor = _colors[1];
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_left).offset(kScreenW / 3.0 * (1 % 3));
        make.width.mas_equalTo(kScreenW / 3.0);
        make.height.mas_equalTo(kScreenH / 10.0);
    }];
    
    self.disLabel = [self getRecordCategoryView];
    self.disLabel.title = _descs[2];
    self.disLabel.mainTitleColor = _colors[2];
    self.disLabel.format = @"%.1f";
    [self.view addSubview:self.disLabel];
    
    [self.disLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.circleView.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_left).offset(kScreenW / 3.0 * (2 % 3));
        make.width.mas_equalTo(kScreenW / 3.0);
        make.height.mas_equalTo(kScreenH / 10.0);
    }];
    
    [self startUpdateCount];
    
}

#pragma mark - SetBarChart
- (void)addBarChart {
    self.barChart = [WChartFactory chartsFactory:WChartColumnar];
    self.barChart.bounds = CGRectMake(0, 0, kScreenW - 50, kScreenH / 5);
    self.barChart.animationDuration = animationDuration;
    self.barChart.lineWidth = 2.f;
    //设置柱型的渐变颜色组
    self.barChart.backgroundColors = @[(__bridge id)[UIColor colorWithRed:34 / 255.0 green:231 / 255.0 blue:248 / 255.0 alpha:1].CGColor,
                                       (__bridge id)[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1].CGColor];
    //设置虚线颜色
    self.barChart.dashLineColor = [UIColor colorWithRed:230 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:0.6];
    self.barChart.lineColor = [UIColor mainColor];
    self.barChart.labelColor = [UIColor lightGrayColor];
    //不使用所有的虚线
    self.barChart.showAllDashLine = NO;
    self.barChart.unit = WUnitDay;
    self.barChart.heightXDatas = @[@"上午12时", @"下午12时", @"上午12时"];
    self.barChart.dataArray = _barDatas;
    
    [self.barChart drawChart];
    [self.view addSubview:self.barChart];
    
    [self.barChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_bottom).offset(45 + kScreenH / 10.0);
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.width.mas_equalTo(kScreenW - 50);
        make.height.mas_equalTo(kScreenH / 5);
    }];
}

#pragma mark - addButton
- (void)addButton {
    UIButton *shotScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shotScreenButton setTitle:@"SHARE" forState:UIControlStateNormal];
    shotScreenButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    [shotScreenButton setTitleColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1] forState:UIControlStateNormal];
    
    [shotScreenButton addTarget:self action:@selector(shotScreenButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shotScreenButton];
    
    CGFloat offset = (kScreenH - 48 - (45 + kScreenH / 10.0 * 3 + kScreenW / 2.1 + kScreenH / 16.0) - 64) / 2.0;
    CGFloat originY = offset + 45 + kScreenH / 10.0 * 3 - 12.5;
    
    [shotScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_bottom).offset(originY);
        make.left.equalTo(self.view.mas_left).offset(kScreenW / 4.0 - kScreenW / 10.0);
        make.width.mas_equalTo(kScreenW / 5.0);
        make.height.mas_equalTo(25);
    }];
    
    UIButton *runButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [runButton setTitle:@"RUN" forState:UIControlStateNormal];
    runButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    [runButton setTitleColor:[UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1] forState:UIControlStateNormal];
    [runButton addTarget:self action:@selector(runButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:runButton];
    
    [runButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleView.mas_bottom).offset(originY);
        make.right.equalTo(self.view.mas_right).offset(-(kScreenW / 4.0 - kScreenW / 10.0));
        make.width.mas_equalTo(kScreenW / 5.0);
        make.height.mas_equalTo(25);
    }];
}

#pragma mark - Start Update Count
- (void)startUpdateCount {
    // 启动计步
    [self.cmPedometer startPedometerUpdatesFromDate:[self stepDate] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_count == 0) {
                _oriEnergy = [self.userModel.weight doubleValue] * ([pedometerData.distance doubleValue] / 1000) * 1.036;
                _activityTime = [pedometerData.averageActivePace doubleValue] / 60 * [pedometerData.distance doubleValue];
                _count++;
            }
            CGFloat time = [pedometerData.averageActivePace doubleValue] / 60 * [pedometerData.distance doubleValue];
            CGFloat timeValue = (time != _activityTime) ? time + _activityTime : time;
            _stepCount = [pedometerData.numberOfSteps stringValue];
            self.circleView.nowStep = [pedometerData.numberOfSteps stringValue];
            self.disLabel.mainTitle = [NSString stringWithFormat:@"%.1f", [pedometerData.distance doubleValue] / 1000];
            self.timeLabel.mainTitle = [NSString stringWithFormat:@"%.0f", timeValue];
            self.kcalLabel.mainTitle = [NSString stringWithFormat:@"%.0f", [self.userModel.weight doubleValue] *
                                        ([pedometerData.distance doubleValue] / 1000) * 1.036];
            //fixme:修复卡路里计算逻辑
            double value = [self.kcalLabel.mainTitle doubleValue] - _oriEnergy;
            if (value >0 ) {
                [self.healthManager saveEnergyWithValue:value handle:nil];
            }
            //            self.kcalLabel.mainTitle = [NSString stringWithFormat:@"%.0f", [self.userModel.weight doubleValue] * timeValue / 60 *
            //                                        (25 / (400 / ([pedometerData.distance doubleValue] / timeValue)))];
            //            self.kcalLabel.mainTitle = [NSString stringWithFormat:@"%.0f", 0.43 * [self.userModel.height doubleValue] +
            //                                        0.57 * [self.userModel.weight doubleValue] +
            //                                        0.26 * ([pedometerData.numberOfSteps doubleValue] / timeValue) +
            //                                        1.51 * timeValue - 108];
            
            
            [self.disLabel setLabelAnimation];
            [self.timeLabel setLabelAnimation];
            [self.kcalLabel setLabelAnimation];
        });
    }];
}

#pragma mark - Set Bar Data
- (void)setBarDataWithNowDate:(NSDate *)nowDate isChange:(BOOL)isChange {
    if (!self.isSuccess) {
        return ;
    }
    
    NSDate *nowDay = nowDate;
    NSDate *nextDay = [nowDate dateByAddingTimeInterval:86400];
    
    _barDatas = nil;
    _barDatas = [NSMutableArray array];
    
    [self getHealthData:WStepType fromDate:nowDay toDate:nextDay isChange:isChange];
    if (isChange) {
        [self getHealthData:WDistanceType fromDate:nowDay toDate:nextDay isChange:YES];
    }
    
}

#pragma mark - Get Health Data
- (void)getHealthData:(WMotionType)motionType fromDate:(NSDate *)nowDay toDate:(NSDate *)nextDay isChange:(BOOL)isChange {
    [self.healthManager getHealthCountFromDate:nowDay toDate:nextDay type:WDateDayType motionType:motionType resultHandle:^(NSArray *datas, double mintue) {
        double sum = 0;
        if (datas != nil) {
            if (motionType == WStepType) {
                for (int index = 0; index < 24; index++) {
                    [_barDatas addObject:@"0"];
                }
            }
            for (NSDictionary *obj in datas) {
                NSArray *keys = [obj allKeys];
                if (motionType == WStepType) {
                    NSInteger dataCount = [keys[0] integerValue];
                    [_barDatas replaceObjectAtIndex:dataCount withObject:[obj objectForKey:keys[0]]];
                }
                sum += [[obj objectForKey:keys[0]] doubleValue];
            }
            
        } else {
            if (motionType == WStepType) {
                [_barDatas addObject:@"0"];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isChange) {
                [self updateView:motionType sum:sum];
            }
            if (_isInWeek) {
                [self updateView:WStepType sum:sum];
            }
            if (motionType == WStepType && isChange) {
                self.timeLabel.mainTitle = [NSString stringWithFormat:@"%.0f", mintue];
                [self.timeLabel setLabelAnimation];
            }
            [self.barChart removeFromSuperview];
            [self addBarChart];
        });
    }];
}

#pragma mark - Update View
- (void)updateView:(WMotionType)motionType sum:(double)sum {
    switch (motionType) {
        case WStepType: {
            _stepSum = sum;
            self.circleView.nowStep = [NSString stringWithFormat:@"%.0f", _stepSum];
        }
            break;
        case WEnergyType: {
            _energySum = sum;
            
        }
            break;
        case WDistanceType: {
            _disSum = sum;
            self.disLabel.mainTitle = [NSString stringWithFormat:@"%.1f", _disSum / 1000];
            [self.disLabel setLabelAnimation];
            self.kcalLabel.mainTitle = [NSString stringWithFormat:@"%.0f", [self.userModel.weight doubleValue] *
                                        (_disSum / 1000) * 1.036];
            [self.kcalLabel setLabelAnimation];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Bar Item Action
- (void)leftBarItemAction:(UIBarButtonItem *)button {
//    WCalendarViewController *caleVC = [[WCalendarViewController alloc] init];
//    caleVC.currentDate = self.currentDate;
//    __weak typeof(self) weakSelf = self;
//    caleVC.calendarBlock = ^(NSString *dateMessage) {
//        weakSelf.navigationItem.title = dateMessage;
//        weakSelf.currentDate = [NSDate dateFromString:dateMessage];
//        [weakSelf changeDataWithDate:weakSelf.currentDate];
//    };
//    [self presentViewController:caleVC animated:YES completion:nil];
    
        WCalendarVC *caleVC = [[WCalendarVC alloc] init];
        caleVC.currentDate = self.currentDate;
        __weak typeof(self) weakSelf = self;
        caleVC.calendarBlock = ^(NSString *dateMessage) {
            weakSelf.navigationItem.title = dateMessage;
            NSDate *date = [NSDate dateFromString:dateMessage];
            weakSelf.currentDate = [NSDate dateFromString:dateMessage];
            [weakSelf changeDataWithDate:weakSelf.currentDate];
        };
        [self presentViewController:caleVC animated:YES completion:nil];
    

}

//- (void)rightBarItemAction:(UIBarButtonItem *)button {
//    RUNFuncViewController *funcVC = [[RUNFuncViewController alloc] init];
//    [self presentViewController:funcVC animated:YES completion:nil];
//}

#pragma mark - Button Action
- (void)shotScreenButton:(UIButton *)button {
//    RUNShareViewController *shareVC = [[RUNShareViewController alloc] init];
//    shareVC.imageData = [self run_getScreenShotWithSize:self.view.bounds.size view:self.view];
//    [self presentViewController:shareVC animated:YES completion:nil];
//}
//
//- (void)runButton:(UIButton *)button {
//    RUNMapViewController *mapVC = [[RUNMapViewController alloc] init];
//    mapVC.hidesBottomBarWhenPushed = YES;
//    mapVC.title = @"运动";
//    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - Change Data
- (void)changeDataWithDate:(NSDate *)nowDate {
    _isInWeek = NO;
    _count = 0;
    NSDate *current = [NSDate getDateFromString:[NSDate getCurrentDate] withFormatter:@"yyyy年MM月dd日"];
    NSDate *earlierWeakDate = [current dateByAddingTimeInterval:- 86400 * 7];
    if (![nowDate isEqualToDate:current]) {
        [self.cmPedometer stopPedometerUpdates];
        if ([[nowDate earlierDate:earlierWeakDate] isEqualToDate:earlierWeakDate]) {
            _isInWeek = YES;
            NSDate *toDate = [nowDate dateByAddingTimeInterval:86400];
            [self getStepCountFromDate:nowDate toDate:toDate isChange:NO];
        } else {
            [self setBarDataWithNowDate:nowDate isChange:YES];
        }
    } else {
        [self setBarDataWithNowDate:nowDate isChange:NO];
        [self startUpdateCount];
    }
}

#pragma mark - Get Step Count
- (void)getStepCountFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate isChange:(BOOL)isChange {
    [self.cmPedometer queryPedometerDataFromDate:fromDate toDate:toDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat timeValue = [pedometerData.averageActivePace doubleValue] / 60 * [pedometerData.distance doubleValue];
            self.disLabel.mainTitle = [NSString stringWithFormat:@"%.1f", [pedometerData.distance doubleValue] / 1000];
            self.timeLabel.mainTitle = [NSString stringWithFormat:@"%.0f", timeValue];
            self.kcalLabel.mainTitle = [NSString stringWithFormat:@"%.0f",[self.userModel.weight doubleValue] *
                                        ([pedometerData.distance doubleValue] / 1000) * 1.036];
            
            [self.disLabel setLabelAnimation];
            [self.timeLabel setLabelAnimation];
            [self.kcalLabel setLabelAnimation];
            [self setBarDataWithNowDate:fromDate isChange:NO];
        });
    }];
}

#pragma mark - NSNotification Action
- (void)popOverWithRow:(id)sender{
//    NSInteger row = [[[sender userInfo] objectForKey:@"row"] integerValue];
//    NSLog(@"%ld", (long)row);
//    if (row == 0) {
//        RUNMapViewController *mapVC = [[RUNMapViewController alloc] init];
//        mapVC.hidesBottomBarWhenPushed = YES;
//        mapVC.title = @"运动";
//        [self.navigationController pushViewController:mapVC animated:YES];
//    } else if (row == 2) {
//        RUNFAQViewController *faqVC = [[RUNFAQViewController alloc] init];
//        faqVC.title = @"帮助";
//        faqVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:faqVC animated:YES];
//    } else if (row == 1) {
//        RUNWeightViewController *weight = [[RUNWeightViewController alloc] init];
//        weight.title = @"录入体重";
//        weight.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:weight animated:YES];
//    }
}

- (void)refreshMessage {
    [self.userModel loadData];
    self.circleView.totalStep = [self.userModel.tag integerValue];
    self.circleView.nowStep = _stepCount;
    [self.cmPedometer stopPedometerUpdates];
    [self startUpdateCount];
}

#pragma mark - Lazy Method
- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [NSDate date];
    }
    return _currentDate;
}



- (WUserModel *)userModel {
    if (!_userModel) {
        _userModel = [[WUserModel alloc] init];
    }
    return _userModel;
}

- (NSDate *)stepDate {
    if (!_stepDate) {
        NSDate *toDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _stepDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];
    }
    return _stepDate;
}

- (CMPedometer *)cmPedometer {
    if (!_cmPedometer) {
        _cmPedometer = [[CMPedometer alloc] init];
    }
    return _cmPedometer;
}

- (WRecordCategoryView *)getRecordCategoryView {
    WRecordCategoryView *energyView = [[WRecordCategoryView alloc] initWithFrame:CGRectZero];
    energyView.mainTitle = @"0";
    energyView.mainTitleFont = [UIFont fontWithName:@"Helvetica" size:kScreenW / 14.f];
    energyView.titleFont = [UIFont systemFontOfSize:14.f];
    energyView.animationDuration = animationDuration;
    energyView.titleColor = [UIColor colorWithRed:158 / 255.0 green:158 / 255.0 blue:158 / 255.0 alpha:1];
    energyView.format = @"%d";
    
    return energyView;
}

@end
