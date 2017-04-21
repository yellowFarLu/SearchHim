//
//  HYDiverVersionTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/11/6.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDiverVersionTool : NSObject

/** 判断机型 */
+ (NSString*)deviceVersion;

/** 获取平台 */
+ (NSString *)platform;

/** 判断是否是IPAD */
+ (Boolean)isPad;

@end
