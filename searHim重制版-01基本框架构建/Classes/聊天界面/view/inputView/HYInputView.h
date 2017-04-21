//
//  HYInputView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//  输入框整体

#import <UIKit/UIKit.h>

typedef enum {
    InputBtnTypeAudio,  //语音
    InputBtnTypeExpress, //表情
    InputBtnTypeAdd, //加号
    InputBtnTypeSend //点击了发送按钮
} InputBtnType;


@class HYInputView;
@protocol HYInputViewDelegate <NSObject>

@required
- (void)inputView:(HYInputView*)inputView didClickBtnType:(InputBtnType)type;

- (NSString*)getCafFilePath;

//已经得到录音文件了
- (void)hasGetAudioData:(NSData *)data andRecorderTime:(NSTimeInterval)recorderTime;

@end


@interface HYInputView : UIView

@property (nonatomic, weak) id<HYInputViewDelegate> delegate;
//返回富文本
- (NSAttributedString*)getMsg;
//返回textView的inputView
- (UIView*)inputView;
- (void)setInputView:(UIView*)inputView;
//返回文本
- (NSString*)realString;

//切换表情图标和键盘图标的接口
@property (nonatomic, assign, getter=isShowEmotion) BOOL showEmotion;

@property (nonatomic, copy) NSString* cafFilePath;

@end













