//
//  WMenstruatlController.m
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WMenstruatlController.h"

#import "FSCalendar.h"
#import "WCustomCalendarCell.h"

#import "WFllowersHeaderView.h"
#import "WMenstrualModel.h"
#import "SetPeriodTableViewCell.h"
#import "FlowAndPainTableViewCell.h"
#import "WPageControl.h"
#import "WMenstrualPeriodAlgorithm.h"
#import "WCustomSwitch.h"

@interface WMenstruatlController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSArray *currentRMAarry;
    NSArray *rmAarry;
    NSArray *ovulationArr;
    NSArray *ovulationDayArr;
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) UIScrollView *tableHeadScrollView;
@property (nonatomic, strong) WPageControl *pageControl;
@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) WFllowersHeaderView *fllowersTableHeaderView;
@property (nonatomic, strong) CalendarBottmLabelView *calendarBottmLabelView;

@property (nonatomic, strong) HeaderInSectionView *headerInSectionView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatterForHead;
// 公历
@property (nonatomic, strong) NSCalendar *gregorian;

@property (nonatomic, strong) WMenstrualModel *model;
@property (nonatomic, assign) BOOL hasDetail;


@end

@implementation WMenstruatlController



static NSString *const SetPeriodTableViewCellID = @"SetPeriodTableViewCell";
static NSString *const FlowAndPainTableViewCellID = @"FlowAndPainTableViewCell";
static NSString *const FSCalendarCellID = @"FSCalendarCellID";

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 40.0f;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"SetPeriodTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:SetPeriodTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"FlowAndPainTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:FlowAndPainTableViewCellID];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 340)];
    }
    return _tableHeadView;
}

// 嵌套的ScrollView
- (UIScrollView *)tableHeadScrollView{
    if (!_tableHeadScrollView) {
        _tableHeadScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 340)];
        _tableHeadScrollView.contentSize = CGSizeMake(kScreenW * 2, 320);
        _tableHeadScrollView.delegate = self;
        _tableHeadScrollView.showsHorizontalScrollIndicator = NO;
        _tableHeadScrollView.pagingEnabled = YES;
    }
    return _tableHeadScrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[WPageControl alloc] initWithFrame:(CGRect){0, 300, kScreenW, 20}];
        [_pageControl setupCurrentImageName:@"swift_light" indicatorImageName:@"swfit_dark"];
        _pageControl.numberOfPages = 2;
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

// 状态花
- (WFllowersHeaderView *)fllowersTableHeaderView{
    if (!_fllowersTableHeaderView) {
        _fllowersTableHeaderView = [[WFllowersHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 280)];
        _fllowersTableHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _fllowersTableHeaderView;
}

// 日历UI设置
- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, 300)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.scrollEnabled = NO;
        _calendar.allowsMultipleSelection = YES; // 开启多选中
        _calendar.appearance.headerMinimumDissolvedAlpha = 0.0f;
        _calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _calendar.appearance.headerTitleColor = [UIColor blackColor];
        // 周的显示字体形式 S M T W T F S
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        // 非本月日期隐藏
        _calendar.placeholderType = FSCalendarPlaceholderTypeFillHeadTail;
        _calendar.appearance.weekdayTextColor = [UIColor colorWithHue:0.00
                                                           saturation:0.32
                                                           brightness:0.93
                                                                alpha:1.00];
        
        _calendar.backgroundColor = [UIColor clearColor];
        //        _calendar.appearance.todayColor = [UIColor colorWithRed:0.26 green:0.80 blue:0.86 alpha:1.00];
        
        
        //        calendar.appearance.eventSelectionColor = [UIColor whiteColor];
        //        calendar.appearance.eventOffset = CGPointMake(0, 0);
        [_calendar registerClass:[WCustomCalendarCell class] forCellReuseIdentifier:FSCalendarCellID];
        
    }
    return _calendar;
}

