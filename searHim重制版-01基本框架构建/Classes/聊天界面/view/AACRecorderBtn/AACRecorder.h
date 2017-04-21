//
//  AACRecorder.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/23.
//  Copyright © 2016年 黄远. All rights reserved.
//  负责录音的工具类

#import <Foundation/Foundation.h>

@class AACRecorder;

@protocol AACRecorderDelegate <NSObject>
@required

//更新按钮的播放图片
- (void)recording:(CGFloat)recordTime volume:(double)lowPassResult;

- (void)failRecord;

//开始转化MP3
- (void)beginConvert;
//返回音频数据和录音时间
- (void)endConvertWithData:(NSData *)voiceData andRecorderTime:(NSTimeInterval)recorderTime;

@end


@interface AACRecorder : NSObject

@property (nonatomic, weak) id<AACRecorderDelegate> delegate;

//文件路径
@property (nonatomic, copy) NSString* filePath;

//开始录音
- (void)benginRecorder;
//停止录音
- (void)stopRecorder;

- (void)cancelRecord;

@end
