//
//  HYEmotionTextAttachment.m
//  新浪微博
//
//  Created by 黄远 on 16/6/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionTextAttachment.h"
#import "HYEmotion.h"
#import "UIImage+Exstension.h"
@implementation HYEmotionTextAttachment


- (void)setEmotion:(HYEmotion *)emotion{
    _emotion = emotion;
    
    NSString* iconPah =[NSString stringWithFormat:@"%@%@", emotion.directory, emotion.png];
    self.image = [UIImage imageWithOriginalName:iconPah];

}


@end