// cell头部的日期显示，及生理状态显示
- (HeaderInSectionView *)headerInSectionView{
    if (!_headerInSectionView) {
        _headerInSectionView = [[HeaderInSectionView alloc] initWithFrame:(CGRect){0, 0, kScreenW, 75}];
        _headerInSectionView.calendarLabel.text = [_dateFormatterForHead stringFromDate:[NSDate date]];
        _headerInSectionView.stateLabel.text = @"姨妈没走";
    }
    return _headerInSectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[WMenstrualModel alloc] init];
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(rightBarButtonItemClick)];
    
    self.tableView.tableHeaderView = self.tableHeadView;
    [self.tableHeadView addSubview:self.tableHeadScrollView];
    [self.tableHeadView addSubview:self.pageControl];
    
    // 花
    [self.tableHeadScrollView addSubview:self.fllowersTableHeaderView];
    _fllowersTableHeaderView.fllowersImageView.image = [UIImage imageNamed:@"月经期"];
    _fllowersTableHeaderView.dayLabel.text = @"7";
    //    _fllowersTableHeaderView.describeLabel.text = @"Day";
    _fllowersTableHeaderView.stateLabel.text = @"姨妈没走😣";
    // 日历
    [self.tableHeadScrollView addSubview:self.calendar];
    
    // 日历底部标签
    self.calendarBottmLabelView = [[CalendarBottmLabelView alloc] initWithFrame:(CGRect){kScreenW, 320, kScreenW, 20}];
    _calendarBottmLabelView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    _calendarBottmLabelView.view1.label.text = _model.titleLabelForBottomStateGuide[0];
    _calendarBottmLabelView.view2.label.text = _model.titleLabelForBottomStateGuide[1];
    _calendarBottmLabelView.view3.label.text = _model.titleLabelForBottomStateGuide[2];

    
    [self.tableHeadScrollView addSubview:_calendarBottmLabelView];
    
    // 设置上下月份的按钮
    [self setupPreviousButtonAndNextButton];
    
    
    
    [self setupNSArraysDataSource];
    
    
    
    rmAarry = [WMenstrualPeriodAlgorithm vp_GetMenstrualPeriodWithDate:[NSDate date] CycleDay:28 PeriodLength:6];
//    ovulationArr = [WMenstrualPeriodAlgorithm vp_GetOvulationWithDate:[NSDate date] CycleDay:28 PeriodLength:6];
//    ovulationDayArr = [WMenstrualPeriodAlgorithm vp_GetOvulationDayWithDate:[NSDate date] CycleDay:28 PeriodLength:6];
    currentRMAarry = [WMenstrualPeriodAlgorithm vp_GetCurrentMenstrualPeriodWithDate:[NSDate date] PeriodLength:6];
    
    [self setupCalendar];
    
    [self.tableView reloadData];
}



// 数据源设置
- (void)setupNSArraysDataSource{
    
    // 日期的格式化方式
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    self.dateFormatterForHead = [[NSDateFormatter alloc] init];
    self.dateFormatterForHead.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    self.dateFormatterForHead.dateFormat = @"yyyy-MM-dd";
}

// 选中设置
- (void)setupCalendar{
    
   
    
    // 选中月经期
    for (NSString *string in currentRMAarry) {
        [_calendar selectDate:[_dateFormatter dateFromString:string]];
    }
    // 是否可以点击
    //    _calendar.allowsSelection = NO;
    
}

// 上下月份点击
- (void)setupPreviousButtonAndNextButton{
    UIButton *previousButton = [self commonCreateButtonWithFrame:CGRectMake(40, 5, 55, 34)
                                                       imageName:@"left-arrow"
                                                          action:@selector(previousClicked:)];
    
    UIButton *nextButton = [self commonCreateButtonWithFrame:CGRectMake(kScreenW - 95, 5, 55, 34)
                                                   imageName:@"right-arrow"
                                                      action:@selector(nextClicked:)];
    [self.calendar addSubview:previousButton];
    [self.calendar addSubview:nextButton];
}

- (UIButton *)commonCreateButtonWithFrame:(CGRect)frame
                                imageName:(NSString *)imageName
                                   action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - - Target actions -

// 跳转到今天
- (void)rightBarButtonItemClick{
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
}

