//
//  HYVideoBar.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/10/27.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYVideoBar.h"
#import "UIImage+Exstension.h"
#define StartTag 1000
#define StopTag 1200

@interface HYVideoBar()

/** 开始\暂停按钮 */
@property (nonatomic, weak) UIButton* startOrStopBtn;

/** 进度条 */
@property (nonatomic, weak) UIProgressView* progressView;

/** 显示时间进度 */
@property (nonatomic, weak) UILabel* progressTime;

/** 放大按钮 */
@property (nonatomic, weak) UIButton* toBigBtn;

@end

@implementation HYVideoBar

+ (instancetype)videoBar{
    return [[HYVideoBar alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [self setupStartOrStopBtn];
        [self setupProgressView];
        [self setupProgressTime];
        [self setupTpBigButton];
    }
    return self;
}

- (void)setFull:(Boolean)full{
    _full = full;
    if (full == YES) {
        self.toBigBtn.hidden = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat leftMargin = 5;
    CGFloat btnW = 20;
    CGFloat topMarin = 5;
    CGFloat btnH = (self.height - 2*topMarin);
    self.startOrStopBtn.frame = CGRectMake(leftMargin, topMarin, btnW, btnH);
    
    CGFloat timeX, timeY, timeW, timeH;
    timeY = topMarin;
    timeW = 30;
    timeH = btnH;
    
    CGFloat progressX, progressY, progressW, progressH;
    if (self.isFull) {
        self.toBigBtn.frame = CGRectZero;
        timeX = self.width - leftMargin - timeW;
    
    } else {
        self.toBigBtn.frame = CGRectMake(self.width - leftMargin - btnW, topMarin, btnW, btnH);
        timeX = self.toBigBtn.x - timeW;
    }
    self.progressTime.frame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat maxStartOrStopBtnX = CGRectGetMaxX(self.startOrStopBtn.frame);
    progressW = self.progressTime.x - maxStartOrStopBtnX - leftMargin * 2;
    progressX = maxStartOrStopBtnX + leftMargin;
    progressY = self.height * 0.5;
    self.progressView.frame = CGRectMake(progressX, progressY, progressW, progressH);
}

#pragma mark - target
- (void)statOrStop:(UIButton*)sender{
    if (self.startOrStopBtn.tag == StopTag) { // 让视频暂停
        [_startOrStopBtn setImage:[UIImage imageWithOriginalName:@"video_play_btn_bg"] forState:UIControlStateNormal];
        _startOrStopBtn.tag = StartTag;
        [self.deleagate stopVideo];
        
    } else if(_startOrStopBtn.tag == StartTag) {  // 让视频开始
        [_startOrStopBtn setImage:[UIImage imageWithOriginalName:@"time"] forState:UIControlStateNormal];
        _startOrStopBtn.tag = StopTag;
        [self.deleagate startVideo];
    }
}

- (void)toBig{
    [self.deleagate toBig];
}

- (void)setProgressTimeWithCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime{
    NSString* timeStr = [NSString stringWithFormat:@"%02d/%02ds", (int)currentTime, (int)totalTime];
    self.progressTime.text = timeStr;
    self.progressView.progress = currentTime / totalTime;
}

#pragma mark - init

/** 设置进度时间 */
- (void)setupProgressTime{
    UILabel* progressTime = [[UILabel alloc] init];
    progressTime.text = @"00/00s";
    progressTime.font = [UIFont systemFontOfSize:7];
    progressTime.textColor = [UIColor whiteColor];
    progressTime.backgroundColor = [UIColor clearColor];
    [self addSubview:progressTime];
    self.progressTime = progressTime;
}

/** 设置进度条 */
- (void)setupProgressView{
    UIProgressView* progressView = [[UIProgressView alloc] init];
    progressView.progress = 0.0;
    progressView.progressViewStyle = UIProgressViewStyleBar;
    // 显示进度的颜色
    progressView.progressTintColor = [UIColor greenColor];
    // 全局的颜色
    progressView.trackTintColor = [UIColor grayColor];
    [self addSubview:progressView];
    self.progressView = progressView;
}

/** 设置开始\暂停按钮 */
- (void)setupStartOrStopBtn{
    UIButton* startOrStopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [startOrStopBtn setImage:[UIImage imageWithOriginalName:@"time"] forState:UIControlStateNormal];
    [startOrStopBtn setBackgroundColor:[UIColor clearColor]];
    [startOrStopBtn addTarget:self action:@selector(statOrStop:) forControlEvents:UIControlEventTouchUpInside];
    startOrStopBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:startOrStopBtn];
    startOrStopBtn.tag = StopTag;
    _startOrStopBtn = startOrStopBtn;
}

/** 设置放大按钮 */
- (void)setupTpBigButton{
    UIButton* toBigBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [toBigBtn setImage:[UIImage imageWithOriginalName:@"toBig"] forState:UIControlStateNormal];
    [toBigBtn setBackgroundColor:[UIColor clearColor]];
    [toBigBtn addTarget:self action:@selector(toBig) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:toBigBtn];
    _toBigBtn = toBigBtn;
}




@end
