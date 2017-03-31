//
//  WAllDataViewController.m
//  W
//
//  Created by harry.qian on 17/3/29.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "WAllDataViewController.h"

static NSString *const identifity = @"RUNAllDataViewController";

@interface WAllDataViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)   UITableView         *tableView;

@end

@implementation WAllDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Set TableView
- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifity];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifity];
        cell.textLabel.textColor = [UIColor textColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
        cell.detailTextLabel.textColor = [UIColor textColor];
    }
    
    NSDictionary *dic = self.dataArray[self.dataArray.count - indexPath.row - 1];
    NSNumber *number = dic[@"value"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f %@", [number doubleValue], self.unit];
    cell.textLabel.text = dic[@"date"];
    
    if ([self.unit isEqualToString:@"公里"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f %@", [number doubleValue] / 1000, self.unit];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
