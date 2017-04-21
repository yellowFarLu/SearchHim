//
//  HYEmotionsView.m
//  新浪微博
//
//  Created by 黄远 on 16/6/18.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYEmotionsView.h"
#import "HYEmotion.h"
#import "HYEmotionView.h"
#import "HYEmotionShowView.h"
#import "HYEmotionTool.h"

@interface HYEmotionsView ()
@property (nonatomic, weak) UIButton* deleteButton;
@property (nonatomic, strong) NSMutableArray* emotionViews;
@property (nonatomic, strong) HYEmotionShowView* emotionShowView;
@end

@implementation HYEmotionsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(onDelegate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        /*
         * 在监听方法中，系统把监听器作为参数
         */
        UILongPressGestureRecognizer* lpGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        self.emotionShowView = [HYEmotionShowView loadEmotionShowView];
        [self addGestureRecognizer:lpGes];
    }
    return self;
}

- (void)onDelegate{
    //发送通知，让textView删除
    [[NSNotificationCenter defaultCenter] postNotificationName:HYEmotionDelegateNotification
                                                        object:nil userInfo:nil];
}

- (HYEmotionView*)isEmotionViewRectContantPoint:(CGPoint)currentPoint{
    __block HYEmotionView* currentEmotionView = nil;
    [self.emotionViews enumerateObjectsUsingBlock:^(HYEmotionView*  emotionView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(emotionView.frame, currentPoint)) {
            currentEmotionView = emotionView;
            *stop = YES;
        }
    }];
    return currentEmotionView;
}

- (void)longPressClick:(UILongPressGestureRecognizer*)lpGes{
    HYEmotionView* emotionView = nil;
    CGPoint currentPoint = [lpGes locationInView:self];
    if (lpGes.state == UIGestureRecognizerStateEnded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.emotionShowView dismissView];
        });
        
        //手松开的时候判断手指坐标处有没有emotionView
        emotionView = [self isEmotionViewRectContantPoint:currentPoint];
        if (emotionView) {
            [self didSelectedEmotion:emotionView.emotion];
        }
        
    }else{
        emotionView = [self isEmotionViewRectContantPoint:currentPoint];
        //显示对应的表情
        [self.emotionShowView shouldShowEmotionView:emotionView];
        
    }
}

/*
 * 做选中表情的处理
 */
- (void)didSelectedEmotion:(HYEmotion*)emotion{
    //1、存到沙盒
    [HYEmotionTool saveRecentEmotion:emotion];
    
    //2、刷新最近的表情
    [[NSNotificationCenter defaultCenter] postNotificationName:HYEmotionDidClickNotification
                                                        object:nil userInfo:@{ HYCurrentEmotion : emotion}];
}


/*
 * 共发两种通知：单击，长按
 */
- (void)emotionClick:(HYEmotionView*)emotionView{
    //显示对应的表情
    [self.emotionShowView shouldShowEmotionView:emotionView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.emotionShowView dismissView];
    });
    
    [self didSelectedEmotion:emotionView.emotion];
}


- (NSMutableArray*)emotionViews{
    if (!_emotionViews) {
        _emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

-(void)setCurrentEmotions:(NSArray *)currentEmotions{
    _currentEmotions = currentEmotions;
    
    for (int i=0; i<currentEmotions.count; i++) {
        HYEmotionView* emotionView = nil;
        if (i < self.emotionViews.count) {
            emotionView = self.emotionViews[i];
        } else {
            emotionView = [[HYEmotionView alloc] init];
            [emotionView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:emotionView];
            [self.emotionViews addObject:emotionView];
        }
        HYEmotion* emotion = currentEmotions[i];
        emotionView.emotion = emotion;
        emotionView.hidden = NO;
    }
    
    int emotionBntCount = (int)(self.emotionViews.count - 1);
    for (int i=(int)currentEmotions.count; i< emotionBntCount; i++) {
        HYEmotionView* emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }
    
//    [self layoutIfNeeded];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat topInset, leftInsert;
    topInset = 10;
    leftInsert = topInset;
    
    CGFloat btnW = (self.width - 2*leftInsert)/emotionMaxCol;
    CGFloat btnH = (self.height - topInset) / emotionMaxRow;
    CGFloat btnX,btnY;
    for (int i=0; i<self.currentEmotions.count; i++) {
        UIButton* btn = self.emotionViews[i];
        btnX = leftInsert + (i%emotionMaxCol)*btnW;
        btnY = topInset + (i/emotionMaxCol)*btnH;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    CGFloat deleBtnX, deleBtnY, deleBtnH, deleBtnW;
    deleBtnW = btnW;
    deleBtnH = btnH;
    deleBtnX = self.width - deleBtnW - leftInsert;
    deleBtnY = self.height - deleBtnH;
    self.deleteButton.frame = CGRectMake(deleBtnX, deleBtnY, deleBtnW, deleBtnH);
}






@end
