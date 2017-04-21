//
//  HYMoreViewButton.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/9/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYMoreViewButton.h"

@interface HYMoreViewButton ()
@property (nonatomic, weak) UIView* diver;
@end

@implementation HYMoreViewButton

- (instancetype)init{
    if (self = [super init]) {
        // 先设定默认的文字和图片，来计算宽高
        [self setTitle:@"more" forState:UIControlStateNormal];
        [self setImage:[UIImage imageWithOriginalName:@"mic_cancel"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = HYValueFont;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIView*)diver{
    if (!_diver) {
        //设置分割线
        UIView* MyView = [[UIView alloc] init];
        MyView.backgroundColor = backBtnColor;
        MyView.alpha = 0.2;
        [self addSubview:MyView];
        _diver = MyView;
    }
    return _diver;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageX, imageY, imageWid, imageHei;
    imageX = imageY = 0;
    imageWid = 28;
    imageHei = imageWid * (self.currentImage.size.height / self.currentImage.size.width);
    return CGRectMake(imageX, imageY, imageWid, imageHei);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX, titleY, titleWid, titleHei;
    titleX = CGRectGetMaxX(self.imageView.frame);
    titleWid = contentRect.size.width - self.imageView.width;
    titleHei = contentRect.size.height;
    titleY = 0;
    return CGRectMake(titleX, titleY, titleWid, titleHei);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //计算分割线
    CGFloat hei,wid,x,y;
    hei = 1;
    x = HYSearHimInset;
    wid = (self.frame.size.width - 2*HYSearHimInset);
    y = self.frame.size.height - 1;
    self.diver.frame = CGRectMake(x, y, wid, hei);
}

@end
