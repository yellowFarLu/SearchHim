//
//  HYBottomItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//  存放心目中的他或她的标准

#import <Foundation/Foundation.h>
#import "HYBaseItem.h"

@interface HYBottomItem : HYBaseItem
@property (nonatomic, copy) NSString* aboutHimOrShe;
@property (nonatomic, copy) NSString* aboutMe;
/** 判断是心目中的Ta，还是对自己的评价 */
@property (nonatomic, assign, getter=isMe) BOOL me;

@end
