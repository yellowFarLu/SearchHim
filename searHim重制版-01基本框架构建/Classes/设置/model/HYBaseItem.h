//
//  HYBaseItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYBaseItem : NSObject

@property (nonatomic, assign, getter=isTheLast) bool theLast;
/** 判断是否别人的信息 */
@property (nonatomic, assign, getter=isOtherInfo) BOOL other;

@end
