//
//  HYUserInfo.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//  保存用户信息，图片和描述searchHim用于显示瀑布流，然后所有信息都可以展示在用户信息界面上

#import <Foundation/Foundation.h>
@class AVUser;
@interface HYUserInfo : NSObject <NSCoding>

//基本信息
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* sex;
@property (nonatomic, copy) NSString* mobilePhoneNumber;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* city;

//图片相关
//@property (nonatomic, copy) UIImage* icon;
@property (nonatomic, strong) NSNumber* iconWid;
@property (nonatomic, strong) NSNumber* iconHei;
@property (nonatomic, copy) NSString* iconUrl;

/** 介绍下自己 */
@property (nonatomic, copy) NSString* aboutMe;

// 心目中的他/她
@property (nonatomic, copy) NSString* searchHim;

//用户的objectId
@property (nonatomic, copy) NSString* objectId;

- (instancetype)initWithDict:(NSDictionary*)dict;
+ (instancetype)initOfDict:(NSDictionary*)dict;

+ (instancetype)initOfUser:(AVUser*)user;

@end
