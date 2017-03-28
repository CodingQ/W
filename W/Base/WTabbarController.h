//
//  WTabbarController.h
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTabbarController : UITabBarController

@property (nonatomic, assign) BOOL  isRoot;

- (void)addChildController:(UIViewController *)childController
               normalImage:(UIImage *)normalImage
             selectedImage:(UIImage *)selectImage
                     title:(NSString *)title;

@end
