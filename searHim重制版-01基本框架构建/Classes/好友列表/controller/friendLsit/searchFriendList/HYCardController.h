//
//  HYCardController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//  展示名片

#import "HYBaseFriendListController.h"

@class HYCardController;
@protocol HYCardControllerDeleagte <NSObject>
@required
- (void)cardVC:(HYCardController*)cardVC didSelectedCard:(HYUserInfo*)userIno;

@end

@interface HYCardController : HYBaseFriendListController

@property (nonatomic, weak) id<HYCardControllerDeleagte> delegate;
@end
