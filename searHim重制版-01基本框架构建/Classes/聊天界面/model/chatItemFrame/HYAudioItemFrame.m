//
//  HYAudioItemFrame.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYAudioItemFrame.h"
#import "HYAudioItem.h"

#define HYAudioWid mainScreenWid * 0.5
#define HYAudioHei HYAudioWid * 0.25

@implementation HYAudioItemFrame

- (void)setBaseChatItem:(HYBaseChatItem *)baseChatItem{
    [super setBaseChatItem:baseChatItem];
    
    HYAudioItem* audioItem = (HYAudioItem*)baseChatItem;
    CGFloat audioX, audioY, audioWid, audioHei;
    audioWid = HYAudioWid;
    audioHei = HYAudioHei;
    if ([audioItem isMe]) {
        audioX = mainScreenWid - self.iconFrame.size.width - audioWid - HYSearHimInset;
    } else {
        audioX = CGRectGetMaxX(self.iconFrame);
    }
    audioY = self.iconFrame.origin.y + HYSearHimInset * 0.4;
    self.audioBtnFrame = CGRectMake(audioX, audioY, audioWid, audioHei);
    
    CGFloat audioTimeX, audioTimeY, audioTimeWid, audioTimeHei;
    if ([audioItem isMe]) {
        audioTimeX = self.audioBtnFrame.origin.x - 1.5*HYSearHimInset;
    } else {
        audioTimeX = CGRectGetMaxX(self.audioBtnFrame) + HYSearHimInset;
    }
    audioTimeY = self.audioBtnFrame.origin.y;
    audioTimeWid = 80;
    audioTimeHei = self.audioBtnFrame.size.height;
    self.audioTimeFrame = CGRectMake(audioTimeX, audioTimeY, audioTimeWid, audioTimeHei);
    self.height = CGRectGetMaxY(self.audioBtnFrame)+ HYSearHimInset;
}


@end
