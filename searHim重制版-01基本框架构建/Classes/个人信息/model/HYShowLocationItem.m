//
//  HYShowLocationItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/3.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYShowLocationItem.h"


@implementation HYShowLocationItem

- (Boolean)isShowLocation{
    // 从沙盒中读取
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowLocation"];
}

@end
