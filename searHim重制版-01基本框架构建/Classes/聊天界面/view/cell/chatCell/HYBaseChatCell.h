//
//  HYBaseChatCell.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//  聊天cell的父类

#import <UIKit/UIKit.h>
#define HYWantTtitleSkillView @"设置skillView"
@class HYBaseChatCell, HYBaseChatItemFrame, HYBaseChatItem;

typedef enum {
    cellBtnTypeIcon,  //点击了头像
    cellBtnTypePic, //点击了图片
    cellBtnTypeCard //点击了名片
} cellBtnType;


@protocol HYChatCellDeleagte <NSObject>
@required
- (void)cell:(HYBaseChatCell*)cell didClickBtnType:(cellBtnType)type WithBtn:(UIButton*)sender Item:(HYBaseChatItem*)item;
@end

@interface HYBaseChatCell : UITableViewCell

@property (nonatomic, weak) UIButton* iconBtn;
@property (nonatomic, weak) UILabel* timeLa;
//发送指示器
@property (nonatomic, strong) UIActivityIndicatorView* indicatorView;

+ (HYBaseChatCell*)cellForTableView:(UITableView*)tableView andItem:(HYBaseChatItemFrame*)baseChatItemFrame;

@property (nonatomic, weak) id<HYChatCellDeleagte> delegate;

- (void)setupSkillView:(UILongPressGestureRecognizer*)longPreG;

@end
