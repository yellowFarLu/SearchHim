//
//  AppDelegate.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYUserInfo, FMDatabase;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//部分用户的基本信息(用于展示瀑布流)
@property (nonatomic, strong) NSArray* allUserInfo;

//当前用户信息
@property (nonatomic, strong) HYUserInfo* imUserInfo;

- (FMDatabase*)_db;

//发布通知，让mapkit和各种需要userInfo的控制器加载
- (void)isGetInfo;
@end

