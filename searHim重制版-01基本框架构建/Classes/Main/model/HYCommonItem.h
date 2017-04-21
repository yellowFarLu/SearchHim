//
//  HYCommonItem.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/5.
//  Copyright © 2016年 黄远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCommonItem : NSObject

@property (nonatomic, copy) NSString* iconUrl;
@property (nonatomic, strong) NSDate* severTime;
//由severTime转换成time
@property (nonatomic, copy) NSString* time;
@property (nonatomic, assign, getter=isShowTime) BOOL showTime;

@end
