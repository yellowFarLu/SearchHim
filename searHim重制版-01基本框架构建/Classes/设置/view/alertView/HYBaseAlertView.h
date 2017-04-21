//
//  HYBaseAlertView.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//  修改信息View的父类(修改心目中的她除外)

#import <UIKit/UIKit.h>

@interface HYBaseAlertView : UIView 

@property (nonatomic, copy) NSString* key;

@property (nonatomic, weak) UIView* diver;
//修改的项
@property (nonatomic, weak) UILabel* keyLable;
//返回结果
- (NSString*)getValue;



@end