// 上个月
- (void)previousClicked:(id)sender{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

// 下个月
- (void)nextClicked:(id)sender{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}


#pragma mark - -- FSCalendarDataSource --

// 某个日期的事件数量
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date{
    return 0;
}

#pragma mark - -- FSCalendarDelegate --

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    _headerInSectionView.calendarLabel.text = [_dateFormatterForHead stringFromDate:date];
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
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
    
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    // 下一月经期显示颜色
    if ([rmAarry containsObject:dateString]) {
        return [UIColor redColor];
    }
    
    // 排卵期显示颜色
    if ([ovulationArr containsObject:dateString]) {
        if ([ovulationDayArr containsObject:dateString]) {
            return [UIColor whiteColor];
        }
        return [UIColor colorWithHue:0.75 saturation:0.80 brightness:0.71 alpha:1.00];
    }
    
    if ([[_dateFormatter stringFromDate:[NSDate date]] isEqualToString:dateString])
    {
        return [UIColor whiteColor];
    }
    
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

- (void)configureVisibleCells
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:cell];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:cell];
        [self configureCell:cell forDate:date atMonthPosition:position];
    }];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    //    NSLog(@"%@", NSStringFromCGSize(cell.frame.size));
    WCustomCalendarCell *diyCell = (WCustomCalendarCell *)cell;
    
    diyCell.eventIndicator.hidden = NO;
    
    //    diyCell.shapeLayer.hidden = NO;
    
    // 配置选中状态
    SelectionType selectionType = SelectionTypeNone;
    // 当前日期在选中日期里
    if ([self.calendar.selectedDates containsObject:date])
    {
        // 当前日期的前一天和后一天
        NSDate *previousDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
        NSDate *nextDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
        
        // 当前日期和前一天、后一天也在选中日期里面 当前日期的选中类型为 SelectionTypeMiddle
        if ([self.calendar.selectedDates containsObject:previousDate]
            && [self.calendar.selectedDates containsObject:nextDate]) {
            selectionType = SelectionTypeMiddle;
        }
        // 当前日期和前一天
        else if ([self.calendar.selectedDates containsObject:previousDate])
        {
            selectionType = SelectionTypeRightBorder;
        }
        // 当前日期和后一天
        else if ([self.calendar.selectedDates containsObject:nextDate])
        {
            selectionType = SelectionTypeLeftBorder;
        }
        // 只有当前日期
        else
        {
            selectionType = SelectionTypeSingle;
        }
    }
    else // 当前日期不在选中日期中
    {
        selectionType = SelectionTypeNone;
    }
    
    // 默认今天和排卵日Layer隐藏 选中的Layer显示
    diyCell.selectionLayer.hidden = NO;
    diyCell.todayLayer.hidden = YES;
    diyCell.ovulationDayLayer.hidden = YES;
    
    // 今天 显示Layer
    if ([[_dateFormatter stringFromDate:[NSDate date]] isEqualToString:dateString])
    {
        diyCell.todayLayer.hidden = NO;
    }
    
//     排卵日 显示Layer
//        if ([_model.datesOfOvulationDay containsObject:dateString])
//        {
//            diyCell.ovulationDayLayer.hidden = NO;
//        }
    if ([ovulationDayArr containsObject:dateString]) {
        diyCell.ovulationDayLayer.hidden = NO;
    }
    
//     非选中 选中的layer 隐藏
    if (selectionType == SelectionTypeNone)
    {
        diyCell.selectionLayer.hidden = YES;
        return;
    }
    
    
    diyCell.selectionType = selectionType;
    
    
}

#pragma mark - -- UITableViewDelegate --
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 不同的行, 可以设置不同的编辑样式, 编辑样式是一个枚举类型 */
    if (indexPath.row == 3) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

#pragma mark - -- UITableViewDataSource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.iconImageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 75.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerInSectionView;
}

