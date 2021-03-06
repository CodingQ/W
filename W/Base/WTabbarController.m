//
//  WTabbarController.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WTabbarController.h"
#import "WNavigationController.h"
#import "WRecordViewController.h"
#import "WAnalazyViewController.h"
#import "WUserViewController.h"
#import "WMenstruatlController.h"
@interface WTabbarController ()

@end

@implementation WTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UITabBar appearance].translucent = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)p_setTabBar {
    WRecordViewController *record = [[WRecordViewController alloc] init];

    [self addChildController:record normalImage:[UIImage imageNamed:@"zoulu"] selectedImage:[UIImage imageNamed:@"zoulu-sel"] title:@"记录"];
    
    WMenstruatlController *menstruatl = [[WMenstruatlController alloc] init];
    [self addChildController:menstruatl normalImage:[UIImage imageNamed:@"yima"] selectedImage:[UIImage imageNamed:@"yima-sel"] title:@"姨妈"];
    
    WAnalazyViewController *analazyVC = [[WAnalazyViewController alloc] init];
    [self addChildController:analazyVC normalImage:[UIImage imageNamed:@"fenxi"] selectedImage:[UIImage imageNamed:@"fenxi-sel"] title:@"分析"];

    WUserViewController *userVC = [[WUserViewController alloc] init];
    [self addChildController:userVC normalImage:[UIImage imageNamed:@"wo"] selectedImage:[UIImage imageNamed:@"wo-sel"] title:@"我"];
    


}

#pragma mark - TabBar Set Method
- (void)addChildController:(UIViewController *)childController
               normalImage:(UIImage *)normalImage
             selectedImage:(UIImage *)selectImage
                     title:(NSString *)title {
    if (!self.isRoot) {
        childController.tabBarItem.image = normalImage;
        childController.tabBarItem.selectedImage = selectImage;
        childController.tabBarItem.title = title;
        [childController.tabBarItem setTitleTextAttributes:@{
                                                             NSForegroundColorAttributeName:[UIColor mainColor],
                                                             NSFontAttributeName:[UIFont systemFontOfSize:14.f]} forState:UIControlStateSelected];
        self.tabBar.tintColor = [UIColor mainColor];
        [self addChildViewController:childController];
        return;
    }
    
    WNavigationController *runNav = [[WNavigationController alloc] initWithRootViewController:childController];
    
    runNav.tabBarItem.image = normalImage;
    runNav.tabBarItem.selectedImage = selectImage;
    runNav.tabBarItem.title = title;
    childController.title = title;
    [runNav.tabBarItem setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName:[UIColor mainColor],
                                                NSFontAttributeName:[UIFont systemFontOfSize:14.f]} forState:UIControlStateSelected];
    
    self.tabBar.tintColor = [UIColor mainColor];
    
    [self addChildViewController:runNav];
}

- (void)setIsRoot:(BOOL)isRoot {
    _isRoot = isRoot;
    if (isRoot) {
        //初始化提示框
        [SVProgressHUD setMinimumDismissTimeInterval:2];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD setBackgroundColor:[UIColor textColor]];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
        
        [self p_setTabBar];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
