//
//  HYNetTool.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/24.
//  Copyright © 2016年 黄远. All rights reserved.
//  监听网络状态

#import <Foundation/Foundation.h>


@interface HYNetTool : NSObject

//在wife状态下
+ (BOOL)isInWife;

//在有网络状态下
+ (BOOL)isInConnectNet;

//在有网络状态下(非wife)
+ (BOOL)isInConnectNetNotWife;


@end
