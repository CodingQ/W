//
//  WPageControl.h
//  W
//
//  Created by harry.qian on 17/3/31.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPageControl : UIPageControl
- (void)setupCurrentImageName:(NSString *)currentImageName
           indicatorImageName:(NSString *)indicatorImageName;
@end
