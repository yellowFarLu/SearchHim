//
//  HYMarkTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//  用于记录处理发现中，用户查询的痕迹 (一个用户对应一组使用痕迹)

#import <Foundation/Foundation.h>

@interface HYMarkTool : NSObject

+ (void)saveMarkInDB:(NSString*)mark WithImObjectId:(NSString*)imObjectId;

+ (NSMutableArray*)loadMarkFromDBWithImObjectId:(NSString*)imObjectId;

+ (void)deleteAllMarkWithImObjectId:(NSString*)imObjectId;

@end
