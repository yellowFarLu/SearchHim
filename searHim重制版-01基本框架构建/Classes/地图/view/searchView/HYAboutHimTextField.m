//
//  HYAboutHimTextField.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/24.
//  Copyright © 2016年 黄远. All rights reserved.
//  

#import "HYAboutHimTextField.h"

@interface HYAboutHimTextField ()
@property (nonatomic, weak) UITextField* textField;
@property (nonatomic, weak) UIView* diver;
@end

@implementation HYAboutHimTextField

+ (instancetype)AboutHimTextField{
    return [[HYAboutHimTextField alloc] init];
}

- (NSString *)getValue{
    return self.textField.text;
}

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
        
        UITextField* textField = [[UITextField alloc] init];
        textField.placeholder = @"一个描述ta的关键字";
        textField.font = HYValueFont;
//        NSString* divers = [UIDevice currentDevice].model;
//        if ([divers containsString:@"iPad"]) {
            textField.font = HYPadValueFont;
//        }
        [self addSubview:textField];
        _textField = textField;
        
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //计算分割线
    CGFloat hei,wid,x,y;
    hei = 1;
    x = 0;
    wid = self.frame.size.width;
    y = self.frame.size.height - 1;
    self.diver.frame = CGRectMake(x, y, wid, hei);
    
    self.textField.frame = self.bounds;
}


@end
