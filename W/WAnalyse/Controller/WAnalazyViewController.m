//
//  WAnalazyViewController.m
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WAnalazyViewController.h"
#import "WChildViewController.h"
static CGFloat const kTitleH = 44;
static CGFloat const kMaxScale = 1.1;
static int const kLineWidth = 60;
static int const kMarginWidth = 116;

#define kButtonUnSelColor [UIColor textColor]
#define kButtonSelColor   [UIColor mainColor]
#define kButtonWidth kScreenW / 5.0

@interface WAnalazyViewController () <UIScrollViewDelegate> {
    NSUInteger  _currentX;
    NSArray     *_unitStrs;
    NSArray     *_totals;
    NSArray     *_titles;
    NSArray     *_units;
    NSArray     *_chartTypes;
}

//定义头部标题
@property (nonatomic, strong) UIScrollView  *titleScroller;
@property (nonatomic, strong) UIScrollView  *containScroller;

//当前选中的标题按钮
@property (nonatomic, strong) UIButton      *selectButton;
@property (nonatomic, strong) UIView        *bottomLine;

//添加的标题按钮集合
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleButtons;
@property (nonatomic, strong) NSMutableDictionary         *lineWidthCache;

@end

@implementation WAnalazyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTitleScroller];
    [self setupContainScroller];
    [self setupChildViewController];
    [self setupTitle];
    [self setNavigation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popOverWithRow:) name:Notice_Run object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notice_Run object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //屏幕旋转修正containScroller的contentSize,修正到合适的大小
    self.containScroller.contentSize = CGSizeMake(self.view.frame.size.width * self.childViewControllers.count, 0);
    
    //同样是修正位置，将当前的contentOffset修正到合适的位置
    self.containScroller.contentOffset = CGPointMake(_currentX * self.view.frame.size.width, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation Item
- (void)setNavigation {
    
    self.navigationItem.title = @"";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(leftBarItemAction:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"round_add"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(rightBarItemAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

#pragma mark - Bar Item Action
//- (void)leftBarItemAction:(UIBarButtonItem *)button {
//    RUNShareViewController *shareVC = [[RUNShareViewController alloc] init];
//    shareVC.imageData = [self run_getScreenShotWithSize:self.view.bounds.size view:self.view];
//    [self presentViewController:shareVC animated:YES completion:nil];
//}
//
//- (void)rightBarItemAction:(UIBarButtonItem *)button {
//    RUNFuncViewController *funcVC = [[RUNFuncViewController alloc] init];
//    [self presentViewController:funcVC animated:YES completion:nil];
//}

#pragma mark - 设置头部标题栏
- (void)setupTitleScroller {
    self.titleScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTitleH)];
    self.titleScroller.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleScroller;
    
    [self.titleScroller addSubview:self.bottomLine];
}

#pragma mark - 设置内容
- (void)setupContainScroller {
    
    self.containScroller = [[UIScrollView alloc] init];
    self.containScroller.backgroundColor = [UIColor whiteColor];
    self.containScroller.delegate = self;
    self.containScroller.pagingEnabled = YES;
    self.containScroller.showsHorizontalScrollIndicator = NO;
    self.containScroller.bounces = NO;
    [self.view addSubview:self.containScroller];
    
    [self.containScroller mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
}

#pragma mark - 添加子控制器
- (void)setupChildViewController {
    
    
    for (int index = 0; index < 5; index++) {
        WChildViewController *workVC = [[WChildViewController alloc] init];
        workVC.title = self.titles[index];
        workVC.unitStr = self.units[index];
        workVC.unit = self.unitStrs[index];
        workVC.chartType = [self.chartTypes[index] intValue];
        [self addChildViewController:workVC];
    }
    
    UIView *tempView = nil;
    for (int i = 0; i < self.childViewControllers.count; i++) {
        UIView *view = [self.childViewControllers objectAtIndex:i].view;
        view.backgroundColor = [UIColor whiteColor];
        [self.containScroller addSubview:view];
        
        if (i == 0) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.containScroller);
                make.width.mas_equalTo(self.view.mas_width);
                make.height.mas_equalTo(self.containScroller.mas_height);
            }];
        } else if(i == self.childViewControllers.count - 1){
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(0);
                make.top.right.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.mas_width);
                make.height.equalTo(self.containScroller.mas_height);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_right).offset(0);
                make.top.bottom.equalTo(self.containScroller);
                make.width.equalTo(self.view.mas_width);
                make.height.equalTo(self.containScroller.mas_height);
            }];
        }
        tempView = view;
    }
    
}

#pragma mark - 添加标题
- (void)setupTitle {
    NSUInteger icount = self.childViewControllers.count;
    
    CGFloat currentX = 0;
    CGFloat width = kButtonWidth;
    CGFloat height = kTitleH;
    
    for (int index = 0; index < icount; index++) {
        UIViewController *VC = self.childViewControllers[index];
        currentX = index * width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(currentX, 0, width, height);
        button.tag = index;
        
        [button setTitle:VC.title forState:UIControlStateNormal];
        [button setTitleColor:kButtonUnSelColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.f];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScroller addSubview:button];
        [self.titleButtons addObject:button];
        
        if (index == 0) {
            [self buttonAction:button];
        }
        
    }
    
    self.titleScroller.contentSize = CGSizeMake(icount * width, 0);
    self.titleScroller.showsHorizontalScrollIndicator = NO;
    
}

