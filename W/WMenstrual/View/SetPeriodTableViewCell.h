//
//  SetPeriodTableViewCell.h
//  VPMenstruationDemo
//
//  Created by bbigcd on 2016/12/17.
//  Copyright © 2016年 bbigcd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCustomSwitch;
@interface SetPeriodTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (nonatomic, strong) WCustomSwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *hasSexDetailLabel;

@end
