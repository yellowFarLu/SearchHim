//
//  HYContentItemFrame.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYContentItemFrame.h"
#import "HYContentItem.h"

@implementation HYContentItemFrame

- (void)setBaseChatItem:(HYBaseChatItem *)baseChatItem{
    HYContentItem* contentItem = (HYContentItem*)baseChatItem;
    //调用父类方法，确定时间头像的宽高
    [super setBaseChatItem:baseChatItem];
    CGFloat contentX, contentY,contentWid,contentHei;
    contentY = self.iconFrame.origin.y;
    contentWid = mainScreenWid * 0.5;
    CGSize size = CGSizeZero;
    CGSize limitSize = CGSizeMake(contentWid, MAXFLOAT);
    if ([contentItem.content isKindOfClass:[NSAttributedString class]]) {
        size = [contentItem.content boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    } else if([contentItem isKindOfClass:[NSString class]]){
        size = [contentItem.content boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }
    contentWid = size.width + 40;
    contentHei = size.height + 15;
    if ([contentItem isMe]) {
        contentX = mainScreenWid - HYSearHimInset - self.iconFrame.size.width - contentWid;
    } else {
        contentX = CGRectGetMaxX(self.iconFrame);
    }
    
    self.contentFrame = CGRectMake(contentX, contentY, contentWid, contentHei);
    
    CGFloat indicatorViewX, indicatorViewY;
    indicatorViewY = contentY + HYSearHimInset* 1.5;
    if ([baseChatItem isMe]) {
        indicatorViewX = contentX - HYSearHimInset;
    }else{
        indicatorViewX = CGRectGetMaxX(self.contentFrame) + HYSearHimInset*1.5;
    }
    self.indicatorViewCenter = CGPointMake(indicatorViewX, indicatorViewY);
    
    if (CGRectGetMaxY(self.iconFrame) > CGRectGetMaxY(self.contentFrame)) {
        self.height = CGRectGetMaxY(self.iconFrame) + 3*HYSearHimInset;
    }else{
        self.height = CGRectGetMaxY(self.contentFrame) + 3*HYSearHimInset;
    }
}

@end
