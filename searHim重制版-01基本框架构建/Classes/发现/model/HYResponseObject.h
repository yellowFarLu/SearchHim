//
//  HYResponseObject.h
//  新浪微博
//
//  Created by 黄远 on 16/6/10.
//  Copyright © 2016年 黄远. All rights reserved.
//  返回结构的模型

#import <Foundation/Foundation.h>
@class AVIMConversation;

@interface HYResponseObject : NSObject
/*
 * 返回的数组
 */
@property (nonatomic, strong) NSArray* resultInfo;


/*
 * 返回的会话
 */
@property (nonatomic, strong) AVIMConversation* conversation;



@end
