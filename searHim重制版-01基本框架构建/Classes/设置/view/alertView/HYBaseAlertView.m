//
//  HYBaseAlertView.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseAlertView.h"



@implementation HYBaseAlertView




- (NSString*)getValue{
    return nil;
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

- (UILabel*)keyLable{
    if (!_keyLable) {
        UILabel* keyLa = [[UILabel alloc] init];
        keyLa.textColor = [UIColor blackColor];
        keyLa.textAlignment = NSTextAlignmentCenter;
        [self addSubview:keyLa];
        _keyLable = keyLa;
    }
    return _keyLable;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
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
    
    //计算key
    CGFloat keyX, keyY, keyWid, keyHei;
    keyX = x;
    keyY = HYSearHimInset * 0.5;
    keyWid = HYIconWid + 2*HYSearHimInset;
    keyHei = (self.height - HYSearHimInset);
    self.keyLable.frame = CGRectMake(keyX, keyY, keyWid, keyHei);

}

- (void)setKey:(NSString *)key{
    _key = key;
    _keyLable = self.keyLable;
    self.keyLable.text = key;
}

@end
