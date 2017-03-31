//
//  WCalendarVC.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WCalendarVC.h"
#import "FSCalendar.h"
#import "WCustomCalendarCell.h"
#import "WTransitionAnimation.h"
static NSString *const FSCalendarCellID = @"FSCalendarCellID";

@interface WCalendarVC () <UIViewControllerTransitioningDelegate, FSCalendarDelegateAppearance,FSCalendarDataSource,FSCalendarDelegate>

@property (nonatomic, strong) FSCalendar    *clanderView;

@end

@implementation WCalendarVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.clanderView =  [[FSCalendar alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 300)];
    _clanderView.dataSource = self;
    _clanderView.delegate = self;
    _clanderView.scrollEnabled = NO;
    _clanderView.allowsMultipleSelection = YES; // 开启多选中
    _clanderView.appearance.headerMinimumDissolvedAlpha = 0.0f;
    _clanderView.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    _clanderView.appearance.headerTitleColor = [UIColor blackColor];
    // 周的显示字体形式 S M T W T F S
    _clanderView.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    // 非本月日期隐藏
    _clanderView.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
    _clanderView.appearance.weekdayTextColor = [UIColor colorWithHue:0.00
                                                          saturation:0.32
                                                          brightness:0.93
                                                               alpha:1.00];
    
    _clanderView.backgroundColor = [UIColor clearColor];
    _clanderView.appearance.todayColor = [UIColor colorWithRed:0.26 green:0.80 blue:0.86 alpha:1.00];
    _clanderView.today = [NSDate date];
    
    //        calendar.appearance.eventSelectionColor = [UIColor whiteColor];
    //        calendar.appearance.eventOffset = CGPointMake(0, 0);
    [_clanderView registerClass:[WCustomCalendarCell class] forCellReuseIdentifier:FSCalendarCellID];
    
    self.clanderView.backgroundColor = [UIColor whiteColor];
    self.clanderView.delegate = self;
    [self.view addSubview:self.clanderView];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source
{
    return [WTransitionAnimation transitionWithTransitionType:WPresentTrasitionPresent animationType:WAnimationUpToDown];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [WTransitionAnimation transitionWithTransitionType:WPresentTrasitionDismiss animationType:WAnimationUpToDown];
}
#pragma mark - -- FSCalendarDataSource --

// 某个日期的事件数量
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    return 0;
}

#pragma mark - -- FSCalendarDelegate --

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{

    
    NSDateFormatter *for2 = [[NSDateFormatter alloc] init];
    for2.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    for2.dateFormat = @"yyyy年MM月dd日";
    NSString *message = [for2 stringFromDate:date];
    NSLog(@"%@",message);
    self.calendarBlock(message);
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated{
    //    NSLog(@"%@", NSStringFromCGSize(bounds.size));
    calendar.frame = (CGRect){calendar.frame.origin, bounds.size};
    [self.view layoutIfNeeded];
}

#pragma mark - -- FSCalendarDelegateAppearance --
// 单事件的底部颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date{
    return nil;
}

// 多重事件底部的颜色
- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date{
    return nil;
}


// 选中日期的背景色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
    return [UIColor colorWithRed:0.26 green:0.80 blue:0.86 alpha:1.00];
}

// 日期  文字的颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    
   
    
    return nil;
}


- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    WCustomCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:FSCalendarCellID forDate:date atMonthPosition:monthPosition];
    return cell;
}


- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}


#pragma mark - - Private methods -

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSDateFormatter *for1 = [[NSDateFormatter alloc] init];
    for1.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [for1 stringFromDate:date];
    //    NSLog(@"%@", NSStringFromCGSize(cell.frame.size));
    WCustomCalendarCell *diyCell = (WCustomCalendarCell *)cell;
    
    diyCell.eventIndicator.hidden = NO;
    
    // 今天 显示Layer
    
    if ([[for1 stringFromDate:[NSDate date]] isEqualToString:dateString])
    {
        diyCell.todayLayer.hidden = NO;
    }
    
    
    
//    diyCell.selectionType = selectionType;
    
    
}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.clanderView.frame, point)) {
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
