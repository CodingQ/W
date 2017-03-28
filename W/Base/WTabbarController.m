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
    record.view.backgroundColor = [UIColor mainColor];
    [self addChildController:record normalImage:nil selectedImage:nil title:@"记录"];
    
    UIViewController *analazyVC = [[UIViewController alloc] init];
    [self addChildController:analazyVC normalImage:nil selectedImage:nil title:@"分析"];
    analazyVC.view.backgroundColor = [UIColor mainColor];
    UIViewController *userVC = [[UIViewController alloc] init];
    [self addChildController:userVC normalImage:nil selectedImage:nil title:@"我"];
    userVC.view.backgroundColor = [UIColor mainColor];
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
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
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
