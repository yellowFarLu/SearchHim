//
//  HYBaseChatItemFrame.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/16.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HYBaseChatItem;
@interface HYBaseChatItemFrame : NSObject

@property (nonatomic, strong) HYBaseChatItem* baseChatItem;

@property (nonatomic, assign) CGRect timeFrame;

@property (nonatomic, assign) CGRect iconFrame;

@property (nonatomic, assign) CGPoint indicatorViewCenter;

//行高
@property (nonatomic, assign) CGFloat height;

@end
