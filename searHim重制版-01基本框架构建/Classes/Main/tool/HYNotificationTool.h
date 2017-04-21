//
//  HYNotificationTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/7.
//  Copyright © 2016年 黄远. All rights reserved.
//  推送工具类

#import <Foundation/Foundation.h>

@interface HYNotificationTool : NSObject

//设置本地推送
+ (void)setupLocationNotificaiton;

/** 订阅自己 */
+ (void)setupRemoteNotification;

// ios8以后，要请求用户同意
+ (void)setupUserPermission;

/** 取消推送 */
+ (BOOL)cancelLocalNotification;



@end
