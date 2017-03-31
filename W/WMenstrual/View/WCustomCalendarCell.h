//
//  WCustomCalendarCell.h
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "FSCalendarCell.h"
// 选中枚举
typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};

@interface WCustomCalendarCell : FSCalendarCell

// 选中的layer
@property (nonatomic, weak) CAShapeLayer *selectionLayer;

// 当天的layer
@property (nonatomic, weak) CAShapeLayer *todayLayer;
// 排卵日layer
@property (nonatomic, weak) CAShapeLayer *ovulationDayLayer;

// 选中日期的位置
@property (nonatomic, assign) SelectionType selectionType;
@end
