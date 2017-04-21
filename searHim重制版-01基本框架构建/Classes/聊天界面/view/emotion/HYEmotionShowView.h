//
//  HYEmotionShowView.h
//  新浪微博
//
//  Created by 黄远 on 16/6/18.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYEmotionView;
@interface HYEmotionShowView : UIView
@property (weak, nonatomic) IBOutlet HYEmotionView *emotionView;

- (void)shouldShowEmotionView:(HYEmotionView*)emotionView;
+ (instancetype)loadEmotionShowView;

- (void)dismissView;

@end
