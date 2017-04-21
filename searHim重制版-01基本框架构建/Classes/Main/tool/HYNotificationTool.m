//
//  HYNotificationTool.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/7.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYNotificationTool.h"
#import <AVInstallation.h>
#import <AVUser.h>

@implementation HYNotificationTool

// ios8以后，要请求用户同意
+ (void)setupUserPermission{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        UIUserNotificationSettings* nofiSet = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:nofiSet];
    }
}

//设置本地推送 (程序在后台、已经销毁了)
+ (void)setupLocationNotificaiton{
    UILocalNotification* localNo = [[UILocalNotification alloc] init];
    //设置每天晚上8点推送，则dateWithTimeIntervalSince1970的参数就是每天推送的具体时间
    localNo.fireDate = [NSDate dateWithTimeIntervalSinceNow:20 * 60 * 60];
    localNo.repeatInterval = kCFCalendarUnitDay;
    localNo.timeZone = [NSTimeZone defaultTimeZone];
    
    //设置推送内容
    localNo.alertBody = @"亲，心目中的Ta在等你呢~";
    localNo.alertAction = @"打开寻找Ta";
    localNo.hasAction = YES;
    localNo.alertLaunchImage = @"disan.png";
    localNo.soundName = UILocalNotificationDefaultSoundName;
    
    // 制作取消推送时的通知标识
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"key"] = @"name";
    localNo.userInfo = dict;
    
    // 先判断是否已经添加了推送，没有添加才添加新的
    NSArray<UILocalNotification *> *noArr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    Boolean isIn = false;
    
    for (UILocalNotification* no in noArr) {
        if ([no.alertBody isEqualToString:localNo.alertBody]) { // 已经添加过监听了
            isIn = true;
            break;
        }
    }
    
    if (!isIn) {
        [[UIApplication sharedApplication] scheduleLocalNotification:localNo];
    }
}

+ (BOOL)cancelLocalNotification{
    UIApplication* app = [UIApplication sharedApplication];
    NSArray* arr = [app scheduledLocalNotifications];
    for (UILocalNotification* localNo in arr) {
        if ([localNo.userInfo[@"key"] isEqualToString:@"name"]) {
            [app cancelLocalNotification:localNo];
        }
    }
    
    return NO;
}

/** 设置远程通知，登录以后设置 */
+ (void)setupRemoteNotification{
    /** 使用频道（channel）可以实现「发布—订阅」的模型。设备订阅某个频道，然后发送消息的时候指定要发送的频道即可。*/
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation addUniqueObject:[AVUser currentUser].objectId forKey:@"channels"];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
    }];
}

@end
