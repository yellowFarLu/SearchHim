//
//  HYCardItemFrame.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/25.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCardItemFrame.h"
#import "HYCardItem.h"

#define HYCardWid 220
#define HYCardHei 130

@implementation HYCardItemFrame

- (void)setBaseChatItem:(HYBaseChatItem *)baseChatItem{
    [super setBaseChatItem:baseChatItem];
    
    HYCardItem* cardItem = (HYCardItem*)baseChatItem;
    CGFloat cardX, cardY, cardWid, cardHei;
    cardWid = HYCardWid;
    cardHei = HYCardHei;
    if ([cardItem isMe]) {
        cardX = mainScreenWid - self.iconFrame.size.width - cardWid - 2*HYSearHimInset;
    } else {
        cardX = CGRectGetMaxX(self.iconFrame) + 2*HYSearHimInset;
    }
    cardY = self.iconFrame.origin.y + HYSearHimInset * 0.4;
    self.cardFrame = CGRectMake(cardX, cardY, cardWid, cardHei);
    self.height = CGRectGetMaxY(self.cardFrame)+ HYSearHimInset;
}


@end
