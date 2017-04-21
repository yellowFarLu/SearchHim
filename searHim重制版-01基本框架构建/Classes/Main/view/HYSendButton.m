//
//  HYSendButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/9/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYSendButton.h"

@implementation HYSendButton

+ (instancetype)sendButton{
    return [[HYSendButton alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"发送" forState:UIControlStateNormal];
        self.titleLabel.font = HYValueFont;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    }
    return self;
}

@end
