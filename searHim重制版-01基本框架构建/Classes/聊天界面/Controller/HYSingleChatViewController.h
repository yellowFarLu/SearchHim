//
//  HYSingleChatViewController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCommonTableViewController.h"
@class HYUserInfo, AVIMConversation;

@interface HYSingleChatViewController : HYCommonTableViewController

//HYUserInfo是全局使用的，面向HYUserInfo开发更加合理
@property (nonatomic, strong) HYUserInfo* otherUserInfo;

//当前对话
@property (nonatomic, strong) AVIMConversation* conversation;

//根据来源控制器，设置按钮
@property (nonatomic, weak) UIViewController* sourceVC;

@end
