//
//  HYMsgTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/14.
//  Copyright © 2016年 黄远. All rights reserved.
//  管理最近消息的工具类

#import <Foundation/Foundation.h>

@class AVIMConversation, HYResponseObject;
@interface HYMsgTool : NSObject

/*
 * 从数据库中加载所有的最近消息
 */
+ (void)loadAllCurrentMsgFromDBsuccess:(void(^)(HYResponseObject* responseObj))succeeded failure:(void(^)(NSError* error))failure;


/*
 * 插入最新的消息数据
 */
+ (void)insertMsgToDBWithOtherObjectId:(NSString *)otherObjectId conversation:(AVIMConversation *)conversation otherIconUrl:(NSString *)otherIcon otherUsername:(NSString *)otherUsername lastMessageAtStr:(NSString*)temStr lastContent:(NSString *)lastContent unreadCount:(NSUInteger)unreadCount;


/*
 * 更新消息数据
 */
+ (void)reloadMsgToDBWithOtherObjectId:(NSString*)otherObjectId conversation:(AVIMConversation*)conversation otherIconUrl:(NSString*)otherIcon otherUsername:(NSString*)otherUsername lastMessageAtStr:(NSString*)temStr lastContent:(NSString*)lastContent unreadCount:(NSUInteger)unreadCount;

+ (void)deleteMsgWithOtherObjectId:(NSString*)otherObjectId imObjectId:(NSString*)imObjectId;

@end
