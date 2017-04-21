//
//  HYRightMenu.m
//  网易新闻框架
//
//  Created by 黄远 on 16/7/4.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYRightMenu.h"
#import "UIImage+imageWithColor.h"
#define HMColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#import "HYMenuButton.h"

@interface HYRightMenu ()
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation HYRightMenu

- (instancetype)init{
    if (self = [super init]) {
        CGFloat alpha = 0.2;
        [self setupBtnWithIcon:nil title:@"我的信息" bgColor:HMColorRGBA(202, 68, 73, alpha)];
        [self setupBtnWithIcon:nil title:@"清理缓存" bgColor:HMColorRGBA(190, 111, 69, alpha)];
        [self setupBtnWithIcon:nil title:@"接收推送" bgColor:HMColorRGBA(76, 132, 190, alpha)];
        [self setupBtnWithIcon:nil title:@"退出账号" bgColor:HMColorRGBA(101, 170, 78, alpha)];
        [self setupBtnWithIcon:nil title:@"退出searchHim" bgColor:HMColorRGBA(170, 172, 73, alpha)];
        [self setupBtnWithIcon:nil title:@"关于searchHim" bgColor:HMColorRGBA(190, 62, 119, alpha)];
        
    }
    return self;
}

- (void)setDelegate:(id<HYRightMenuDelegate>)delegate{
    _delegate = delegate;
//    [self buttonClick:[self.subviews firstObject]];
}


/**
 *  添加按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title bgColor:(UIColor *)bgColor
{
    HYMenuButton *btn = [[HYMenuButton alloc] init];
    btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    
    // 设置图片和文字
//    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置按钮选中的背景
    [btn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateSelected];
    
    // 设置高亮的时候不要让图标变色
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置按钮的内容左对齐
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    return btn;
}


- (void)buttonClick:(UIButton*)btn{
    self.selectedButton.selected = NO;
    btn.selected = YES;
    if ([self.delegate respondsToSelector:@selector(leftMenu:didSelectedButtonWithType:)]) {
        [self.delegate leftMenu:self didSelectedButtonWithType:(int)btn.tag];
    }
    self.selectedButton = btn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat wid,hei,x,y;
    x = 0;
    wid = self.frame.size.width;
    hei = self.frame.size.height / self.subviews.count;
    
    UIButton* btn = nil;
    for (int i=0; i<self.subviews.count; i++) {
        btn = self.subviews[i];
        y = i * hei;
        btn.frame = CGRectMake(x, y, wid, hei);
    }
}







@end
