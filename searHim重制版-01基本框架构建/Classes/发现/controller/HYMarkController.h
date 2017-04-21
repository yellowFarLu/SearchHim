//
//  HYMarkController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/18.
//  Copyright © 2016年 黄远. All rights reserved.
//  展示历史记录

#import "HYCommonTableViewController.h"

@class HYMarkController;

@protocol HYMarkControllerDelegate <NSObject>
@required
- (void)didSelectMark:(NSString*)mark;
- (void)closeMarkVC;
@end


@interface HYMarkController : HYCommonTableViewController

@property (nonatomic, weak) id<HYMarkControllerDelegate> delegate;

@end
