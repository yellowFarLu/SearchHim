//
//  HYVideoPlayer.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/11/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

/** 视频播放器
  *
  * 自定义的播放条
  * 暂停，继续播放功能
  * 放大功能
  * 显示播放进度
 */

#import <UIKit/UIKit.h>
@class HYVideoItemFrame;

@interface HYVideoPlayer : UIView

@property (nonatomic, strong) HYVideoItemFrame* videoItemFrame;

@end
