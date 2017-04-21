//
//  HYVideoItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseChatItem.h"
#import <AVFoundation/AVFoundation.h>

@interface HYVideoItem : HYBaseChatItem

@property (nonatomic, copy) NSString* videoUrl;

@property (nonatomic, assign) CGFloat sliderValue;

@property (nonatomic, assign) BOOL proViewHidden;

//视频封面
@property (nonatomic, strong) UIImage* videoBgIma;

@property (nonatomic, assign, getter=isSeeing) BOOL seeing;

//当前播放到哪
@property (nonatomic, assign) CMTime time;

@end
