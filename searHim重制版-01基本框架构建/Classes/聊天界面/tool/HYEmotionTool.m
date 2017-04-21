//
//  HYEmotionTool.m
//  新浪微博
//
//  Created by 黄远 on 16/6/17.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionTool.h"
#import "MJExtension.h"
#import "HYEmotion.h"
#define path [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentEmotion.data"]
#import "UIImage+Exstension.h"

@implementation HYEmotionTool


/** 默认表情 */
static NSArray *_defaultEmotions;
/** emoji表情 */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;
/*
 * 最近表情
 */
static NSMutableArray* _recentEmotions;


+ (UIImage *)imageWithCht:(NSString *)cht{
    UIImage* emotionIma = nil;
    for (HYEmotion* obj in [self defaultEmotions]) {
        if ([obj.cht isEqualToString:cht] || [obj.chs isEqualToString:cht]) {
            NSString* imaPath = [NSString stringWithFormat:@"%@%@", obj.directory, obj.png];
            emotionIma = [UIImage imageWithOriginalName:imaPath];
            break;
        }
    }
    
    if (emotionIma) {
        return emotionIma;
    }
    
    for (HYEmotion* obj in [self lxhEmotions]) {
        if ([obj.cht isEqualToString:cht] || [obj.chs isEqualToString:cht]) {
            NSString* imaPath = [NSString stringWithFormat:@"%@%@", obj.directory, obj.png];
            emotionIma = [UIImage imageWithOriginalName:imaPath];
            break;
        }
    }
    
    return emotionIma;
}


+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/defaultInfo.plist" ofType:nil];
        _defaultEmotions = [HYEmotion objectArrayWithFile:plist];
        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default/"];
    }
    return _defaultEmotions;
}

+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/emojiInfo.plist" ofType:nil];
        _emojiEmotions = [HYEmotion objectArrayWithFile:plist];
        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/emoji/"];
    }
    return _emojiEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/lxhInfo.plist" ofType:nil];
        _lxhEmotions = [HYEmotion objectArrayWithFile:plist];
        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh/"];
    }
    return _lxhEmotions;
}

+ (NSMutableArray*)recentEmotions{
    if (!_recentEmotions) {
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_recentEmotions) {
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

+ (void)saveRecentEmotion:(HYEmotion *)emotion{
    if (!_recentEmotions) {
       [self recentEmotions];  //第一次使用为空，先调用get方法，生成空间。
    }
    
    [_recentEmotions removeObject:emotion];
    [_recentEmotions insertObject:emotion atIndex:0];
 
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:path];
}


@end
