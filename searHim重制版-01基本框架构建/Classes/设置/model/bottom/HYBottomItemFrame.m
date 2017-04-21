//
//  HYBottomItemFrame.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBottomItemFrame.h"

@implementation HYBottomItemFrame


- (void)setBottomItem:(HYBottomItem *)bottomItem{
    _bottomItem = bottomItem;
    
    CGFloat wid = mainScreenWid - HYSearHimInset;
    CGFloat x,y;
    y = 0;
    x = HYSearHimInset;
    CGSize size;
    if ([bottomItem isMe]) {
        size = [bottomItem.aboutMe boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : bottomItemFont} context:nil].size;
    } else {
        size = [bottomItem.aboutHimOrShe boundingRectWithSize:CGSizeMake(wid, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : bottomItemFont} context:nil].size;
    }
    
    CGFloat hei = size.height + 4*HYSearHimInset;
    self.itemframe = CGRectMake(x, y, wid, hei);
}


@end
