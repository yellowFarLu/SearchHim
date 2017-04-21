//
//  HYBaseChatItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//  基础聊天模型

#import <Foundation/Foundation.h>

@interface HYBaseChatItem : NSObject
//父类Item：iconUrl, time
@property (nonatomic, copy) NSString* iconUrl;
@property (nonatomic, copy) NSString* lastMessageAtString;

//用于保存的时间
@property (nonatomic, copy) NSString* timeStr;

//判断是不是我发的
@property (nonatomic, assign, getter=isMe) BOOL me;

//判断时间要不要显示
@property (nonatomic, assign, getter=isShowTime) BOOL showTime;

//用不用显示指示器
@property (nonatomic, assign, getter=isShowIndicator) BOOL showIndicator;

//当前所处行数，用于回调刷新cell
@property (nonatomic, assign) NSUInteger row;


//用于查询历史消息记录
@property (nonatomic, copy) NSString* msgId;
@property (nonatomic, assign) int64_t timestamp;
//利用 他人id + 本人id + 64随机串 + 时间戳  这个字符串作为key 存储一个BOOL,表示这条消息要不要展示
@end
