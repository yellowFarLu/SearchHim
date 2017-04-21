//
//  HYEmotionView.m
//  新浪微博
//
//  Created by 黄远 on 16/6/18.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionView.h"
#import "HYEmotion.h"
#import "UIImage+Exstension.h"

@implementation HYEmotionView

- (void)setEmotion:(HYEmotion *)emotion{
    _emotion = emotion;
    
    if (emotion.code) {
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
    } else {
        NSString* iconPath = [NSString stringWithFormat:@"%@%@", emotion.directory, emotion.png];
        [self setImage:[UIImage imageWithOriginalName:iconPath] forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
    }
}



@end
