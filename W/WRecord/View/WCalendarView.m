//
//  WCalendarView.m
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WCalendarView.h"
#import "WCalendarCollectionViewCell.h"
static NSString *const identifier = @"calendar";
static CGFloat  const animationDuration = 0.35f;

@interface WCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)   UICollectionView    *collectionView;
@property (nonatomic, strong)   NSCalendar          *calendar;
@property (nonatomic, copy)     NSArray             *weakTitles;
@property (nonatomic, strong)   UILabel             *showLabel;
@property (nonatomic, strong)   UIView              *headView;
@property (nonatomic, strong)   NSDate              *currentDate;
@property (nonatomic, strong)   NSDate              *selectedDate;

@end

@implementation WCalendarView

#pragma mark - Lazy Load
- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}

- (NSArray *)weakTitles {
    if (!_weakTitles) {
        _weakTitles = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    }
    return _weakTitles;
}

#pragma mark - Init Method
- (instancetype)initWithFrame:(CGRect)frame withCurrentDate:(NSDate *)currentDate {
    self = [super initWithFrame:frame];
    if (self) {
        _currentDate = currentDate;
        _selectedDate = currentDate;
        [self setupLabelAndButton];
        [self setupCollectionView];
    }
    return self;
}

#pragma mark - Set UI Method
- (void)setupLabelAndButton {
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.headView];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [preButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [preButton setTintColor:[UIColor mainColor]];
    [preButton addTarget:self action:@selector(preButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:preButton];
    
    [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.headView.mas_centerY);
        make.left.equalTo(self.headView.mas_left).offset(20);
        //
        make.width.height.mas_equalTo(20);
    }];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [nextButton setTintColor:[UIColor mainColor]];
    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView.mas_centerY);
        make.right.equalTo(self.headView.mas_right).offset(-20);
        make.width.height.mas_equalTo(20);
    }];
    
    self.showLabel = [[UILabel alloc] init];
    self.showLabel.textAlignment = NSTextAlignmentCenter;
    self.showLabel.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
    self.showLabel.text = [NSDate stringFromDate:self.currentDate];
    [self.headView addSubview:self.showLabel];
    
    [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView.mas_centerX);
        make.centerY.equalTo(self.headView.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
    }];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kScreenW / 7.0, 35);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[WCalendarCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.weakTitles.count;
    }
    
    NSInteger days = [self daysOfMonth];
    NSInteger firstWeekDay = [self weakOfDay];
    
    if ([self.delegate respondsToSelector:@selector(getCalendarHeight:)]) {
        NSInteger colum = (days + firstWeekDay) / 7.0;
        colum = (days + firstWeekDay) % 7 == 0 ? colum : colum + 1;
        [self.delegate getCalendarHeight:(colum + 1) * 35 + 50];
    }
    
    return days + firstWeekDay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = [UIColor colorWithRed:155 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:1];
    if (indexPath.section == 0) {
        cell.dayLabel.text = self.weakTitles[indexPath.row];
        cell.dayLabel.font = [UIFont systemFontOfSize:14.f];
        cell.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    }
    else {
        NSInteger days = [self daysOfMonth];
        NSInteger firstWeekDay = [self weakOfDay];
        
        if ((indexPath.row < firstWeekDay) || (indexPath.row > days + firstWeekDay - 1)) {
            cell.dayLabel.text = @"";
        }
        else {
            NSInteger day = indexPath.row - firstWeekDay + 1;
            cell.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
            NSString *str = [NSString stringWithFormat:@"%.2ld", day];
            NSString *dateStr = [NSString stringWithFormat:@"%@%@日", [NSDate stringFromDate:self.currentDate], str];
          
            NSString *currentStr = [NSDate getCurrentDate];
            NSString *nowDateStr = [NSDate stringFromDate:self.selectedDate];
            
            if ([currentStr isEqualToString:dateStr]) {
                cell.dayLabel.textColor = [UIColor colorWithRed:7 / 255.0 green:151 / 255.0 blue:215 / 255.0 alpha:1];
            }
            
            if ([nowDateStr isEqualToString:dateStr]) {
                cell.dayLabel.textColor = [UIColor colorWithRed:15 / 255.0 green:203 / 255.0 blue:239 / 255.0 alpha:1];
            }
            
        }
        cell.dayLabel.font = [UIFont systemFontOfSize:17.f];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WCalendarCollectionViewCell *cell = (WCalendarCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.section != 0 && ![cell.dayLabel.text isEqualToString:@""]) {
        if ([self.delegate respondsToSelector:@selector(dayMessage:)]) {
            WCalendarCollectionViewCell *cell = (WCalendarCollectionViewCell *)[self collectionView:collectionView
                                                                                 cellForItemAtIndexPath:indexPath];
            NSString *message = [[NSDate stringFromDate:self.currentDate]
                                 stringByAppendingString:[NSString stringWithFormat:@"%@日", cell.dayLabel.text]];
            [self.delegate dayMessage:message];
        }
    }
}

#pragma mark - Button Action
- (void)preButtonAction:(UIButton *)button {
    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCurlDown animations:^{
        self.currentDate = [self preMonthWithDate:self.currentDate];
        self.showLabel.text = [NSDate stringFromDate:self.currentDate];
        [self.collectionView reloadData];
    } completion:nil];
}

- (void)nextButtonAction:(UIButton *)button {
    [UIView transitionWithView:self duration:animationDuration options:UIViewAnimationOptionTransitionCurlUp animations:^{
        self.currentDate = [self nextMonthWithDate:self.currentDate];
        self.showLabel.text = [NSDate stringFromDate:self.currentDate];
        [self.collectionView reloadData];
    } completion:nil];
}

#pragma mark - DateFormater


#pragma mark - Calendar Method
- (NSInteger)daysOfMonth {
    return [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate].length;
}

- (NSDate *)firstDayOfMonth {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self.currentDate];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}

- (NSInteger)weakOfDay {
    return [self.calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:[self firstDayOfMonth]] - 1;
}

- (NSDate *)preMonthWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)nextMonthWithDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = +1;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)getCurrentDate {
    return [NSDate date];
}


@end
