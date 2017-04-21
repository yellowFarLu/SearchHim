//
//  HYEmotionTextView.h
//  新浪微博
//
//  Created by 黄远 on 16/6/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYTextView.h"
@class HYEmotion;
@interface HYEmotionTextView : HYTextView
@property (nonatomic, strong) HYEmotion* emotion;

- (NSString*)realString;

@end
