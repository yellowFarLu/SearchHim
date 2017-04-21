//
//  NSDate+HYDate.h
//  新浪微博
//
//  Created by 黄远 on 16/6/12.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HYDate)

/*
 * 是否相差一小时
 */
- (BOOL)isOneHourFromNow;


/*
 * 差距为1小时内，相差多少分钟
 */
- (NSInteger)inOneHourOutOfMinue;

/*
 * 超多当前多少小时
 */
- (NSInteger)OutSomeHourFromNow;


/*
 * 是否今年
 */
- (BOOL)isNowYear;

//是否这个月
- (BOOL)isNowMonth;

- (BOOL)isToday;

/*
 * 是否一个小时内
 */
- (BOOL)isCurrentHour;


/*
 * 是否一分钟内
 */
- (BOOL)isCurrrentSecond;

/*
 * 是否是昨天
 */
- (BOOL)isLastDay;

/*
 * 是否大于一分钟
 */

- (BOOL)isOutOneMiu;

/*
 * 返回超多当前小时内多少分钟
 */
- (NSInteger)OutSomeMinueFromNow;

/*
 * 比较两个date谁比较早 // 用于date的排序
 */
+ (NSComparisonResult)compareWithDateOne:(NSDate*)dateOne dateTwo:(NSDate*)dateTwo;





@end
