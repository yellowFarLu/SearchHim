//
//  HYCurrentMsgItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/14.
//  Copyright © 2016年 黄远. All rights reserved.
//  最新消息的模型   

#import <Foundation/Foundation.h>
@class AVIMConversation, HYUserInfo;

@interface HYCurrentMsgItem : NSObject

//最近消息模型设计：（conversation对象，他人聊天头像，名称，最后更新时间，最后一句话）
@property (nonatomic, strong) AVIMConversation* conversation;

@property (nonatomic, strong) HYUserInfo* otherUserInfo;

//对话中最后一条信息的发送时间
@property (nonatomic, strong) NSDate* lastMessageAt;
//对话中最后一条信息的发送时间(字符串形式)
@property (nonatomic, copy) NSString* lastMessageAtString;
@property (nonatomic, copy) NSString* preLastMessageAtString;

//最后一句消息
@property (nonatomic, copy) NSString* lastContent;

//未读消息数 (用户点开消息cell的时候，清0)
@property (nonatomic, assign) NSUInteger unReadCount;

//展示红点
@property (nonatomic, assign, getter=isShowRing) BOOL showRing;

//便于后面刷新
@property (nonatomic, assign) NSUInteger row;

//用于保存的时间
@property (nonatomic, copy) NSString* timeStr;

@end
