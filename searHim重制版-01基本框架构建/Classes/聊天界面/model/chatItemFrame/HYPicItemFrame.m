//
//  HYPicItemFrame.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYPicItemFrame.h"
#import "HYPicItem.h"

#define HYPicWid mainScreenWid * 0.4

@implementation HYPicItemFrame

- (void)setBaseChatItem:(HYBaseChatItem *)baseChatItem{
    [super setBaseChatItem:baseChatItem];
    HYPicItem* picItem = (HYPicItem*)baseChatItem;
    CGFloat picX, picY, picWid, picHei;
    picWid = HYPicWid;
    picHei = picWid * (picItem.pic.size.height / picItem.pic.size.width);
    if ([picItem isMe]) {
        picX = mainScreenWid - 2*HYSearHimInset - self.iconFrame.size.width - picWid;
    } else {
        picX = CGRectGetMaxX(self.iconFrame) + 2*HYSearHimInset;
    }
    picY = self.iconFrame.origin.y + HYSearHimInset*0.4;
    self.picFrame = CGRectMake(picX, picY, picWid, picHei);
    
    CGFloat sliderX, sliderY, sliderWid, sliderHei;
    sliderX = picX;
    sliderWid = picWid;
    sliderHei = 3;
    sliderY = picY + picHei + HYSearHimInset * 0.4;
    self.sliderFrame = CGRectMake(sliderX, sliderY, sliderWid, sliderHei);
    
    if (CGRectGetMaxY(self.iconFrame) > CGRectGetMaxY(self.sliderFrame)) {
        self.height = CGRectGetMaxY(self.iconFrame) + 3*HYSearHimInset;
    }else{
        self.height = CGRectGetMaxY(self.sliderFrame) + 3*HYSearHimInset;
    }
}

@end
