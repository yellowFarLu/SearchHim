//
//  HYVideoItemFrame.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYVideoItemFrame.h"
#import "HYVideoItemFrame.h"
#import "HYVideoItem.h"

#define HYVideoWid mainScreenWid * 0.5
#define HYVideoHei HYVideoWid * 0.7
@implementation HYVideoItemFrame

- (void)setBaseChatItem:(HYBaseChatItem *)baseChatItem{
    [super setBaseChatItem:baseChatItem];
    HYVideoItem* videoItem = (HYVideoItem*)baseChatItem;
    CGFloat videoX, videoY, videoWid, videoHei;
    videoWid = HYVideoWid;
    videoHei = HYVideoHei;
    if ([videoItem isMe]) {
        videoX = mainScreenWid - 2*HYSearHimInset - self.iconFrame.size.width - videoWid;
    } else {
        videoX = CGRectGetMaxX(self.iconFrame) + 2*HYSearHimInset;
    }
    videoY = self.iconFrame.origin.y + HYSearHimInset * 0.4;
    self.videoFrame = CGRectMake(videoX, videoY, videoWid, videoHei);
    
    CGFloat sliderX, sliderY, sliderWid, sliderHei;
    sliderX = videoX;
    sliderWid = videoWid;
    sliderHei = 3;
    sliderY = videoY + videoHei + HYSearHimInset * 0.4;
    self.sliderFrame = CGRectMake(sliderX, sliderY, sliderWid, sliderHei);
    
    if (CGRectGetMaxY(self.iconFrame) > CGRectGetMaxY(self.sliderFrame)) {
        self.height = CGRectGetMaxY(self.iconFrame) + 3*HYSearHimInset;
    }else{
        self.height = CGRectGetMaxY(self.sliderFrame) + 3*HYSearHimInset;
    }
}


@end
