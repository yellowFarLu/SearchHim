//
//  HYCommonAlertVew.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//  用于自定义控件作为修改信息

#import "HYBaseAlertView.h"

@interface HYCommonAlertVew : HYBaseAlertView

- (void)textFieldBecomeFirstRespoinder;

- (void)textFieldLostFirstRespoinder;

- (UITextField*)valueTextFied;

@property (nonatomic, copy) NSString* pacehoder;
@end
