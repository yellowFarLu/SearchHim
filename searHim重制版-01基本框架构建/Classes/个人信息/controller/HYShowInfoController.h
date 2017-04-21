//
//  HYFriendInfoController.h
//  SearchHim
//
//  Created by 黄远 on 16/4/27.
//  Copyright © 2016年 黄远. All rights reserved.
//  展示信息的父类

#import <UIKit/UIKit.h>
#import "HYCommonTableViewController.h"
@class HYUserInfo;
@class AVObject;

@interface HYShowInfoController : HYCommonTableViewController

#warning 这个用户信息对象可以赋值为当前用户信息对象，也可以赋值为其他用户信息对象
@property (nonatomic, strong) HYUserInfo* imUsrInfo;


- (UITableView*)tableView;

- (void)addGroupModel;

- (void)setupModel;

@end
