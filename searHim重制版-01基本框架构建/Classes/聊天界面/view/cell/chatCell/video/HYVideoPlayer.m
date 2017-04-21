//
//  HYVideoPlayer.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/11/9.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYVideoPlayer.h"
#import <AVKit/AVKit.h>
#import "HYVideoBar.h"
#import "HYVideoItemFrame.h"
#import "HYVideoItem.h"
#import "UIImage+BgIma.h"
#define HYReloadVideo @"播放当前视频，关闭其他视频"

@interface HYVideoPlayer () <HYVideoBarDelegate>
#pragma mark - 小视频
@property (nonatomic, strong) AVPlayerViewController* playerVC;
@property (nonatomic, strong) AVPlayer* player;
/** 展示视频发送状态 */
@property (nonatomic, weak) UIProgressView* proView;

#pragma mark - 大视频
/** 全屏的视频播放器 为了让cell的设置和全屏播放器的设置分离开 */
@property (nonatomic, strong) AVPlayerViewController* fullPlayerVC;

@property (nonatomic, strong) AVPlayer* fullPlayer;

/** 全屏视频的背景 */
@property (nonatomic, weak) UIView* bgView;

/** 全屏视频关闭按钮 */
@property (nonatomic, weak) UIButton* closeBtn;

/** 全屏的videoBar */
@property (nonatomic, weak) HYVideoBar* fullVideoBar;

#pragma mark - 大视频和小视频共有的
/** 视频暂停时，显示播放到哪的图片 */
@property (nonatomic, strong) UIImageView* bgImaV;

/** 视频暂停时，显示开始播放按钮 */
@property (nonatomic, strong) UIButton* beginBtn;

/** 视频资源不存在时，显示视频已经被清除按钮 */
@property (nonatomic, strong) UIButton* videoHasDeleBtn;

/** 视频播放条（暂停按钮、进度条、时间、放大按钮） */
@property (nonatomic, weak) HYVideoBar* videoBar;

@end

@implementation HYVideoPlayer

#pragma mark - init 初始化

- (UIImageView *)bgImaV{
    if (!_bgImaV) {
        UIImageView* bgImaV = [[UIImageView alloc] init];
        [self addSubview:bgImaV];
        bgImaV.layer.cornerRadius = HYCornerRadius;
        bgImaV.clipsToBounds = YES;
        _bgImaV = bgImaV;
    }
    return _bgImaV;
}

- (UIButton *)videoHasDeleBtn{
    if (!_videoHasDeleBtn) {
        UIButton* videoHasDeleBtn = [[UIButton alloc] init];
        videoHasDeleBtn.backgroundColor = [UIColor lightGrayColor];
        [videoHasDeleBtn setTitle:@"视频已被清理" forState:UIControlStateNormal];
        videoHasDeleBtn.layer.cornerRadius = HYCornerRadius;
        videoHasDeleBtn.clipsToBounds = YES;
        _videoHasDeleBtn = videoHasDeleBtn;
    }
    return _videoHasDeleBtn;
}

