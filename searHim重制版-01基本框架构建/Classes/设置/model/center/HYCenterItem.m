//
//  HYCenterItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCenterItem.h"

@implementation HYCenterItem

- (instancetype)initWithInfo:(NSString *)info andKey:(NSString*)key{
    self.info = info;
    self.key = key;
    return self;
}


- (void)setInfo:(NSString *)info{
    if (info == nil) {
        _info = @"未知";
        return;
    }
    _info = info;
}

@end
