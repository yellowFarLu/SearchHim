//
//  NSDate+HYRealDate.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/26.
//  Copyright © 2016年 黄远. All rights reserved.
//  

#import "NSDate+HYRealDate.h"
#import "NSDate+HYDate.h"

@implementation NSDate (HYRealDate)

//date转成  EEE MMM dd HH:mm:ss Z yyyy格式字符串
- (NSString *)stringFromDate{
    NSString* tem = nil;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    tem = [dateFormatter stringFromDate:self];
    return tem;
}

//将以前的字符串转成date，并返回date对应的相对于现在时间的字符串
+ (NSString*)currentStringFromPreString:(NSString*)preStr{
    if (preStr == nil) {
        return @"未知";
    }
    
    NSString* currentString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 将字符串(NSString)转成时间对象(NSDate), 方便进行日期处理
    NSDate *date = [dateFormatter dateFromString:preStr];
    
    if ([date isNowYear]) {
        if ([date isNowMonth]) {
            if ([date isToday]) {
                if ([date isCurrentHour]) {
                    if ([date isOutOneMiu]) {
                        currentString = [NSString stringWithFormat:@"%ld分钟前", [date OutSomeMinueFromNow]];
                    } else {
                        currentString = @"刚刚";
                    }
                    
                } else {
                    //看是否相差一个小时，相差一个小时，应该显示%ld分钟前， 否则显示多少小时前。
                    if ([date isOneHourFromNow]) {
                        NSInteger minue = [date inOneHourOutOfMinue];
                        if (minue < 60) {
                            currentString = [NSString stringWithFormat:@"%ld分钟前", minue];
                        } else {
                            currentString = [NSString stringWithFormat:@"1小时前"];
                        }
                    } else {
                        currentString = [NSString stringWithFormat:@"%ld小时前", [date OutSomeHourFromNow]];
                    }
                }
                
            }else{
                if ([date isLastDay]) { //是否昨天 xx:xx
                    dateFormatter.dateFormat = @"昨天 HH:mm";
                    currentString = [dateFormatter stringFromDate:date];
                }else{  //前天发的而且是今年内
                    // 04-23 xx:xx
                    dateFormatter.dateFormat = @"MM-dd HH:mm";
                    currentString = [dateFormatter stringFromDate:date];
                }
            }

        } else {
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            currentString = [dateFormatter stringFromDate:date];
        }
        
    } else {
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        currentString = [dateFormatter stringFromDate:date];
    }

    
    
    return currentString;
}


//字符串转成date
+ (instancetype)dateFromString:(NSString*)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    // 将字符串(NSString)转成时间对象(NSDate), 方便进行日期处理
    NSDate *date = [dateFormatter dateFromString:str];
    
    return date;
}

//date转成用户能看懂的字符串
- (NSString *)userStringFromDate{
    NSString* preStr = [self stringFromDate];
    return [NSDate currentStringFromPreString:preStr];
}

@end
