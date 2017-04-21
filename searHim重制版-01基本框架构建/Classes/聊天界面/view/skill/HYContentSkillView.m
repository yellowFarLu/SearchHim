//
//  HYContentSkillView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/6.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYContentSkillView.h"
#import "HYSkillButton.h"
#import "HYContentItem.h"

@implementation HYContentSkillView

+ (instancetype)skillView{
    HYContentSkillView* skillV = [[HYContentSkillView alloc] init];
    return skillV;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    [super setupSubViews];
    HYSkillButton* copyBtn = [HYSkillButton setupBtnWithTitle:@"复制"];
    [copyBtn addTarget:self action:@selector(copyTitle) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteMen insertSubview:copyBtn atIndex:0];
}

//复制文字
- (void)copyTitle{
    UIPasteboard* pab = [UIPasteboard generalPasteboard];
    HYContentItem* contentItem = (HYContentItem*)self.baseChatItem;
    [pab setString:contentItem.realString];
    [self removeFromSuperview];
}

@end
