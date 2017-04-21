//
//  HYBaseSelectView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseSelectView.h"

@interface HYBaseSelectView ()

@property (nonatomic, weak) UIView* diver;

@end

@implementation HYBaseSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
            //设置分割线
            UIView* MyView = [[UIView alloc] init];
            MyView.backgroundColor = backBtnColor;
            MyView.alpha = 0.2;
            [self addSubview:MyView];
            _diver = MyView;
        }
    
    return self;
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

- (void)endKeyBoard{

}

@end
