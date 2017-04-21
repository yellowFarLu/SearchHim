//
//  HYContentCell.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/15.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import "HYBaseChatCell.h"

@class HYContentItemFrame;

@interface HYContentCell : HYBaseChatCell

//点击弹出气泡(控制器的有一层透明黑色屏幕，中间白色框框有复制，转发，删除)
@property (nonatomic, weak) UIButton* contentBtn;

@property (nonatomic, strong) HYContentItemFrame* contentItemFrame;

@end
