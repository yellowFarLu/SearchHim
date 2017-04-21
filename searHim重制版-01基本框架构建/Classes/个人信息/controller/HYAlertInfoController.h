//
//  HYAlertInfoController.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//  根据传过来的模型，展示不同的样式

#import <UIKit/UIKit.h>
#import "HYBaseItem.h"

@class HYAlertInfoController;

@protocol HYAlertInfoControllerDelegate <NSObject>
@required
- (void)reloadForAlertInfoController:(HYAlertInfoController*)alertInfoController;

@end

@interface HYAlertInfoController : UIViewController
@property (nonatomic, strong) HYBaseItem* baseItem;

@property (nonatomic, weak) id<HYAlertInfoControllerDelegate> delegate;

@end
