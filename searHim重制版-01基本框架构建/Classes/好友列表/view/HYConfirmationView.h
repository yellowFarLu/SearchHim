//
//  HYConfirmationView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/11.
//  Copyright © 2016年 黄远. All rights reserved.
//  发送验证信息的view

#import <UIKit/UIKit.h>

@class HYConfirmationView;

@protocol HYConfirmationViewDelegate <NSObject>

- (void)confirmationView:(HYConfirmationView*)confirmationView WithTextViewLenth:(NSInteger)length;

@end


@interface HYConfirmationView : UIView
+ (instancetype)confirmationView;
@property (nonatomic, weak) id<HYConfirmationViewDelegate> delegate;

- (NSString*)getValue;

@end
