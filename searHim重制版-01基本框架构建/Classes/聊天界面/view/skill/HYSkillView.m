//
//  HYSkillView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSkillView.h"
#import "HYSkillButton.h"
#import "HYBaseChatItem.h"

#define HYDelegateCell @"删除cell"

@interface HYSkillView ()

@end

@implementation HYSkillView


+ (instancetype)skillView{
    HYSkillView* skillV = [[HYSkillView alloc] init];
    return skillV;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)tapG{
    [self removeFromSuperview];
}

- (void)setupSubViews{
    UIButton* meng = [[UIButton alloc] init];
    meng.backgroundColor = [UIColor blackColor];
    meng.alpha = 0.3;
    [self addSubview:meng];
    self.meng = meng;
    [meng addTarget:self action:@selector(tapG) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* whiteMen = [[UIView alloc] init];
    whiteMen.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteMen];
    self.whiteMen = whiteMen;
    
    HYSkillButton* sendOtherBtn = [HYSkillButton setupBtnWithTitle:@"转发"];
    [sendOtherBtn addTarget:self action:@selector(sendOther) forControlEvents:UIControlEventTouchUpInside];
    [whiteMen addSubview:sendOtherBtn];
    
    HYSkillButton* deleBtn = [HYSkillButton setupBtnWithTitle:@"删除"];
    [deleBtn addTarget:self action:@selector(dele) forControlEvents:UIControlEventTouchUpInside];
    [whiteMen addSubview:deleBtn];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.meng.frame = self.bounds;
    CGFloat whiteX, whiteY, whiteWid, whiteHei;
    whiteWid = mainScreenWid * 0.6;
    whiteHei = self.whiteMen.subviews.count * skillBtnHei;
    whiteX = (mainScreenWid - whiteWid)*0.5;
    whiteY = (mainScreenHei - whiteHei)*0.4;
    self.whiteMen.frame = CGRectMake(whiteX, whiteY, whiteWid, whiteHei);
    
    CGFloat skillX, skillY, skillWid, skillHei;
    skillWid = self.whiteMen.width;
    skillX = 0;
    skillHei = skillBtnHei;
    int i=0;
    for (HYSkillButton* skillBtn in self.whiteMen.subviews) {
        if ([skillBtn isKindOfClass:[HYSkillButton class]]) {
            skillY = i * skillHei;
            skillBtn.frame = CGRectMake(skillX, skillY, skillWid, skillHei);
            i++;
        }
    }
}


#pragma mark - target

//转发 代理方法
- (void)sendOther{
    [self.deleagte didClickSendOtherBtn:self.baseChatItem];
    [self removeFromSuperview];
}

//删除（发通知让控制器删除对应的模型，cell）
- (void)dele{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.baseChatItem.row) forKey:@"row"];
    [[NSNotificationCenter defaultCenter] postNotificationName:HYDelegateCell object:self userInfo:dict];
    [self removeFromSuperview];
}

@end
