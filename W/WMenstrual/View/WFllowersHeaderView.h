//
//  WFllowersHeaderView.h
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

// 状态花
@interface WFllowersHeaderView : UIView
@property (nonatomic, strong) UIImageView *fllowersImageView;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@end

// 日历底部图例
@class StateImageViewAndLabelView;
@interface CalendarBottmLabelView : UIView
@property (nonatomic, strong) StateImageViewAndLabelView *view1;
@property (nonatomic, strong) StateImageViewAndLabelView *view2;
@property (nonatomic, strong) StateImageViewAndLabelView *view3;
@property (nonatomic, strong) StateImageViewAndLabelView *view4;
@end

// 日历底部图例子view
@interface StateImageViewAndLabelView : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@end

// tableView的头部
@interface HeaderInSectionView : UIView
@property (nonatomic, strong) UILabel *calendarLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@end
