//
//  HYRecorderBtn.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/23.
//  Copyright © 2016年 黄远. All rights reserved.
//  录音按钮

#import <UIKit/UIKit.h>

@class HYRecorderBtn, AACRecorder;

@protocol HYRecorderBtnDelegate <NSObject>
@required
//返回音频数据给控制器(通过音频工具AACRecorder传送数据给录音按钮，录音按钮再传给控制器，这样子控制器只要面对录音按钮开发)
- (void)getData:(NSData*)data andRecorderTime:(NSTimeInterval)recorderTime;

@end


@interface HYRecorderBtn : UIButton
//最大录音时间
@property (nonatomic, assign) int maxtime;
//录音工具
@property (nonatomic, strong) AACRecorder* recorder;
//底部文字
@property (nonatomic, copy) NSString* buttomTitle;

@property (nonatomic, weak) id<HYRecorderBtnDelegate> delegate;

+ (instancetype)initWithDelegata:(id<HYRecorderBtnDelegate>)delegate maxtime:(int)maxtime buttonTitle:(NSString*)title andRecorderFilePath:(NSString*)filePath;
@end
