//
//  HYSkillView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/8/5.
//  Copyright © 2016年 黄远. All rights reserved.
//  展示蒙板，功能按钮（复制、删除、转发)

#import <UIKit/UIKit.h>
#define skillBtnHei 44
@class HYBaseChatItem;
@protocol HYSkillViewDeleagte <NSObject>
//点击了转发（把内容传给代理，让代理转发）
- (void)didClickSendOtherBtn:(HYBaseChatItem*)baseItem;

@end

@interface HYSkillView : UIView

+ (instancetype)skillView;
@property (nonatomic, weak) id<HYSkillViewDeleagte> deleagte;

@property (nonatomic, strong) HYBaseChatItem* baseChatItem;
//黑色蒙板
@property (nonatomic, weak) UIButton* meng;
//白色蒙板
@property (nonatomic, weak) UIView* whiteMen;

//移除view
- (void)tapG;


//转发
- (void)sendOther;

//删除（发通知让控制器删除对应的模型，cell）
- (void)dele;

- (void)setupSubViews;

@end