- (UIButton *)beginBtn{
    if (!_beginBtn) {
        UIButton* beginBtn = [[UIButton alloc] init];
        [beginBtn setImage:[UIImage imageNamed:@"playcount"] forState:UIControlStateHighlighted];
        [beginBtn setImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
        [self addSubview:beginBtn];
        [beginBtn addTarget:self action:@selector(notificationSingleVC) forControlEvents:UIControlEventTouchUpInside];
        _beginBtn = beginBtn;
    }
    return _beginBtn;
}


#pragma mark - target 监听
- (void)setVideoItemFrame:(HYVideoItemFrame *)videoItemFrame{
    
    //在cell循环利用的使用，把原来的清空，通过模型，创建对应的视频
    //如果观察者信息不为空，证明player被原来的cell观察着呢
    id obserInfo = [self.player observationInfo];
    //    HYLog(@"观察则信息 -------------- %@", obserInfo);
    if (obserInfo) {
        [self.player removeObserver:self forKeyPath:@"rate"];
    }
    [self.playerVC.view removeFromSuperview];
    self.player = nil;
    self.playerVC = nil;
    
    //只要更新cell的信息，停止播放状态
    _videoItemFrame = videoItemFrame;
    HYVideoItem* videoItem = (HYVideoItem*)self.videoItemFrame.baseChatItem;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:videoItem.videoUrl];
    if (result) {
        [self.bgImaV setImage:videoItem.videoBgIma];
        [self addSubview:self.bgImaV];
        [self addSubview:self.beginBtn];
    } else if (videoItem.proViewHidden) {
        [self.bgImaV removeFromSuperview];
        [self.beginBtn removeFromSuperview];
        [self addSubview:self.videoHasDeleBtn];
    }
    
    [self.bgImaV setImage:videoItem.videoBgIma];
    if (videoItem.proViewHidden) {
        self.proView.hidden = YES;
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.proView.hidden = NO;
            [self.proView setProgress:videoItem.sliderValue animated:YES];
        } completion:^(BOOL finished) {
            if (finished) {
                HYVideoItem* videoItem = (HYVideoItem*)videoItemFrame.baseChatItem;
                if (videoItem.sliderValue == 1.0) {
                    self.proView.hidden = YES;
                }
            }
        }];
    }
    
    if ([videoItem isSeeing]) {
        //查看当前视频是否还存在
        if (result) {
            [self reWatch];
        }
    }
}


