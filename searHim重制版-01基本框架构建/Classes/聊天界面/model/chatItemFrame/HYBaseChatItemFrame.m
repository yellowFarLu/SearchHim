//
//  HYChatItemFrame.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseChatItemFrame.h"
#import "HYBaseChatItem.h"

@implementation HYBaseChatItemFrame

- (void)setBaseChatItem:(HYBaseChatItem *)baseChatItem{
    _baseChatItem = baseChatItem;
    
    CGSize timeSize = [baseChatItem.lastMessageAtString sizeWithFont:HYKeyFont];
    
    if ([baseChatItem isShowTime]) {
        CGFloat timeX, timeY, timeWid, timeHei;
        timeHei = 25;
        timeWid = timeSize.width + 5;
        timeY = 0;
        timeX = (mainScreenWid - timeWid)*0.5;
        _timeFrame = CGRectMake(timeX, timeY, timeWid, timeHei);
    }else{
        _timeFrame = CGRectZero;
    }
    
    CGFloat iconX, iconY, iconWid, iconHei;
    iconWid = iconHei = 40;
    iconY = CGRectGetMaxY(_timeFrame) + HYSearHimInset*2;
    if ([baseChatItem isMe]) {
        iconX = mainScreenWid - HYSearHimInset - iconWid;
    } else {
        iconX = HYSearHimInset;
    }
    _iconFrame = CGRectMake(iconX, iconY, iconWid, iconHei);
}


@end
