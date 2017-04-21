//
//  HYContentItem.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//  文字模型

#import "HYContentItem.h"
#import "RegexKitLite.h"
#import "HYEmotionResult.h"
#import "HYEmotionTool.h"

// 正文字体颜色
#define HMStatusHighTextColor customColor(88, 161, 253)
// 富文本里面出现的链接
#define HMLinkText @"HMLinkText"
@implementation HYContentItem

- (NSMutableArray*)temArrWithText:(NSString*)text{
    NSMutableArray* temArr = [NSMutableArray array];
    
    NSString* Regex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    //截取图标的描述
    [text enumerateStringsMatchedByRegex:Regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HYEmotionResult* resultStr = [[HYEmotionResult alloc] init];
        resultStr.resultStr = *capturedStrings;
        resultStr.range = *capturedRanges;
        resultStr.emotion = YES;
        [temArr addObject:resultStr];
    }];
    
    //截取文本
    [text enumerateStringsSeparatedByRegex:Regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        //        HYLog(@"%@ --- %@", *capturedStrings, NSStringFromRange(*capturedRanges));
        HYEmotionResult* resultStr = [[HYEmotionResult alloc] init];
        resultStr.resultStr = *capturedStrings;
        resultStr.range = *capturedRanges;
        resultStr.emotion = NO;
        [temArr addObject:resultStr];
    }];
    
    [temArr sortUsingComparator:^NSComparisonResult(HYEmotionResult* obj1, HYEmotionResult* obj2) {
        return [@(obj1.range.location) compare:@(obj2.range.location)];
    }];
    
    return temArr;
}



- (void)setContentWithMsgText:(NSString*)text{
    NSMutableAttributedString* richString = [[NSMutableAttributedString alloc] init];
    NSMutableArray* temArr = nil;
    temArr = [self temArrWithText:text];
    
    for (HYEmotionResult* obj in temArr) {
        if (obj.isEmotion) {
            UIImage* emotionIcon = [HYEmotionTool imageWithCht:obj.resultStr];
            NSTextAttachment* textAttach = [[NSTextAttachment alloc] init];
            textAttach.image = emotionIcon;
            textAttach.bounds = CGRectMake(0, -3, statusOriginTextFont.lineHeight, statusOriginTextFont.lineHeight);
            NSAttributedString* attriStr = [NSAttributedString attributedStringWithAttachment:textAttach];
            [richString appendAttributedString:attriStr];
            
        } else {
            NSMutableAttributedString* attriStr = [[NSMutableAttributedString alloc] initWithString:obj.resultStr];
            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [obj.resultStr enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [attriStr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [attriStr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+";
            [obj.resultStr enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [attriStr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [attriStr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            
            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [obj.resultStr enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [attriStr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [attriStr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            [richString appendAttributedString:attriStr];
        }
    }
    
    [richString addAttribute:NSFontAttributeName value:statusOriginTextFont range:NSMakeRange(0, richString.length)];

    _realString = text;
    _content = richString;
}

@end
