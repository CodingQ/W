//
//  SetPeriodTableViewCell.m
//  VPMenstruationDemo
//
//  Created by bbigcd on 2016/12/17.
//  Copyright © 2016年 bbigcd. All rights reserved.
//

#import "SetPeriodTableViewCell.h"
#import "WCustomSwitch.h"

@implementation SetPeriodTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addSubview:self.switchBtn];
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-10));
        make.centerY.equalTo(self);
        make.size.mas_offset(CGSizeMake(50, 25));
    }];
    self.arrowImageView.hidden = YES;
}

- (WCustomSwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[WCustomSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    }
    return _switchBtn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
