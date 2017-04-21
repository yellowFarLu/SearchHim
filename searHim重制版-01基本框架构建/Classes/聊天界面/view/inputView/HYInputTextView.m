//
//  HYInputTextView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYInputTextView.h"
#import "HYEmotion.h"
#import "HYEmotionTextAttachment.h"

@interface HYInputTextView ()
//清除按钮
@property (nonatomic, weak) UIButton* clearBtn;

@end

@implementation HYInputTextView


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
//        [attribuString addAttribute:NSBackgroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attribuString.length)];
        self.attributedText = attribuString;
        
        self.selectedRange = NSMakeRange(temRanege.location + 1, 0);
    }
    
    //    HYLog(@"%@", [self realString]);
}


//设置发送信息的文本
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



- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat margin = 3;
    CGFloat clearX, clearY, clearWid, clearHei;
    clearWid = clearHei = 15;
    clearX = self.width - clearWid - margin;
    clearY = self.height - HYSearHimInset - clearHei;
    self.clearBtn.frame = CGRectMake(clearX, clearY, clearWid, clearHei);
}



- (instancetype)init{
    if (self = [super init]) {
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.hidden = YES;
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"clearBtn"] forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearBtn];
        self.clearBtn = clearBtn;
        self.bounces = NO;
        self.bouncesZoom = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}


- (void)clear{
    self.attributedText = nil;
    self.text = nil;
    [self.delegate didClearTextView:self];
}

- (void)showClearBtn{
    self.clearBtn.hidden = NO;
}

- (void)hiddenClearBtn{
    self.clearBtn.hidden = YES;
}

@end
