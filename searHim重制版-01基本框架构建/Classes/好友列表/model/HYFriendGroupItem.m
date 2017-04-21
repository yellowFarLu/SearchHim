//
//  HYFriendGroupItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/12.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYFriendGroupItem.h"

@implementation HYFriendGroupItem

- (NSMutableArray*)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}


@end
