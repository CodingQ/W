//
//  WDecideViewController.m
//  W
//
//  Created by harry.qian on 2017/5/2.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WDecideViewController.h"

@interface WDecideViewController ()
@property (nonatomic, strong)UILabel *showLabel;
@end

@implementation WDecideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addShowView];
    [self addDecideBtn];
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    btn.frame = CGRectMake(20, 20, 20, 20);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addShowView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreenW, kScreenW)];
    label.font = [UIFont systemFontOfSize:90];
    label.textAlignment = NSTextAlignmentCenter;
    label.alpha = 0;
    self.showLabel = label;
    [self.view addSubview:label];
    
}

- (void)addDecideBtn {
    UIButton *decideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenH-64, kScreenW, 64)];
    [decideBtn addTarget:self action:@selector(decideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [decideBtn setTitle:@"走你~" forState:UIControlStateNormal];
    [decideBtn setBackgroundColor:[UIColor mainColor]];
    [decideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:decideBtn];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)decideBtnClick {
    [UIView animateWithDuration:0.8 animations:^{
       self.showLabel.alpha = 0;
    } completion:^(BOOL finished) {
        int value = arc4random_uniform(3);
        switch (value) {
            case 0: {
                self.showLabel.text = @"✔️";
                break;
            }
            case 1: {
                self.showLabel.text = @"❌";
                break;
            }
            case 2: {
                self.showLabel.text = @"🤷‍♀️";
                break;
            }
            default:
                break;
        }
        [UIView animateWithDuration:2 animations:^{
            self.showLabel.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }];
    

    
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
