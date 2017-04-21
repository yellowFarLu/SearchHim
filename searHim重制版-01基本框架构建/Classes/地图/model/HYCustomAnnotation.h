//
//  HYCustomAnnotation.h
//  searHim重制版-01基本框架构建
//
//  Created by 黄远 on 16/7/13.
//  Copyright © 2016年 黄远. All rights reserved.
//  自定义annotation

#import <MAMapKit/MAPointAnnotation.h>

@interface HYCustomAnnotation : MAPointAnnotation

//存储用户的id
@property (nonatomic, copy) NSString* objId;

@end
