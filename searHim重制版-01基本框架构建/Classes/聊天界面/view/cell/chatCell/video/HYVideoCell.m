//
//  HYVideoCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYVideoCell.h"
#import "HYVideoItemFrame.h"
#import "HYVideoItem.h"
#import "HYVideoPlayer.h"
#import "UIButton+WebCache.h"

@interface HYVideoCell()
/** 视频播放器 */
@property (nonatomic, weak) HYVideoPlayer* videoPlayer;

@end

@implementation HYVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置头像的属性
        self.iconBtn.tag = cellBtnTypeIcon;
        [self.iconBtn addTarget:self action:@selector(iconOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self setupVideoPlayer];
    }
    return self;
}

- (void)setupVideoPlayer{
    HYVideoPlayer* videoPlayer = [[HYVideoPlayer alloc] init];
    [self.contentView addSubview:videoPlayer];
    self.videoPlayer = videoPlayer;
}

- (void)setupSkillView:(UILongPressGestureRecognizer*)longPreG{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.videoItemFrame.baseChatItem.row) forKey:@"row"];
    [dict setValue:self.videoItemFrame forKey:@"itemFrame"];
    //通知控制器显示skillView
    [[NSNotificationCenter defaultCenter] postNotificationName:HYWantTtitleSkillView object:nil userInfo:dict];
}

- (void)iconOnClick{
    [self.delegate cell:self didClickBtnType:(int)self.iconBtn.tag WithBtn:self.iconBtn Item:(HYVideoItem*)self.videoItemFrame.baseChatItem];
}


- (void)setVideoItemFrame:(HYVideoItemFrame *)videoItemFrame{
    _videoItemFrame = videoItemFrame;

    HYVideoItem* videoItem = (HYVideoItem*)self.videoItemFrame.baseChatItem;
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:videoItem.iconUrl] forState:UIControlStateNormal placeholderImage:HYSystemIcon];
    self.timeLa.text = videoItem.lastMessageAtString;

    self.videoPlayer.videoItemFrame = videoItemFrame;
}

+ (HYBaseChatCell *)cellForTableView:(UITableView *)tableView andItem:(HYBaseChatItemFrame *)baseChatItemFrame{
    static NSString* videoCellId = @"videoCellId";
    HYVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:videoCellId];
    if (!cell) {
        cell = [[HYVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellId];
    }
    cell.videoItemFrame = (HYVideoItemFrame*)baseChatItemFrame;
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.timeLa.frame = self.videoItemFrame.timeFrame;
    self.iconBtn.frame = self.videoItemFrame.iconFrame;
    self.videoPlayer.frame = self.videoItemFrame.videoFrame;
}



@end
