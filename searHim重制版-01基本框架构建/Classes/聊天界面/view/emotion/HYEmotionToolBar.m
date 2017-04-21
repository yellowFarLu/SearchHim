//
//  HYEmotionToolBar.m
//  新浪微博
//
//  Created by 黄远 on 16/6/17.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionToolBar.h"
#import "UIImage+Exstension.h"
#define maxEmotionBtnCount 4

@interface HYEmotionToolBar ()
@property (nonatomic, weak) UIButton* preSelectedBtn;
@property (nonatomic, weak) UIButton* defaultBtn;
@end

@implementation HYEmotionToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        for (int i=0; i<maxEmotionBtnCount; i++) {
            // 1.添加4个按钮
            [self setupBtnWithTitle:@"最近" emotionType:HYEmotionTypeRecent];
            [self setupBtnWithTitle:@"默认" emotionType:HYEmotionTypeDefault];
            [self setupBtnWithTitle:@"emoji" emotionType:HYEmotionTypeEmoji];
            [self setupBtnWithTitle:@"浪小花" emotionType:HYEmotionTypeLxh];
        }

        
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectRecentEmotion:) name:HYEmotionDidClickNotification object:nil];
    }
    
    
    return self;
}

- (void)didSelectRecentEmotion:(NSNotification*)notification{
    if (self.preSelectedBtn.tag == HYEmotionTypeRecent) {
       [self buttonClick:[self.subviews firstObject]];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)buttonClick:(UIButton*)emotionBtn{
    if (self.preSelectedBtn.tag == HYEmotionTypeDefault) {
        for (UIButton*btn in self.subviews) {
            if (btn.tag == HYEmotionTypeDefault) {
                btn.selected = NO;
            }
        }
    }
    self.preSelectedBtn.selected = NO;
    emotionBtn.selected = YES;
    self.preSelectedBtn = emotionBtn;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]) {
        [self.delegate emotionToolbar:self didSelectedButton:(int)emotionBtn.tag];
    }
}


- (void)setupBtnWithTitle:(NSString*)title emotionType:(HYEmotionType)type{
    UIButton *button = [[UIButton alloc] init];
    button.tag = type;
    
    // 文字
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 添加按钮
    [self addSubview:button];
    
    // 设置背景图片
    int count = (int)self.subviews.count;
    if (count == 1) { // 第一个按钮
        [button setBackgroundImage:[UIImage resizeImageWithOriginalName:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizeImageWithOriginalName:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
    } else if (count == maxEmotionBtnCount) { // 最后一个按钮
        [button setBackgroundImage:[UIImage resizeImageWithOriginalName:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizeImageWithOriginalName:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
    } else { // 中间按钮
        [button setBackgroundImage:[UIImage resizeImageWithOriginalName:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizeImageWithOriginalName:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    
    if (type == HYEmotionTypeDefault) {
        self.preSelectedBtn = button;
        self.preSelectedBtn.selected = YES;
        self.defaultBtn = button;
    }
}

- (void)setDelegate:(id<HYEmotionToolbarDelegate>)delegate{
    _delegate = delegate;
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]) {
        [self.delegate emotionToolbar:self didSelectedButton:self.defaultBtn.tag];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置工具条按钮的frame
    CGFloat buttonW = self.width / maxEmotionBtnCount;
    CGFloat buttonH = self.height;
    CGFloat buttonX, buttonY;
    buttonY = 0;
    for (int i = 0; i<maxEmotionBtnCount; i++) {
        UIButton *button = self.subviews[i];
        buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}



@end
