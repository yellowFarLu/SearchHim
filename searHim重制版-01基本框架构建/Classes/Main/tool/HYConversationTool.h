//
//  HYConversationTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//  用于处理对conversation的请求

#import <Foundation/Foundation.h>
@class AVIMConversation, HYResponseObject;

@interface HYConversationTool : NSObject

//返回otherObjectId对应的conversation(从数据库查询)
+ (void)queryConversationWithOtherObjId:(NSString*)otherObjectId success:(void(^)(HYResponseObject* responseObj))succeeded failure:(void(^)(NSError* error))failure;


@end
