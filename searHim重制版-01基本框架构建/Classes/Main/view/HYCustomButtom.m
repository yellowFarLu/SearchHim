//
//  HYCustomButtom.m
//  新浪微博
//
//  Created by 黄远 on 16/5/28.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYCustomButtom.h"
#define margin 2


@interface HYCustomButtom ()

@end

@implementation HYCustomButtom


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setTitleColor:backBtnColor forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addBdgeBtn];
//    NSLog(@"%d", self.tag);
    return self;
}

- (void)addBdgeBtn{
    UIButton* bdgeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bdgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bdgeBtn setBackgroundImage:[UIImage imageNamed:@"main_badge"] forState:UIControlStateNormal];
    bdgeBtn.titleLabel.font = [UIFont  systemFontOfSize:11];
    [self addSubview:bdgeBtn];
    bdgeBtn.hidden = YES;
    self.bdgeBtn = bdgeBtn;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imaX, imaY, imaW, imaH;
    imaY = margin;
    imaX = (self.frame.size.width - self.item.image.size.width)/2;
    imaW = self.item.image.size.width;
    imaH = self.item.image.size.height;
    
    return CGRectMake(imaX, imaY, imaW, imaH);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX, titleY, titleWid, titleHei, imaHei;
    imaHei = self.item.image.size.height;
    titleX = 0;
    titleY = imaHei + margin;
    titleWid = self.frame.size.width;
    titleHei = self.frame.size.height - imaHei - margin;
    return CGRectMake(titleX, titleY, titleWid, titleHei);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x,y,w,h;
    h = w = 20;
    x = self.width - w - 1.5*HYSearHimInset;
    y = 0;
    self.bdgeBtn.frame = CGRectMake(x, y, w, h);
}



@end
