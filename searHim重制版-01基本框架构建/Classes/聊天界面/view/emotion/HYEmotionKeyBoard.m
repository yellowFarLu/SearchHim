//
//  HYEmotionView.m
//  新浪微博
//
//  Created by 黄远 on 16/6/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionKeyBoard.h"
#import "HYEmotionListView.h"
#import "HYEmotionToolBar.h"
#import "UIView+Extension.h"
#import "HYEmotion.h"
#import "HYEmotionTool.h"

@interface HYEmotionKeyBoard () <HYEmotionToolbarDelegate>
@property (nonatomic, weak) HYEmotionListView* emotionListView;
@property (nonatomic, weak) HYEmotionToolBar* emotionToolBar;

@end

@implementation HYEmotionKeyBoard


+ (instancetype)emotionKeyBoard{
    return [[self alloc] init];
}


- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, mainScreenWid, 250);
        HYEmotionListView* emotionListView = [[HYEmotionListView alloc] init];
        [self addSubview:emotionListView];
//        emotionListView.backgroundColor = [UIColor orangeColor];
        self.emotionListView = emotionListView;
        HYEmotionToolBar*emotionToolBar = [[HYEmotionToolBar alloc] init];
        [self addSubview:emotionToolBar];
        self.emotionToolBar = emotionToolBar;
        self.emotionToolBar.delegate = self;
    }
    return self;
}




- (void)emotionToolbar:(HYEmotionToolBar *)toolbar didSelectedButton:(HYEmotionType)emotionType{
    switch (emotionType) {
        case HYEmotionTypeDefault:// 默认
            self.emotionListView.emotions = [HYEmotionTool defaultEmotions];
            break;
            
        case HYEmotionTypeEmoji: // Emoji
            self.emotionListView.emotions = [HYEmotionTool emojiEmotions];
            
            break;
            
        case HYEmotionTypeLxh: // 浪小花
            self.emotionListView.emotions = [HYEmotionTool lxhEmotions];
            
            break;
            
        case HYEmotionTypeRecent:
            self.emotionListView.emotions = [HYEmotionTool recentEmotions];
            break;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat toolBarX, toolBarY, toolBarH, toolBarW;
    CGFloat emotionListViewX, emotionListViewY, emotionListViewW, emotionListViewH;
    
    toolBarW = mainScreenWid;
    toolBarH = 44;
    toolBarX = 0;
    toolBarY = self.height - toolBarH;
    self.emotionToolBar.frame = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    emotionListViewX = emotionListViewY = 0;
    emotionListViewH = toolBarY;
    emotionListViewW = toolBarW;
    self.emotionListView.frame = CGRectMake(emotionListViewX, emotionListViewY, emotionListViewW, emotionListViewH);
}




@end
