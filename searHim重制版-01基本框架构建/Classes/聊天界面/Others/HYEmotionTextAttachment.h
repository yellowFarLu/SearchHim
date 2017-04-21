//
//  HYEmotionTextAttachment.h
//  新浪微博
//
//  Created by 黄远 on 16/6/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYEmotion;
@interface HYEmotionTextAttachment : NSTextAttachment
@property (nonatomic, strong) HYEmotion* emotion;
@end
