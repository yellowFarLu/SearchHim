//
//  NSDate+HYDate.m
//  新浪微博
//
//  Created by 黄远 on 16/6/12.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "NSDate+HYDate.h"

@implementation NSDate (HYDate)

/*
 * 比较两个date谁比较早 // 用于date的排序
 */
+ (NSComparisonResult)compareWithDateOne:(NSDate*)dateOne dateTwo:(NSDate*)dateTwo{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger temOne,temTwo;
    NSComparisonResult result;
    // 比较年分，看哪个小
    temOne = [calender component:NSCalendarUnitYear fromDate:dateOne];
    temTwo = [calender component:NSCalendarUnitYear fromDate:dateTwo];
    if (temOne > temTwo) {
        result = NSOrderedAscending;
    } else if(temOne < temTwo) {
        result = NSOrderedDescending;
    } else{
        // 年份相同，比较月份
        temOne = [calender component:NSCalendarUnitMonth fromDate:dateOne];
        temTwo = [calender component:NSCalendarUnitMonth fromDate:dateTwo];
        if (temOne > temTwo) {
            result = NSOrderedAscending;
        } else if(temOne < temTwo) {
            result = NSOrderedDescending;
        } else{
            // 年份和月份相同，比较天数
            temOne = [calender component:NSCalendarUnitDay fromDate:dateOne];
            temTwo = [calender component:NSCalendarUnitDay fromDate:dateTwo];
            if (temOne > temTwo) {
                result = NSOrderedAscending;
            } else if(temOne < temTwo) {
                result = NSOrderedDescending;
            } else{
                // 年份，月份，天数相同，比较小时
                temOne = [calender component:NSCalendarUnitHour fromDate:dateOne];
                temTwo = [calender component:NSCalendarUnitHour fromDate:dateTwo];
                if (temOne > temTwo) {
                    result = NSOrderedAscending;
                } else if(temOne < temTwo) {
                    result = NSOrderedDescending;
                } else{
                    // 年份，月份，天数，小时相同，比较分钟
                    temOne = [calender component:NSCalendarUnitMinute fromDate:dateOne];
                    temTwo = [calender component:NSCalendarUnitMinute fromDate:dateTwo];
                    if (temOne > temTwo) {
                        result = NSOrderedAscending;
                    } else if(temOne < temTwo) {
                        result = NSOrderedDescending;
                    } else{
                        // 还是相同，比较秒
                        temOne = [calender component:NSCalendarUnitSecond fromDate:dateOne];
                        temTwo = [calender component:NSCalendarUnitSecond fromDate:dateTwo];
                        if (temOne > temTwo) {
                            result = NSOrderedAscending;
                        } else if(temOne < temTwo) {
                            result = NSOrderedDescending;
                        } else{
                            result = NSOrderedSame;
                        }
                    }

                }
            }

        }
    }
    
    return result;
}


/*
 * 差距为1小时内，相差多少分钟
 */
- (NSInteger)inOneHourOutOfMinue{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoMiu = [calender component:NSCalendarUnitMinute fromDate:self];
    NSInteger currentMiu = [calender component:NSCalendarUnitMinute fromDate:[NSDate date]];
    return ((currentMiu + 60) - weiBoMiu);
}


/*
 * 是否相差一小时
 */
- (BOOL)isOneHourFromNow{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoHour = [calender component:NSCalendarUnitHour fromDate:self];
    NSInteger currentHour = [calender component:NSCalendarUnitHour fromDate:[NSDate date]];
    return (currentHour - weiBoHour) == 1;
}

/*
 * 超多当前多少小时
 */
- (NSInteger)OutSomeHourFromNow{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoHour = [calender component:NSCalendarUnitHour fromDate:self];
    NSInteger currentHour = [calender component:NSCalendarUnitHour fromDate:[NSDate date]];
    return (currentHour - weiBoHour);
}


/*
 * 是否今年
 */
- (BOOL)isNowYear{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoyear = [calender component:NSCalendarUnitYear fromDate:self];
    NSInteger currentYear = [calender component:NSCalendarUnitYear fromDate:[NSDate date]];
    return (weiBoyear == currentYear);
}

- (BOOL)isNowMonth{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoMonth = [calender component:NSCalendarUnitMonth fromDate:self];
    NSInteger currentMonth = [calender component:NSCalendarUnitMonth fromDate:[NSDate date]];
    return (weiBoMonth == currentMonth);
}


- (BOOL)isToday{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoDay = [calender component:NSCalendarUnitDay fromDate:self];
    NSInteger currentDay = [calender component:NSCalendarUnitDay fromDate:[NSDate date]];
    return (weiBoDay == currentDay);
}


/*
 * 是否一个小时内(前提天数，多少号相同)
 */
- (BOOL)isCurrentHour{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoHour = [calender component:NSCalendarUnitHour fromDate:self];
    NSInteger currentHour = [calender component:NSCalendarUnitHour fromDate:[NSDate date]];
    return (weiBoHour == currentHour);
}


/*
 * 是否一分钟内 (这里用秒数相减，前提是小时，分钟相同)
 */
- (BOOL)isCurrrentSecond{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoSecond = [calender component:NSCalendarUnitSecond fromDate:self];
    NSInteger currentSecond = [calender component:NSCalendarUnitSecond fromDate:[NSDate date]];
//    HYLog(@"%@", [NSDate date]);
    return (weiBoSecond - currentSecond) <= 60;
}




/*
 * 是否是昨天
 */
- (BOOL)isLastDay{
    //关键： 与今天的天数相差为1
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoDay = [calender component:NSCalendarUnitDay fromDate:self];
    NSInteger currentDay = [calender component:NSCalendarUnitDay fromDate:[NSDate date]];
    return (currentDay - weiBoDay) == 1;
}


- (BOOL)isOutOneMiu{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoMiu = [calender component:NSCalendarUnitMinute fromDate:self];
    NSInteger currentMiu = [calender component:NSCalendarUnitMinute fromDate:[NSDate date]];
    return (currentMiu - weiBoMiu) > 1;
}

- (NSInteger)OutSomeMinueFromNow{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSInteger weiBoMiu = [calender component:NSCalendarUnitMinute fromDate:self];
    NSInteger currentMiu = [calender component:NSCalendarUnitMinute fromDate:[NSDate date]];
    return (currentMiu - weiBoMiu);
}




@end
