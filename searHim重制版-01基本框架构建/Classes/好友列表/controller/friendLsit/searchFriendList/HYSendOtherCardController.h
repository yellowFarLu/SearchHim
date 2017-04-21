//
//  HYSendOtherCardController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/6.
//  Copyright © 2016年 黄远. All rights reserved.
//  展示转发的候选人列表

#import "HYBaseFriendListController.h"
@class HYBaseChatItem;

@protocol HYSendOtherCardControllerDelegate <NSObject>

/** 转发到当前页面 */
- (void)sendMsgToCurrentSingleCharRoomWithChatItem:(HYBaseChatItem*)baseChatItem;

@end


@interface HYSendOtherCardController : HYBaseFriendListController

/** 当前聊天的人 */
@property (nonatomic, strong) NSString* otherObjId;

//转发的内容
@property (nonatomic, strong) HYBaseChatItem* baseChatItem;

@property (nonatomic, weak) id<HYSendOtherCardControllerDelegate> delegate;

@end