/** 之前是播放状态，再次播放 */
- (void)reWatch{
    HYVideoItem* videoItem = (HYVideoItem*)self.videoItemFrame.baseChatItem;
    if (videoItem.videoUrl) {
        NSURL *url = [NSURL fileURLWithPath:videoItem.videoUrl];
        _player = [AVPlayer playerWithURL:url];
    }else{
        _player = [[AVPlayer alloc] init];
    }
    
    // 寻找之前播放到哪一帧
    [_player seekToTime:videoItem.time];
    [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    _playerVC = [[AVPlayerViewController alloc] init];
    _playerVC.player = self.player;
    _playerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _playerVC.showsPlaybackControls = NO;
    _playerVC.view.layer.cornerRadius = HYCornerRadius;
    _playerVC.view.clipsToBounds = YES;
    _playerVC.view.frame = self.bounds;
    [self addSubview:_playerVC.view];
    [self.bgImaV removeFromSuperview];
    [self.beginBtn removeFromSuperview];
    [_player play];
    
    /** 监听播放进度 */
    // 每隔一秒监听播放进度
    CMTime interval = CMTimeMake(1, 1);
    AVPlayerItem *theItem=_player.currentItem;
    __weak typeof(self) weakSelf = self;
    [_player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_current_queue() usingBlock:^(CMTime time) {
        CGFloat durationTime=CMTimeGetSeconds(theItem.duration);
        CGFloat currentTime=CMTimeGetSeconds(time);
        [weakSelf.videoBar setProgressTimeWithCurrentTime:currentTime totalTime:durationTime];
    }];
    [self addVideoBar];
}

/** 添加播放条 */
- (void)addVideoBar{
    HYVideoBar* videoBar = [HYVideoBar videoBar];
    [_playerVC.view addSubview:videoBar];
    videoBar.deleagate = self;
    CGFloat y,h;
    h = 30;
    y = _playerVC.view.height - h;
    videoBar.frame = CGRectMake(0, y, _playerVC.view.width, h);
    _videoBar = videoBar;
}

/** 监听播放状态改变 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSNumber* new = change[@"new"];
    HYVideoItem* videoItem = (HYVideoItem*)self.videoItemFrame.baseChatItem;
    if (new.integerValue == 0) {  //停止播放
        if (_fullPlayer) {  //全屏播放一套处理方式
            // 全屏时，播放完不用自动处理，让用户点击了再处理全屏视频
            //判断当前有没有播放完
            if (!((self.fullPlayer.currentItem.currentTime.value == self.fullPlayer.currentItem.duration.value) && (self.fullPlayer.currentItem.currentTime.timescale == self.fullPlayer.currentItem.duration.timescale))) {  // 播放完
                // 没播放完
                videoItem.time = self.fullPlayer.currentItem.currentTime;
            } else {
                // 播放完了，去除大视频
                [self closeFulPaler:self.closeBtn];
            }
            
        } else {   // 局部播放一套处理方式
            //截取当前视频的图
            [self.bgImaV setImage:[UIImage getPicFromVideoUrl:[NSURL fileURLWithPath:videoItem.videoUrl] andCMTime:self.player.currentItem.currentTime]];
            
            //判断当前有没有播放完
            if ((self.player.currentItem.currentTime.value == self.player.currentItem.duration.value) && (self.player.currentItem.currentTime.timescale == self.player.currentItem.duration.timescale)) {  // 播放完
                videoItem.time = CMTimeMake(1, 1);
                [self.beginBtn setImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
                
            }else{
                // 没播放完
                videoItem.time = self.player.currentItem.currentTime;
                [self.beginBtn setImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
            }
            
            videoItem.videoBgIma = self.bgImaV.image;
            [self.bgImaV setFrame:self.videoItemFrame.videoFrame];
            [self addSubview:self.bgImaV];
            [self addSubview:self.beginBtn];
            [self.playerVC.view removeFromSuperview];
            id obserInfo = [self.player observationInfo];
            //        HYLog(@"观察则信息 -------------- %@", obserInfo);
            if (obserInfo) {
                [self.player removeObserver:self forKeyPath:@"rate"];
            }
            self.playerVC.player = nil;
            self.playerVC = nil;
            videoItem.seeing = NO;
            [_videoBar removeFromSuperview];
        }
        
    }
}

/** 播放视频 */
- (void)notificationSingleVC{
    HYVideoItem* videoItem = (HYVideoItem*)self.videoItemFrame.baseChatItem;
    // 发送通知让singleVC控制器刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:HYReloadVideo object:nil userInfo:@{@"row" : @(videoItem.row)}];
}

/** 移除监听 */
- (void)dealloc{
    if (self.player) {
        id obserInfo = [self.player observationInfo];
        //        HYLog(@"观察则信息 -------------- %@", obserInfo);
        if (obserInfo) {
            [self.player removeObserver:self forKeyPath:@"rate"];
        }
        self.player = nil;
        [self.playerVC.view removeFromSuperview];
        self.playerVC = nil;
    }
}

#pragma mark - HYVideoBarDelegate
- (void)startVideo{
    if (self.fullPlayerVC) {
        [self.fullPlayer play];
    } else {
        [self.player play];
    }
}

- (void)stopVideo{
    if (self.fullPlayerVC) {
        [self.fullPlayer pause];
    } else {
        [self.player pause];
    }
}

/** 生成一个信息视频控制器 */
- (void)toBig{
    // 小视屏暂停
    [_player pause];
    
    HYVideoItem* videoItem = (HYVideoItem*)self.videoItemFrame.baseChatItem;
    if (videoItem.videoUrl) {
        NSURL *url = [NSURL fileURLWithPath:videoItem.videoUrl];
        _fullPlayer = [AVPlayer playerWithURL:url];
    }else{
        _fullPlayer = [[AVPlayer alloc] init];
    }
    
    // 寻找之前播放到哪一帧
    [_fullPlayer seekToTime:videoItem.time];
    [_fullPlayer addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    _fullPlayerVC = [[AVPlayerViewController alloc] init];
    _fullPlayerVC.player = _fullPlayer;
    _fullPlayerVC.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _fullPlayerVC.showsPlaybackControls = NO;
    
    UIWindow* lastWindow = [[[UIApplication sharedApplication] windows] lastObject];
    // 设置背景
    [self setupBgViewWithWindow:lastWindow];
    [lastWindow addSubview:_fullPlayerVC.view];
    CGFloat topMargin = 100;
    CGFloat leftMargin = HYSearHimInset;
    _fullPlayerVC.view.frame = CGRectMake(HYSearHimInset, topMargin, (mainScreenWid-2*leftMargin), (mainScreenHei - 2*topMargin));
    
    // 设置关闭按钮
    [self setupCloseBtnWithLastWindow:lastWindow];
    
    [self setFullVideoBar];
    
    /** 监听播放进度 */
    // 每隔一秒监听播放进度
    CMTime interval = CMTimeMake(1, 1);
    AVPlayerItem *theItem=_fullPlayer.currentItem;
    __weak typeof(self) weakSelf = self;
    [_fullPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_current_queue() usingBlock:^(CMTime time) {
        CGFloat durationTime=CMTimeGetSeconds(theItem.duration);
        CGFloat currentTime=CMTimeGetSeconds(time);
        [weakSelf.fullVideoBar setProgressTimeWithCurrentTime:currentTime totalTime:durationTime];
    }];
    
    // 大视屏播放
    [_fullPlayer play];
    
}

/** 设置全屏的播放条 */
- (void)setFullVideoBar{
    HYVideoBar* videoBar = [HYVideoBar videoBar];
    [_fullPlayerVC.view addSubview:videoBar];
    videoBar.deleagate = self;
    videoBar.full = YES;
    CGFloat y,h;
    h = 44;
    y = _fullPlayerVC.view.height - h;
    videoBar.frame = CGRectMake(0, y, _fullPlayerVC.view.width, h);
    _fullVideoBar = videoBar;
}

- (void)setupCloseBtnWithLastWindow:(UIWindow*)window{
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setBackgroundColor:[UIColor grayColor]];
    closeBtn.alpha = 0.8;
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.layer.cornerRadius = HYCornerRadius;
    [window addSubview:closeBtn];
    CGFloat closeBtnX, closeBtnY, closeBtnW, closeBtnH;
    closeBtnW = 100;
    closeBtnH = 40;
    closeBtnX = self.fullPlayerVC.view.width - closeBtnW;
    closeBtnY = self.fullPlayerVC.view.y - closeBtnH;
    closeBtn.frame = CGRectMake(closeBtnX, closeBtnY, closeBtnW, closeBtnH);
    [closeBtn addTarget:self action:@selector(closeFulPaler:) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = closeBtn;
}

- (void)setupBgViewWithWindow:(UIWindow*)lastWindow{
    UIView* bgView = [[UIView alloc] init];
    bgView.alpha = 0.6;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.frame = CGRectMake(0, 0, mainScreenWid, mainScreenHei);
    [lastWindow addSubview:bgView];
    _bgView = bgView;
}

/** 消除全屏的视频(点击按钮触发) */
- (void)closeFulPaler:(UIButton*)sender{
    [UIView animateWithDuration:0.8 animations:^{
        self.bgView.alpha = 0.1;
        self.fullPlayerVC.view.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        [sender removeFromSuperview];
        [self.fullPlayerVC.view removeFromSuperview];
        self.fullPlayerVC = nil;
        [self.fullPlayer removeObserver:self forKeyPath:@"rate"];
        self.fullPlayer = nil;
    }];
}

#pragma mark - layout
- (void)layoutSubviews{
    [super layoutSubviews];
    self.beginBtn.frame = self.bounds;
    self.bgImaV.frame = self.bounds;
    self.proView.frame = CGRectMake(0, self.height - 1, self.videoItemFrame.sliderFrame.size.width, self.videoItemFrame.sliderFrame.size.height);
    self.videoHasDeleBtn.frame = self.beginBtn.frame;
}


@end
