//
//  WNavigationController.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WNavigationController.h"

@interface WNavigationController ()

@end

@implementation WNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //关闭高斯模糊
    [UINavigationBar appearance].translucent = NO;
    //去除导航栏上返回按钮的文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTintColor:[UIColor mainColor]];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor textColor],
                          NSFontAttributeName:[UIFont systemFontOfSize:17.f]};
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
