//
//  UIImage+BgIma.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/23.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "UIImage+BgIma.h"

@implementation UIImage (BgIma)
//视频截图
+ (UIImage*)getPicFromVideoUrl:(NSURL*)videoUrl{
    //视屏截图，在cell上面先显示视频的截图，然后用户点击播放再进行播放
    UIImage *image=[self getPicFromVideoUrl:videoUrl andCMTime:CMTimeMake(30, 30)];
    return image;
}

//视频截图(截取视屏某一时刻的图片)
+ (UIImage*)getPicFromVideoUrl:(NSURL*)videoUrl andCMTime:(CMTime)tim{
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:videoUrl];
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    NSError *error=nil;
    CMTime time = tim;
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];
    return image;

}

@end
