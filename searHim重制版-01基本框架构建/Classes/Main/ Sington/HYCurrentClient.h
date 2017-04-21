//
//  HYCurrentClient.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/14.
//  Copyright © 2016年 黄远. All rights reserved.
//   单例对象，用于程序在前台接收消息；

#import <Foundation/Foundation.h>
@class HYCurrentClient, AVIMTypedMessage, AVIMConversation, AVIMClient;

@protocol HYCurrentClientDelegate <NSObject>

@required
//处理聊天信息
- (void)currentClient:(HYCurrentClient*)currentClient ReceiveMsg:(AVIMTypedMessage*)msg andConversation:(AVIMConversation *)conversation;

@end



@interface HYCurrentClient : NSObject 

//返回单例对象
+ (instancetype)shareCurrentClient;

//与服务器建立长链接，开启聊天
- (void)openLongCallBackToSever:(void(^)(BOOL succeeded))success fauil:(void(^)(NSError* error))fauil;

@property (nonatomic, weak) id<HYCurrentClientDelegate> delegate;

- (AVIMClient*)imClient;

- (void)setImClient:(AVIMClient *)imClient;

- (NSTimer*)queryStatusTimer;

@end
