//
//  UIImage+BgIma.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/23.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface UIImage (BgIma)
//视频截图(截取视屏最开始的图片)
+ (UIImage*)getPicFromVideoUrl:(NSURL*)videoUrl;

//视频截图(截取视屏某一时刻的图片)
+ (UIImage*)getPicFromVideoUrl:(NSURL*)videoUrl andCMTime:(CMTime)tim;

@end
