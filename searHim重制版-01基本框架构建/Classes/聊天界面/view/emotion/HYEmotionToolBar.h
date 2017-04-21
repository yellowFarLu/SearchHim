//
//  HYEmotionToolBar.h
//  新浪微博
//
//  Created by 黄远 on 16/6/17.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HYEmotionTypeRecent, // 最近
    HYEmotionTypeDefault, // 默认
    HYEmotionTypeEmoji, // Emoji
    HYEmotionTypeLxh // 浪小花
} HYEmotionType;

@class HYEmotionToolBar;

@protocol HYEmotionToolbarDelegate <NSObject>

@optional
- (void)emotionToolbar:(HYEmotionToolBar *)toolbar didSelectedButton:(HYEmotionType)emotionType;
@end


@interface HYEmotionToolBar : UIView
@property (nonatomic, weak) id<HYEmotionToolbarDelegate> delegate;

@end
