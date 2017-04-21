//
//  HYUserInfoTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYResponseObject.h"
#import "HYParamters.h"

@interface HYUserInfoTool : NSObject


/*    ********
 * 加载部分用户对象的所有属性   每一个用户信息对应一个模型，在这个方法中加载好模型，然后传给控制器
 */
+ (void)loadAllPersonInfoWithParamters:(HYParamters*)paramters success:(void(^)(HYResponseObject* responseObject))success failure:(void(^)(NSError* error)) failure;

/*
 * 加载更多用户属性
 */
+ (void)loadMorePersonInfoWithParamters:(HYParamters*)paramters success:(void(^)(HYResponseObject* responseObject))success failure:(void(^)(NSError* error)) failure;

/*
 * 查询相关的用户
 */
+ (void)queryUserInfoWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *responseObject))success failure:(void (^)(NSError *error))failure;


///////////////////////////////////////朋友/////////////////////////////////////////////

/*
 * 加载所有朋友对象的所有属性   每一个用户信息对应一个模型，在这个方法中加载好模型，然后传给控制器
 */
+ (void)loadAllFriendInfoWithParamters:(HYParamters*)paramters success:(void(^)(HYResponseObject* responseObject))success failure:(void(^)(NSError* error)) failure;

//存储朋友信息到数据库
+ (void)saveFriendInDB:(HYUserInfo*)userInfo WithParamter:(HYParamters*)panremters;

//删除一条朋友的信息
+ (void)deleteFriendFromDB:(HYUserInfo*)userInfo WithParamter:(HYParamters*)panremters;

/** 更新自己的信息到数据库 */
+ (void)saveImInDB:(HYUserInfo*)imUserInfo ForKey:(NSString*)key WithValue:(NSString*)value;

//查讯该id是否是好友
+ (BOOL)queryFriendIsInDB:(HYUserInfo*)userInfo WithParamter:(HYParamters*)panremters;

//从网络加载好友信息
+ (void)loadFriendInfoFromInternetWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *responseObject))success failure:(void (^)(NSError *error))failure;

/*
 * 查询相关的好友
 */
+ (void)queryFriendUserInfoWithParamters:(HYParamters *)paramters success:(void (^)(HYResponseObject *responseObject))success failure:(void (^)(NSError *error))failure;

#pragma mark - 黑名单系统
/** 添加好友进入黑名单 */
+ (Boolean)putUser:(HYUserInfo*)userInfo ToBlackTableWithParamters:(HYParamters *)paramters;

/** 查询用户是否在黑名单中 */
+ (Boolean)UserisInBlackTable:(HYUserInfo*)userInfo;

/** 从黑名单中删除用户 */
+ (Boolean)DeleteUserInBlackTable:(HYUserInfo*)userInfo;







@end
