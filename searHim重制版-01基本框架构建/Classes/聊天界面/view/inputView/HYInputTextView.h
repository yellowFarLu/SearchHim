//
//  HYInputTextView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//  输入框的输入文字部分

#import <UIKit/UIKit.h>

@class HYInputTextView, HYEmotion;

@protocol HYInputTextViewDelegate <UITextViewDelegate>
@required
- (void)didClearTextView:(HYInputTextView*)textView;

@end


@interface HYInputTextView : UITextView


- (void)showClearBtn;
- (void)hiddenClearBtn;

@property (nonatomic, weak) id<HYInputTextViewDelegate> delegate;

@property (nonatomic, strong) HYEmotion* emotion;
- (NSString*)realString;
@end


