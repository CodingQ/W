//
//  WButton.h
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WButtonAction)(void);

@interface WButton : UIView

@property (nonatomic, strong) UIImage           *image;
@property (nonatomic, copy)   NSString          *descStr;
@property (nonatomic, copy)   WButtonAction   buttonAction;

@end
