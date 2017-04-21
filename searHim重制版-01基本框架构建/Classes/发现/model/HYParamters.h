//
//  HYParamters.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYParamters : NSObject

//用户名
@property (nonatomic, copy) NSString* username;

//查询限制
@property (nonatomic, assign) NSInteger limit;

//查询包含的字符串
@property (nonatomic, copy) NSString* containsString;

@end
