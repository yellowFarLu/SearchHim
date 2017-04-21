//
//  HYEmotionTextView.m
//  新浪微博
//
//  Created by 黄远 on 16/6/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionTextView.h"
#import "HYEmotion.h"
#import "UIImage+Exstension.h"
#import "RegexKitLite.h"
#import "HYEmotionTextAttachment.h"

@interface HYEmotionTextView ()

@end

@implementation HYEmotionTextView

- (void)setEmotion:(HYEmotion *)emotion{
    _emotion = emotion;
    
    int index = (int)self.selectedRange.location;
    
    
    //设置在textView上
    if (emotion.emoji) {
        [self insertText:emotion.emoji];
    }else{
        NSRange temRanege = self.selectedRange;
        //插入
        NSMutableAttributedString* attribuString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        HYEmotionTextAttachment* iconAttachment = [[HYEmotionTextAttachment alloc] init];
        iconAttachment.emotion = emotion;
        iconAttachment.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString* iconAttributedString = [NSAttributedString attributedStringWithAttachment:iconAttachment];
        [attribuString insertAttributedString:iconAttributedString atIndex:index];
        [attribuString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attribuString.length)];
        self.attributedText = attribuString;
        
        self.selectedRange = NSMakeRange(temRanege.location + 1, 0);
    }
    
    self.pacehoder.hidden = self.hasText;
    
//    HYLog(@"%@", [self realString]);
}

//设置发送微博的文本
- (NSString*)realString{
    NSMutableString* realStr = [NSMutableString stringWithString:self.attributedText.string];
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        HYEmotionTextAttachment* textAtment = attrs[@"NSAttachment"];
        if (textAtment) {
            [realStr insertString:textAtment.emotion.chs atIndex:range.location];
        }
    }];
    
    return realStr;
}








@end
