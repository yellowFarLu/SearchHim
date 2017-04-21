//
//  NSDate+HYRealDate.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/26.
//  Copyright © 2016年 黄远. All rights reserved.
//  把date和字符创之间转化

#import <Foundation/Foundation.h>

@interface NSDate (HYRealDate)

//date转字符串
- (NSString*)stringFromDate;

//将以前的字符串转成date，并返回date对应的相对于现在时间的字符串
+ (NSString*)currentStringFromPreString:(NSString*)preStr;

//字符串转成date
+ (instancetype)dateFromString:(NSString*)str;

//date转成用户能看懂的字符串
- (NSString *)userStringFromDate;

@end
