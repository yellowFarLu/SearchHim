//
//  HYBlackTableButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/16.
//  Copyright © 2016年 黄远. All rights reserved.
//  加入黑名单按钮

#import "HYBlackTableButton.h"

@implementation HYBlackTableButton

+ (instancetype)blackTableButton{
    return [[HYBlackTableButton alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTitle:@"拉黑" forState:UIControlStateNormal];
        // 到时换拉黑的图片
        [self setImage:[UIImage imageWithOriginalName:@"reportIma.png"] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}


@end
