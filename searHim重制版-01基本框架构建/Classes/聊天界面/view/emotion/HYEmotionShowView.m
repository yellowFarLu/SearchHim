//
//  HYEmotionShowView.m
//  新浪微博
//
//  Created by 黄远 on 16/6/18.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionShowView.h"
#import "HYEmotionView.h"
#import "UIImage+Exstension.h"

@interface HYEmotionShowView ()


@end

@implementation HYEmotionShowView

- (void)dismissView{
    [self removeFromSuperview];
}


+ (instancetype)loadEmotionShowView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HYEmotionShowView" owner:nil options:nil] lastObject];
}


- (void)shouldShowEmotionView:(HYEmotionView *)emotionView{
    if (!emotionView) {
        return;
    }
    [UIView setAnimationsEnabled:NO];
    self.emotionView.emotion = emotionView.emotion;
    
    UIWindow* lastWindow = [[UIApplication sharedApplication].windows lastObject];
    [lastWindow addSubview:self];
    
    CGPoint temP = [lastWindow convertPoint:emotionView.center fromView:emotionView.superview];
    temP.y = temP.y - emotionView.height + 10;
    self.center = temP;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView setAnimationsEnabled:YES];
    });
}



- (void)drawRect:(CGRect)rect{
    [[UIImage imageWithOriginalName:@"emoticon_keyboard_magnifier"] drawInRect:rect];
}


@end
