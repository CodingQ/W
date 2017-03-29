//
//  WUserModel.h
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUserModel : NSObject
@property (nonatomic, copy)     NSString    *name; //姓名
@property (nonatomic, copy)     NSString    *sex;   //性别
@property (nonatomic, copy)     NSString    *weight;   //体重
@property (nonatomic, copy)     NSString    *height;  //身高
@property (nonatomic, copy)     NSString    *tag;  //目标步数
@property (nonatomic, copy)     NSString    *isLogin; //是否登录

- (void)loadData;
- (void)saveData;
- (void)saveLoginStatus;

@end