// cell间距
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3 + _hasDetail || indexPath.row == 4 + _hasDetail)
    {
        FlowAndPainTableViewCell *FCell = [tableView dequeueReusableCellWithIdentifier:FlowAndPainTableViewCellID forIndexPath:indexPath];
        FCell.selectionStyle = UITableViewCellSelectionStyleNone;
        FCell.iconImageView.image = [UIImage imageNamed:_model.iconImageArray[indexPath.row]];
        FCell.titleLabel.text = _model.titleLabelTextArray[indexPath.row];
        if (indexPath.row == 3) {
            [FCell setBtnsNormalImage:@"flow" selectedImage:@"flow_click"];
            [FCell setDidSelectedBtnBlock:^(NSInteger level) {
                NSLog(@"%@", _model.menstrualFlowRemindArray[level]);
            }];
        }else{
            [FCell setBtnsNormalImage:@"pain" selectedImage:@"pain-_click"];
            [FCell setDidSelectedBtnBlock:^(NSInteger level) {
                NSLog(@"%@", _model.menstrualPainRemindArray[level]);
            }];
        }
        return FCell;
    }
    else
    {
        SetPeriodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SetPeriodTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconImageView.image = [UIImage imageNamed:_model.iconImageArray[indexPath.row]];
        cell.titleLabel.text = _model.titleLabelTextArray[indexPath.row];
        [cell.switchBtn setSwiftOnColor:[UIColor colorWithHexString:@"ff93a2"] offColor:[UIColor colorWithHexString:@"bdbdbd"] withTarget:self action:@selector(testVpSwitch:)];
        cell.switchBtn.tag = indexPath.row;
        if (indexPath.row == 5 + _hasDetail || indexPath.row == 3) {
            if (indexPath.row == 3) {
                cell.hasSexDetailLabel.hidden = NO;
            }
            cell.switchBtn.hidden = YES;
            cell.arrowImageView.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        return cell;
    }
}

- (void)testVpSwitch:(WCustomSwitch *)sender {//默认tag==0
    sender.on = !sender.on;
    //多个开关 可用tag区分
    switch (sender.tag) {
        case 0:
        {
            break;
        }
        case 1:
        {
            break;
        }
        case 2:
        {
            if (sender.on == YES)
            {
                _hasDetail = YES;
                [self.tableView beginUpdates];
                [self insertHadSexDetail];
                [self.tableView endUpdates];
            }else{
                _hasDetail = NO;
                [self.tableView beginUpdates];
                [self deleteHadSexDetail];
                [self.tableView endUpdates];
            }
            break;
        }
        default:
            break;
    }
    
    //    if (sender.on == YES) {
    //        NSLog(@"开");
    //    }else{
    //        NSLog(@"关");
    //    }
}

- (void)insertHadSexDetail{
    [_model.iconImageArray insertObject:@"prepare" atIndex:3];
    [_model.titleLabelTextArray insertObject:@"Detail" atIndex:3];
    NSMutableArray *indexPahts = [[NSMutableArray alloc]init];
    NSIndexPath *indexPaht = [NSIndexPath indexPathForRow:_model.iconImageArray.count - 4 inSection:0];
    [indexPahts addObject:indexPaht];
    [self.tableView insertRowsAtIndexPaths:[indexPahts copy] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteHadSexDetail{
    [_model.iconImageArray removeObjectAtIndex:3];
    [_model.titleLabelTextArray removeObjectAtIndex:3];
    NSMutableArray *indexPahts = [[NSMutableArray alloc]init];
    NSIndexPath *indexPaht = [NSIndexPath indexPathForRow:_model.iconImageArray.count - 3 inSection:0];
    [indexPahts addObject:indexPaht];
    [self.tableView deleteRowsAtIndexPaths:[indexPahts copy] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_hasDetail) {
        if (indexPath.row == 3) {
            NSLog(@"has sex");
        }
    }
}

#pragma mark - -- UIScrollViewDelegate --

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger oneOrTwo;
    if ((scrollView.contentOffset.x / kScreenW) <= 0) {
        oneOrTwo = 0;
    }else{
        oneOrTwo = 1;
    }
    _pageControl.currentPage = oneOrTwo;
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y > 100) {
        FSCalendarScope selectedScope = FSCalendarScopeWeek;
        [self.calendar setScope:selectedScope animated:YES];
    }else if (scrollView.contentOffset.y < -100){
        FSCalendarScope selectedScope = FSCalendarScopeMonth;
        [self.calendar setScope:selectedScope animated:YES];
    }
}
@end
