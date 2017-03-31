//
//  WPickViewController.h
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPickerViewDelegate <NSObject>

@optional
- (void)pickText:(NSString *)text;
- (void)pickText:(NSString *)text withRow:(NSUInteger)row;

@end

@interface WPickViewController : UIViewController

@property (nonatomic, strong) id<WPickerViewDelegate> pickDelegate;
@property (nonatomic, copy)   NSArray                   *datas;
@property (nonatomic, copy)   NSString                  *mainTitle;
@property (nonatomic, copy)   UIColor                   *backGroundColor;
@property (nonatomic, copy)   NSString                  *separator;
@property (nonatomic, assign) BOOL                      isTime;
@property (nonatomic, assign) BOOL                      isDate;
@property (nonatomic, copy)   NSArray <NSNumber *>      *dValue;
@property (nonatomic, copy)   NSArray                   *defaultData;
@property (nonatomic, assign) NSUInteger                row;

@end
