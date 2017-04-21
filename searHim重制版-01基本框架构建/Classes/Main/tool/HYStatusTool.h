//
//  HYStatusTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/12.
//  Copyright © 2016年 黄远. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "HYStatusParamters.h"
#import "HYStatusResultParamters.h"
@class HYNewFriendItem;


@interface HYStatusTool : NSObject

/*
 * 请求新的status
 */
+ (void)loadStatusWithParamters:(HYStatusParamters*)paramters success:(void(^)(HYStatusResultParamters* resultParamters))success failure:(void(^)(NSError* err))failure;

+ (void)saveWithItem:(HYNewFriendItem*)newFriendItem;

+ (NSArray*)statusFromDB;

+ (void)deleteStatusWithParamters:(HYStatusParamters*)paramters success:(void(^)(HYStatusResultParamters* resultParamters))success failure:(void(^)(NSError* err))failure;

@end