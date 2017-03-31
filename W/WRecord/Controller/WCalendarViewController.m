//
//  WCalendarViewController.m
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WCalendarViewController.h"
#import "WCalendarView.h"
#import "WTransitionAnimation.h"
@interface WCalendarViewController () <UIViewControllerTransitioningDelegate, WCalenderDelegate>

@property (nonatomic, strong) WCalendarView    *clanderView;

@end

@implementation WCalendarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.clanderView = [[WCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300) withCurrentDate:self.currentDate];
    self.clanderView.backgroundColor = [UIColor whiteColor];
    self.clanderView.delegate = self;
    [self.view addSubview:self.clanderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RUNCalendarDelegate
- (void)dayMessage:(NSString *)dayMessage {
    NSLog(@"%@", dayMessage);
    self.calendarBlock(dayMessage);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getCalendarHeight:(CGFloat)height {
    self.clanderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, height);
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source
{
    return [WTransitionAnimation transitionWithTransitionType:WPresentTrasitionPresent animationType:WAnimationUpToDown];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [WTransitionAnimation transitionWithTransitionType:WPresentTrasitionDismiss animationType:WAnimationUpToDown];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.clanderView.frame, point)) {
        return ;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
