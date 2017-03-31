//
//  WCalendarViewController.h
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^RUNCalendarBlock)(NSString *);

@interface WCalendarViewController : UIViewController

@property (nonatomic, strong)   NSDate              *currentDate;
@property (nonatomic, copy)     RUNCalendarBlock    calendarBlock;
@end
