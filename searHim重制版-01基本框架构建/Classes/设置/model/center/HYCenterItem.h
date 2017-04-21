//
//  HYCenterItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/10.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYArrowItem.h"

@interface HYCenterItem : HYArrowItem

//所在城市，邮箱，手机号后面8个*
@property (nonatomic, copy) NSString* info;
@property (nonatomic, copy) NSString* key;
- (instancetype)initWithInfo:(NSString*)info andKey:(NSString*)key;

@end