#pragma mark - 按钮点击事件
- (void)buttonAction:(UIButton *)sender {
    [self selectButton:sender];
    
    NSUInteger index = sender.tag;
    _currentX = index;
    
    self.containScroller.contentOffset = CGPointMake(index * kScreenW, 0);
}

#pragma mark - 选中按钮进行的操作
- (void)selectButton:(UIButton *)button {
    [self.selectButton setTitleColor:kButtonUnSelColor forState:UIControlStateNormal];
    //将选中的button的transform重置
    self.selectButton.transform = CGAffineTransformIdentity;
    
    [button setTitleColor:kButtonSelColor forState:UIControlStateNormal];
    button.transform = CGAffineTransformMakeScale(kMaxScale, kMaxScale);
    
    NSString *lineSize = [self.lineWidthCache objectForKey:button.titleLabel.text];
    
    if (!lineSize) {
        UIFont *fontWithButton = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        CGSize buttonTextSize = [button.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fontWithButton, NSFontAttributeName, nil]];
        
        lineSize = [NSString stringWithFormat:@"%f", buttonTextSize.width];
    }
    
    //添加按钮下面线的移动动画
    CGFloat x = button.center.x - [lineSize doubleValue] / 2.0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomLine.frame = CGRectMake(x, self.bottomLine.frame.origin.y, [lineSize doubleValue], self.bottomLine.frame.size.height);
    } completion:nil];
    
    self.selectButton = button;
    [self setupButtonCenter:button];
}

#pragma mark - 将当前选中的按钮置于中心
- (void)setupButtonCenter:(UIButton *)button {
    CGFloat offSet = button.center.x - kScreenW * 0.5;
    CGFloat maxOffSet = self.titleScroller.contentSize.width - (kScreenW - kMarginWidth);
    if (offSet > maxOffSet) {
        offSet = maxOffSet;
    }
    
    if (offSet < 0) {
        offSet = 0;
    }
    
    [self.titleScroller setContentOffset:CGPointMake(offSet, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.containScroller.contentOffset.x / self.view.frame.size.width;
    [self selectButton:self.titleButtons[i]];
    _currentX = i;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSUInteger leftIndex = offset / kScreenW;
    NSUInteger rightIndex = leftIndex + 1;
    
    UIButton *leftButton = self.titleButtons[leftIndex];
    UIButton *rightButton = nil;
    if (rightIndex < self.titleButtons.count) {
        rightButton = self.titleButtons[rightIndex];
    }
    
    CGFloat transScale = kMaxScale - 1;
    CGFloat rightScale = offset / self.view.frame.size.width - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    leftButton.transform = CGAffineTransformMakeScale(leftScale * transScale + 1, leftScale * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(rightScale * transScale + 1, rightScale * transScale + 1);
}

#pragma mark - NSNotification Action
//- (void)popOverWithRow:(id)sender{
//    NSInteger row = [[[sender userInfo] objectForKey:@"row"] integerValue];
//    if (row == 0) {
//        RUNMapViewController *mapVC = [[RUNMapViewController alloc] init];
//        mapVC.hidesBottomBarWhenPushed = YES;
//        mapVC.title = @"运动";
//        [self.navigationController pushViewController:mapVC animated:YES];
//    } else if (row == 2) {
//        RUNFAQViewController *faqVC = [[RUNFAQViewController alloc] init];
//        faqVC.title = @"帮助";
//        faqVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:faqVC animated:YES];
//    } else if (row == 1) {
//        RUNWeightViewController *weight = [[RUNWeightViewController alloc] init];
//        weight.title = @"录入体重";
//        weight.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:weight animated:YES];
//    }
//}

#pragma mark - Lazy Load
- (NSMutableArray <UIButton *> *)titleButtons {
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
        
    }
    return _titleButtons;
}

- (NSMutableDictionary *)lineWidthCache {
    if (_lineWidthCache == nil) {
        _lineWidthCache = [NSMutableDictionary dictionary];
    }
    return _lineWidthCache;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTitleH - 2, kLineWidth, 2)];
        _bottomLine.backgroundColor = kButtonSelColor;
        
    }
    return _bottomLine;
}

- (NSArray *)unitStrs {
    if (!_unitStrs) {
        _unitStrs = @[@"步", @"公里", @"大卡", @"层", @"公斤"];
    }
    return _unitStrs;
}

- (NSArray *)units {
    if (!_units) {
        _units = @[@"总步数", @"总公里", @"总消耗", @"总楼层", @"BMI值"];
    }
    return _units;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"步数", @"公里", @"卡路里", @"楼层", @"体重"];
    }
    return _titles;
}

- (NSArray *)chartTypes {
    if (!_chartTypes) {
        _chartTypes = @[@1, @1, @0, @1, @0];
    }
    return _chartTypes;
}

@end
