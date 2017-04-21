//
//  HYContentCell.m
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYContentCell.h"
#import "HYContentItem.h"
#import "UIButton+WebCache.h"
#import "UIImage+Exstension.h"
#import "HYContentItemFrame.h"


@interface HYContentCell ()

@end

@implementation HYContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconBtn.tag = cellBtnTypeIcon;
        [self.iconBtn addTarget:self action:@selector(iconOnClick) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return self;
}

- (void)setupSkillView:(UILongPressGestureRecognizer*)longPreG{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.contentItemFrame.baseChatItem.row) forKey:@"row"];
    [dict setValue:self.contentItemFrame forKey:@"itemFrame"];
    //通知控制器显示skillView
    [[NSNotificationCenter defaultCenter] postNotificationName:HYWantTtitleSkillView object:nil userInfo:dict];
}

- (void)iconOnClick{
    [self.delegate cell:self didClickBtnType:(int)self.iconBtn.tag WithBtn:self.iconBtn Item:(HYContentItem*)self.contentItemFrame.baseChatItem];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.timeLa.frame = self.contentItemFrame.timeFrame;
    self.iconBtn.frame = self.contentItemFrame.iconFrame;
    self.contentBtn.frame = self.contentItemFrame.contentFrame;
    self.indicatorView.center = self.contentItemFrame.indicatorViewCenter;
}

+ (HYBaseChatCell *)cellForTableView:(UITableView *)tableView andItem:(HYBaseChatItemFrame *)baseChatItemFrame{
    static NSString* chatCellID = @"contentChatCell";
    HYContentCell* cell = [tableView dequeueReusableCellWithIdentifier:chatCellID];
    if (!cell) {
        cell = [[HYContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCellID];
    }
    cell.contentItemFrame = (HYContentItemFrame*)baseChatItemFrame;
    return cell;
}

- (void)setContentItemFrame:(HYContentItemFrame *)contentItemFrame{
    _contentItemFrame = contentItemFrame;
    HYContentItem* contentItem = (HYContentItem*)contentItemFrame.baseChatItem;
    [self.iconBtn sd_setImageWithURL:[NSURL URLWithString:contentItem.iconUrl] forState:UIControlStateNormal placeholderImage:HYSystemIcon];
    [self.contentBtn setAttributedTitle:contentItem.content forState:UIControlStateNormal];
    self.timeLa.text = contentItem.lastMessageAtString;
    
    //设置背景图片
    UIImage* norIma;
    UIImage* heightIma;
    if ([contentItem isMe]) {
        norIma = [UIImage imageNamed:@"chatto_bg_normal"];
        heightIma = [UIImage imageNamed:@"chatto_bg_focused"];
    } else {
        norIma = [UIImage imageNamed:@"chatfrom_bg_normal"];
        heightIma = [UIImage imageNamed:@"chatfrom_bg_focused"];
    }
    //设置拉伸r
    norIma = [norIma stretchableImageWithLeftCapWidth:norIma.size.width*0.5 topCapHeight:norIma.size.height*0.7];
    heightIma = [heightIma stretchableImageWithLeftCapWidth:heightIma.size.width*0.5 topCapHeight:heightIma.size.height*0.7];
    [self.contentBtn setBackgroundImage:norIma forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:heightIma forState:UIControlStateHighlighted];
     self.contentBtn.contentEdgeInsets = UIEdgeInsetsMake(7.5, 20, 7.5, 20);
    
    if ([contentItem isShowIndicator]) {
        [self.indicatorView startAnimating];
        self.indicatorView.hidden = NO;
    }else{
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
    }
}

- (UIButton*)contentBtn{
    if (!_contentBtn) {
        UIButton* contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        contentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        contentBtn.titleLabel.numberOfLines = 0;
        [self addSubview:contentBtn];
        _contentBtn = contentBtn;
    }
    return _contentBtn;
}



@end
