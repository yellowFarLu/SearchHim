//
//  HYMoreItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/19.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYMoreItem : NSObject
//功能的名字
@property (nonatomic, copy) NSString* title;

//功能的配图
@property (nonatomic, strong) UIImage* icon;

@property (nonatomic, assign) int btnType;

+ (instancetype)initWithTitle:(NSString*)title AndIconName:(NSString*)icon btnType:(int)btnType;

@end
