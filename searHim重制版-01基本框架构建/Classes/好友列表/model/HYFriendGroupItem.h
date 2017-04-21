//
//  HYFriendGroupItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/12.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYFriendGroupItem : NSObject

@property (nonatomic, copy) NSString* header;

//里面装着userInfo对象
@property (nonatomic, strong) NSMutableArray* items;

@end
