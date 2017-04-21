//
//  HYBaseFriendListController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//  展示通讯录父类

#import "HYCommonTableViewController.h"
#import "HYFriendGroupItem.h"
#import "HYUserInfo.h"
#import "HYUserInfoTool.h"
#import "HYPinyinOC.h"
#import "HYFriendListCell.h"
#import "HYNewFriendRequestController.h"
#import "HYSearchBar.h"
#import "HYMarkController.h"
#import "HYMarkTool.h"
#define HYSearBarHei 44
@class HYSearchBar, HYMarkController;

@interface HYBaseFriendListController : HYCommonTableViewController <HYSearchBarDelegate, HYMarkControllerDelegate>

- (void)initGroup;

- (void)addItemWithArr:(NSArray*)resultInfo;

- (void)addGroup;

@property (nonatomic, weak) HYSearchBar* searchBar;
@property (nonatomic, strong) HYMarkController* markVC;

@end
