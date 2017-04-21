//
//  HYAudioItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseChatItem.h"

@interface HYAudioItem : HYBaseChatItem
//录音文件
@property (nonatomic, copy) NSData* audio;

//录音文件的时间
@property (nonatomic, assign) double audioTime;

//设置是否播放
@property (nonatomic, assign, getter=isListen) bool listen;

@end
