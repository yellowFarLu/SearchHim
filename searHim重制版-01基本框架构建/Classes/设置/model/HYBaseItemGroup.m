//
//  HYBaseItemGroup.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseItemGroup.h"

@implementation HYBaseItemGroup

- (NSMutableArray*)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
