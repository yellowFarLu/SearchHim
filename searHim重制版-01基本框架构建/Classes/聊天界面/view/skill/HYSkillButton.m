//
//  HYSkillButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/5.
//  Copyright © 2016年 黄远. All rights reserved.
//  

#import "HYSkillButton.h"

@interface HYSkillButton ()

@property (nonatomic, weak) UIView* diver;

@end

@implementation HYSkillButton

+ (instancetype)setupBtnWithTitle:(NSString*)title{
    HYSkillButton* skillBtn = [HYSkillButton buttonWithType:UIButtonTypeSystem];
    [skillBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [skillBtn setBackgroundColor:[UIColor whiteColor]];
    skillBtn.titleLabel.font = HYValueFont;
    [skillBtn setTitle:title forState:UIControlStateNormal];
    skillBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    skillBtn.contentEdgeInsets = UIEdgeInsetsMake(0, HYSearHimInset, 0, 0);
    skillBtn.alpha = 0.8;
    
    return skillBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIView* diver = [[UIView alloc] init];
        diver.backgroundColor = [UIColor grayColor];
        diver.alpha = 0.3;
        [self addSubview:diver];
        self.diver = diver;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat hei = 1;
    self.diver.frame = CGRectMake(0, self.height - hei, self.width, hei);
    
}






@end
