//
//  FlowAndPainTableViewCell.h
//  VPMenstruationDemo
//
//  Created by bbigcd on 2016/12/17.
//  Copyright © 2016年 bbigcd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MenstrualReactionState) {
    MenstrualReactionStateFlow,
    MenstrualReactionStatePain,
};

@interface FlowAndPainTableViewCell : UITableViewCell

// 取不同的icon
@property (nonatomic, assign) MenstrualReactionState menstrualReactionState;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *stateBtn1;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn2;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn3;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn4;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn5;

@property (nonatomic, copy) void(^didSelectedBtnBlock) (NSInteger level);

// 点击方法
- (IBAction)stateBtnsAction:(id)sender;

- (void)setBtnsNormalImage:(NSString *)normalImageName
             selectedImage:(NSString *)selectedImageName;

@end
