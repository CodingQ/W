//
//  FlowAndPainTableViewCell.m
//  VPMenstruationDemo
//
//  Created by bbigcd on 2016/12/17.
//  Copyright © 2016年 bbigcd. All rights reserved.
//

#import "FlowAndPainTableViewCell.h"

@interface FlowAndPainTableViewCell ()

@property (nonatomic, strong) NSString *s_normalImageName;
@property (nonatomic, strong) NSString *s_selectedImageName;

@end

@implementation FlowAndPainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)stateBtnsAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    BOOL selected = !btn.selected;
    btn.selected = selected;
    switch (btn.tag) {
        case 100:
        {
            if (btn.selected == YES) {
                _stateBtn2.selected = _stateBtn3.selected = _stateBtn4.selected = _stateBtn5.selected = NO;
                self.didSelectedBtnBlock(0);
            }else{
                _stateBtn2.highlighted = _stateBtn3.highlighted = _stateBtn4.highlighted = _stateBtn5.highlighted = NO;
            }
            break;
        }
        case 200:
        {
            if (btn.selected == YES) {
                _stateBtn1.selected =  _stateBtn3.selected = _stateBtn4.selected = _stateBtn5.selected = NO;
                _stateBtn1.highlighted = YES;
                self.didSelectedBtnBlock(1);
            }else{
                _stateBtn1.highlighted = _stateBtn3.highlighted = _stateBtn4.highlighted = _stateBtn5.highlighted = NO;
            }
            break;
        }
        case 300:
        {
            if (btn.selected == YES) {
                _stateBtn1.selected =  _stateBtn2.selected = _stateBtn4.selected = _stateBtn5.selected = NO;
                _stateBtn1.highlighted = _stateBtn2.highlighted = YES;
                self.didSelectedBtnBlock(2);
            }else{
                _stateBtn1.highlighted = _stateBtn2.highlighted = _stateBtn4.highlighted = _stateBtn5.highlighted = NO;
            }
            break;
        }
        case 400:
        {
            if (btn.selected == YES) {
                _stateBtn1.selected =  _stateBtn2.selected = _stateBtn3.selected = _stateBtn5.selected = NO;
                _stateBtn1.highlighted = _stateBtn2.highlighted = _stateBtn3.highlighted = YES;
                self.didSelectedBtnBlock(3);
            }else{
                _stateBtn1.highlighted = _stateBtn2.highlighted = _stateBtn3.highlighted = _stateBtn5.highlighted = NO;
            }
            break;
        }
        case 500:
        {
            if (btn.selected == YES) {
                _stateBtn1.selected =  _stateBtn2.selected = _stateBtn3.selected = _stateBtn4.selected = NO;
                _stateBtn1.highlighted = _stateBtn2.highlighted = _stateBtn3.highlighted = _stateBtn4.highlighted = YES;
                self.didSelectedBtnBlock(4);
            }else{
                _stateBtn1.highlighted = _stateBtn2.highlighted = _stateBtn3.highlighted = _stateBtn4.highlighted = NO;
            }
            break;
        }
        default:
            break;
    }
}


// 设置图片
- (void)setBtnsNormalImage:(NSString *)normalImageName selectedImage:(NSString *)selectedImageName{
    
    [self.stateBtn1 setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [self.stateBtn1 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [self.stateBtn1 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    
    [self.stateBtn2 setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [self.stateBtn2 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [self.stateBtn2 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    
    [self.stateBtn3 setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [self.stateBtn3 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [self.stateBtn3 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    
    [self.stateBtn4 setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [self.stateBtn4 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [self.stateBtn4 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
    
    [self.stateBtn5 setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [self.stateBtn5 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [self.stateBtn5 setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateHighlighted];
}


/*
 
 switch (btn.tag) {
 case 100:
 {
 if (btn.selected == NO) {
 btn.selected = selected;
 }
 _stateBtn2.selected = _stateBtn3.selected = _stateBtn4.selected = _stateBtn5.selected = NO;
 break;
 }
 case 200:
 {
 btn.selected =  _stateBtn1.selected = selected;
 _stateBtn3.selected = _stateBtn4.selected = _stateBtn5.selected = NO;
 break;
 }
 case 300:
 {
 btn.selected =  _stateBtn1.selected = _stateBtn2.selected = selected;
 _stateBtn4.selected = _stateBtn5.selected = NO;
 break;
 }
 case 400:
 {
 btn.selected =  _stateBtn1.selected = _stateBtn2.selected = _stateBtn3.selected = selected;
 _stateBtn5.selected = NO;
 break;
 }
 case 500:
 {
 btn.selected =  _stateBtn1.selected = _stateBtn2.selected = _stateBtn3.selected = _stateBtn4.selected = selected;
 break;
 }
 default:
 break;
 }

 
 */


@end
