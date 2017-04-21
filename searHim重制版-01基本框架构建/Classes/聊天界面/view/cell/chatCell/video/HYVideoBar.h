//
//  HYVideoBar.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/27.
//  Copyright © 2016年 黄远. All rights reserved.
//  视频播放器的横条

#import <UIKit/UIKit.h>

@protocol HYVideoBarDelegate <NSObject>

- (void)startVideo;

- (void)stopVideo;

- (void)toBig;

@end

@interface HYVideoBar : UIView

+ (instancetype)videoBar;

@property (nonatomic, weak) id<HYVideoBarDelegate> deleagate;

/** 是否全屏 */
@property (nonatomic, assign, getter=isFull) Boolean full;

/** 设置时间 */
- (void)setProgressTimeWithCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;

@end
