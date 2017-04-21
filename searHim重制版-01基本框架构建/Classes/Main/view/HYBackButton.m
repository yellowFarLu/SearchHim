//
//  HYBackButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/9/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBackButton.h"

@implementation HYBackButton

+ (instancetype)backButton{
    HYBackButton* backBtn = [[HYBackButton alloc] init];
    return backBtn;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"返回" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:backBtnColor forState:UIControlStateHighlighted];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return self;
}

@end
