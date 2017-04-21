//
//  HYParamters.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYParamters.h"

@implementation HYParamters

- (NSInteger)limit{
    return _limit > 0 ? _limit : MAXFLOAT;
}

@end
