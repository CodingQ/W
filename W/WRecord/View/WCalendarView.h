//
//  WCalendarView.h
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCalenderDelegate <NSObject>

- (void)dayMessage:(NSString *)dayMessage;
- (void)getCalendarHeight:(CGFloat)height;

@end

@interface WCalendarView : UIView

@property (nonatomic, weak)     id<WCalenderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withCurrentDate:(NSDate *)currentDate;
@end
