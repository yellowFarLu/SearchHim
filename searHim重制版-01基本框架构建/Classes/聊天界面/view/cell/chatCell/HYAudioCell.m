//
//  HYAudioCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYAudioCell.h"
#import "HYAudioItem.h"
#import "HYAudioItemFrame.h"
#import "UIImage+Exstension.h"
#import "UIButton+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#define HYReloadAudio @"播放当前音频，关闭其他音频"

@interface HYAudioCell () <AVAudioPlayerDelegate>
//录音按钮
@property (nonatomic, weak) UIButton* audioRecorderBtn;
//录音时长
@property (nonatomic, weak) UILabel* audioTimeLabel;
@property (nonatomic, strong) AVAudioPlayer* audioPlayer;
@end

@implementation HYAudioCell

- (void)setupSkillView:(UILongPressGestureRecognizer*)longPreG{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.audioItemFrame.baseChatItem.row) forKey:@"row"];
    [dict setValue:self.audioItemFrame forKey:@"itemFrame"];
    //通知控制器显示skillView
    [[NSNotificationCenter defaultCenter] postNotificationName:HYWantTtitleSkillView object:nil userInfo:dict];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconBtn.tag = cellBtnTypeIcon;
        [self.iconBtn addTarget:self action:@selector(iconOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)iconOnClick{
    [self.delegate cell:self didClickBtnType:(int)self.iconBtn.tag WithBtn:self.iconBtn Item:(HYAudioItem*)self.audioItemFrame.baseChatItem];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.timeLa.frame = self.audioItemFrame.timeFrame;
    self.iconBtn.frame = self.audioItemFrame.iconFrame;
    self.audioRecorderBtn.frame = self.audioItemFrame.audioBtnFrame;
    self.audioTimeLabel.frame = self.audioItemFrame.audioTimeFrame;
}

- (void)setAudioItemFrame:(HYAudioItemFrame *)audioItemFrame{
    // 先把原来的停了
//    if (_audioPlayer) {
//        [_audioPlayer pause];
//        _audioPlayer = nil;
//    }
    
    _audioItemFrame = audioItemFrame;
    HYAudioItem* audioItem = (HYAudioItem*)audioItemFrame.baseChatItem;
    self.audioTimeLabel.text = [NSString stringWithFormat:@"%d”", (int)audioItem.audioTime];
    UIImage* normolIma = nil;
    UIImage* selectIma = nil;
    if ([audioItem isMe]) {
        normolIma = [UIImage resizeImageWithOriginalName:@"chatto_bg_normal"];
        selectIma = [UIImage resizeImageWithOriginalName:@"chatto_bg_focused"];
    }else{
        normolIma = [UIImage resizeImageWithOriginalName:@"chatfrom_bg_normal"];
        selectIma = [UIImage resizeImageWithOriginalName:@"chatfrom_bg_focused"];
    }
    [self.audioRecorderBtn setBackgroundImage:normolIma forState:UIControlStateNormal];
    [self.audioRecorderBtn setBackgroundImage:selectIma forState:UIControlStateHighlighted];
    
    //动态播放录音的图片
    UIImage* autoIma = [UIImage imageNamed:@"fs_icon_wave_2"];
    [self.audioRecorderBtn setImage:autoIma forState:UIControlStateNormal];
    if ([audioItem isMe]) {
        self.audioRecorderBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        self.audioRecorderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.audioRecorderBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2*HYSearHimInset);
    }else{
        self.audioRecorderBtn.imageView.transform = CGAffineTransformIdentity;
        self.audioRecorderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.audioRecorderBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 2*HYSearHimInset, 0, 0);
    }
    self.timeLa.text = audioItem.lastMessageAtString;
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:audioItem.iconUrl] forState:UIControlStateNormal placeholderImage:HYSystemIcon];
    
    if ([audioItem isListen]) {
        [self beginPlay];
    }
}

+ (HYBaseChatCell *)cellForTableView:(UITableView *)tableView andItem:(HYBaseChatItemFrame *)baseChatItemFrame{
    static NSString* audioCellId = @"audioCellId";
    HYAudioCell* cell = [tableView dequeueReusableCellWithIdentifier:audioCellId];
    if (!cell) {
        cell = [[HYAudioCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:audioCellId];
    }
    cell.audioItemFrame = (HYAudioItemFrame*)baseChatItemFrame;
    return cell;
}

- (UIButton *)audioRecorderBtn{
    if (!_audioRecorderBtn) {
        UIButton* audioRecorderBtn = [[UIButton alloc] init];
        [audioRecorderBtn addTarget:self action:@selector(sendNotificationToSinggleVC) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:audioRecorderBtn];
        _audioRecorderBtn = audioRecorderBtn;
    }
    return _audioRecorderBtn;
}

- (UILabel *)audioTimeLabel{
    if (!_audioTimeLabel) {
        UILabel* audioTimeLabel = [[UILabel alloc] init];
        audioTimeLabel.font = HYValueFont;
        audioTimeLabel.textColor = [UIColor lightGrayColor];
        audioTimeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:audioTimeLabel];
        _audioTimeLabel = audioTimeLabel;
    }
    return _audioTimeLabel;
}

- (void)sendNotificationToSinggleVC{
    HYAudioItem* audioItem = (HYAudioItem*)self.audioItemFrame.baseChatItem;
    //发送通知让singleVC控制器刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:HYReloadAudio object:nil userInfo:@{@"row" : @(audioItem.row)}];
}

//播放音频
- (void)beginPlay{
    //开启动画
    [self startAnimating];
    if ([self.audioRecorderBtn.imageView isAnimating]) {
        HYAudioItem* audioItem = (HYAudioItem*)self.audioItemFrame.baseChatItem;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioItem.audio error:nil];
        self.audioPlayer.volume = 1.0;
        self.audioPlayer.delegate = self;
        //播放音频
        [self.audioPlayer play];
        // 为了下次刷新不再播放
        [self cancelListen];
    }
}

- (void)startAnimating
{
    if (!self.audioRecorderBtn.imageView.isAnimating) {
        UIImage *image0 = [[UIImage imageNamed:@"fs_icon_wave_0"] imageWithOverlayColor:[UIColor lightGrayColor]];
        UIImage *image1 = [[UIImage imageNamed:@"fs_icon_wave_1"] imageWithOverlayColor:[UIColor lightGrayColor]];
        UIImage *image2 = [[UIImage imageNamed:@"fs_icon_wave_2"] imageWithOverlayColor:[UIColor lightGrayColor]];
        self.audioRecorderBtn.imageView.animationImages = @[image0, image1, image2];
        self.audioRecorderBtn.imageView.animationDuration = 1.0;
        [self.audioRecorderBtn.imageView startAnimating];
    }else{
        [self.audioRecorderBtn.imageView stopAnimating];
        [self.audioPlayer stop];
        self.audioPlayer = nil;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self.audioRecorderBtn.imageView stopAnimating];
    [self cancelListen];
    self.audioPlayer = nil;
}

/** 取消正在听的状态 */
- (void)cancelListen{
    HYAudioItem* audioItem = (HYAudioItem*)self.audioItemFrame.baseChatItem;
    audioItem.listen = NO;
}

- (void)dealloc
{
    [self cancelListen];
}

@end
