//
//  HYCardItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//  名片模型

#import "HYBaseChatItem.h"
@class HYUserInfo;
@interface HYCardItem : HYBaseChatItem

@property (nonatomic, strong) HYUserInfo* userInfo;

@end
