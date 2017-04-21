//
//  HYEmotionTool.h
//  新浪微博
//
//  Created by 黄远 on 16/6/17.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HYEmotion;

@interface HYEmotionTool : NSObject

/**
 *  默认表情
 */
+ (NSArray *)defaultEmotions;
/**
 *  emoji表情
 */
+ (NSArray *)emojiEmotions;
/**
 *  浪小花表情
 */
+ (NSArray *)lxhEmotions;
/**
 *  最近表情
 */
+ (NSArray *)recentEmotions;

+ (void)saveRecentEmotion:(HYEmotion*)emotion;

+ (UIImage*)imageWithCht:(NSString*)cht;


@end
